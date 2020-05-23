# main file for the BAE implementation

using WAV
using LinearAlgebra
using FFTW
using Plots

#=
function BAE_CQT(signal; f0=8, fm=fs/2, b=2.2, fs=16000, K=20)
    ## constants
    Q = 2^(1 / K) - 2^(-1 / K); # from Pan et al. (2018)
    a = 25 / 46; # for Hamming windows

    ## functions
    f(k) = f0 .* (2).^(k ./ b);
    B(k) = f(k) ./ Q;
    N(k) = (fs ./ f(k)) .* Q;
    W(k, n) = a .+ (1 .- a) .* cos.(2 .* π .* n ./ N(k));
    CQT(s, k) = N(k)^(-1) .* W(k, 1:round(Int, N(k))) .* s[1:round(Int, N(k))] .* exp.(-2im .* π .* k .* (1:round(Int, N(k))) ./ N(k));
    #CQT(s, k) = N(k)^(-1) .* sum(W(k, 1:round(Int, N(k))) .* s[1:round(Int, N(k))] .* exp.(-2im .* π .* k .* (1:round(Int, N(k))) ./ N(k)));

    ## algorithm
    F_k = [];
    X_k = [];
    ML = 0;

    for k = 1:K
        push!(F_k, f(k));
        push!(X_k, CQT(signal, k) ./ f(k));
        if length(X_k[end]) > ML
            ML = length(X_k[end]);
        end
    end

    ## dumb refactoring because IFFT and julia's referencing systems are odd
    G_k = [X_k[1]; (zeros(ML - length(X_k[1])) .+ 0im)];

    for k = 2:K
        G_k = [G_k [X_k[k]; (zeros(ML - length(X_k[k])) .+ 0im)]];
    end

    F_k, G_k';
end
=#

function BAE_CQT(signal; f0=8, fm=fs/2, b=2.2, fs=16000)
    ## constants
    K = ceil(Int, b * log2(fm / f0));
    Q = 2^(1 / K) - 2^(-1 / K); # from Pan et al. (2018)
    a = 25 / 46; # for Hamming windows

    ## functions
    f(k) = f0 .* (2).^(k ./ b);
    B(k) = f(k) ./ Q;
    N(k) = (fs ./ f(k)) .* Q;
    W(k, n) = a .+ (1 .- a) .* cos.(2 .* π .* n ./ N(k));
    #CQT(s, k) = N(k)^(-1) .* W(k, 1:round(Int, N(k))) .* s[1:round(Int, N(k))] .* exp.(-2im .* π .* k .* (1:round(Int, N(k))) ./ N(k));
    CQT(s, k) = round(Int, N(k))^(-1) .* sum(W(k, 1:round(Int, N(k))) .* s[1:round(Int, N(k))] .* exp.(-2im .* π .* k .* (1:round(Int, N(k))) ./ round(Int, N(k))));

    ## algorithm
    F_k = [];
    X_k = [];
    ML = 0;

    for k = 1:K
        push!(F_k, f(k));
        cqt = CQT(signal, k);
        cqt = map(z -> isnan(z) ? 0. + 0im : z, cqt);
        push!(X_k, cqt);
        if length(X_k[end]) > ML
            ML = length(X_k[end]);
        end
    end

    ## dumb refactoring because IFFT and julia's referencing systems are odd
    G_k = [X_k[1]; (zeros(ML - length(X_k[1])) .+ 0im)];

    for k = 2:K
        G_k = [G_k [X_k[k]; (zeros(ML - length(X_k[k])) .+ 0im)]];
    end

    F_k, G_k';
end

function BAE_convolve_signal_with_CQT(x, X_k)
    ## algorithm
    ϕ = x[1:end];
    for k = 1:size(X_k)[1]-1
        ϕ_n = [x[(k + 1):end]; zeros(length(x) - length((k + 1):length(x)))];
        ϕ = [ϕ ϕ_n];
    end
    ϕ = ϕ';

    F_k = ifft(X_k[:,:], 2);

    y_k = [];
    for k = 1:size(X_k)[1]
        push!(y_k, map(z -> sum(z .* abs.(F_k[k,:])), ϕ[k,:]));
    end

    y_k;
end

function BAE_get_spike_windows(y_k; l=20, s = l/2) # l & s taken roughly from Pan et al. 2018's results
    y_k = y_k[1:20];

    ## pad matrix for stride sizes
    padding = zeros(l - rem(length(y_k[1]), l));
    y_k = map(z -> [z; padding], y_k);

    ## functions
    E(w) = log(sum(w .^ 2));

    ## algorithm
    e = [];

    for y in y_k
        r = [];

        for i = 1:ceil(Int, length(y) / l)
            window = [];

            for j = 1:(l / s)
                stride_start = convert(Int, (i - 1) * l + (j - 1) * s + 1);
                stride_end = convert(Int, stride_start + s - 1);

                append!(window, y[stride_start:stride_end]);
            end

            push!(r, E(window));
        end

        push!(e, r);
    end

    e;
end

function BAE_get_audio_file(s::String)
    f, fs = wavread(s);
    f, fs;
end

function BAE_amplify(f, fs)
    f * fs;
    #f;
end

function BAE_simultaneous_mask(m, F)
    ## functions
    T_a(f) = 3.64 .* (1e-3 .* f).^(-0.8) .- 6.5 .* exp.(.-0.6 .* ((1e-3 .* f) .- 3.3).^2) .+ 1e-3 .* (1e-3 .* f).^4;

    ## algorithm
    tf = BAE_stm(map(f -> T_a(F), zeros(size(m)[2])))';
    mask = ones(size(m));

    for i = 1:size(m)[1]
        for j = 1:size(m)[2]
            mask[i,j] = m[i,j] >= tf[i,j] ? 1 : 0;
        end
    end

    mask;
end

function BAE_temporal_mask(m)
    ## functions
    # taken from Ambikairajah et al., 2001
    τ = 8e-3;
    y(n, p1) = exp(-τ)^n * p1;

    ## algorithm
    mask = ones(size(m));

    for i = 1:size(m)[1]
        last_peak = 0;
        last_i = 0;

        for j = 1:size(m)[2]
            if m[i,j] >= y(j - last_i, last_peak)
                last_peak = m[i,j];
                last_i = j;
            end
            mask[i,j] = last_i == j ? 1 : 0;
        end
    end

    mask;
end

function BAE_encode(f, fs)
    f = BAE_amplify(f, fs);
    F_k, X_k = BAE_CQT(f; fs=fs, b=2.99, f0=15, fm=8000);
    y_k = BAE_convolve_signal_with_CQT(f, X_k);
    e = BAE_get_spike_windows(y_k);
    m = BAE_stm(e);

    mask_simultaneous = BAE_simultaneous_mask(m, F_k[1:20]);
    mask_temporal = BAE_temporal_mask(m);
    mask = mask_simultaneous .* mask_temporal;

    plot_spectrogram(m, 1:20, "E(y_k(X_k(f))); no masks");
    plot_spectrogram(mask, 1:20, "Mask_sim(m) .* Mask_temp(m)");

    encoded = m .* mask;

    plot_spectrogram(encoded, 1:20, "Encoded spike train");

    println(F_k);
end

function BAE_stm(s)
    m = Matrix{Float64}(undef, size(s)[1], length(s[1]));

    for i = 1:size(s)[1]
        j = 0;

        for js in s[i]
            j = j + 1;
            m[i,j] = js;
        end
    end

    m;
end

function plot_spectrogram(m, F, t)
    gr();
    display(heatmap(
        (1:size(m)[2]) .* 2 .* 1e-3,
        F,
        m,
        c=cgrad([:blue, :red, :yellow]),
        xlabel="t(s), in seconds", ylabel="Frequency bins",
        title=t
    ));
end
