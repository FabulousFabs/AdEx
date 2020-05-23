# main file for testing the BAE implementation as detailed in Pan et al. (2020)

using FFTW
using LinearAlgebra

function my_DFT(signal)
    # dft
    N = size(signal)[1];
    ns = collect(1:N);
    ks = reshape(ns, (N, 1));
    fft_out::Vector{Complex{Float64}} = [];

    for k in ks
        transform = exp.(-1im .* 2 .* pi .* k .* (0:N-1) ./ N);
        push!(fft_out, sum(signal .* transform) / N);
    end

    fft_out;
end

#=
function my_CQT(signal)
    # cqt
    b = 20;
    f0 = 4;
    Q = 1 / (2^(1/12) - 1);
    h(n::Int64, M::Int64; a_0::Float64 = 25. / 46., a_1::Float64 = 1 - a_0) = a_0 + a_1 * cos((2 * π * n) / M);

    N = size(signal)[1];
    ns = collect(1:b);
    ks = reshape(ns, (b, 1));
    cqt_out::Vector{Complex{Float64}} = [];

    for k in ks
        freq = f0 * 2^(k/b);
        N_k = ceil(Int, (N * Q) / freq);
        if N_k > size(signal)[1]
            #N_k = size(signal)[1];
            signal = [signal;zeros(N_k - size(signal)[1])];
        end

        transform = exp.(-2im .* pi .* Q .* (0:N_k-1) ./ N_k);
        out = sum(h(k, N) .* signal[1:N_k] .* transform) ./ N;

        push!(cqt_out, out);
    end

    cqt_out;
end
=#

function my_CQT(signal; f0=8, fm=20000, b=2.2, fs=16000, K=20)
    ## Q ratio
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

    for k = 1:K
        push!(F_k, f(k));
        push!(X_k, CQT(signal, k));
    end

    F_k, X_k;
end

# prep
sampling = 1e-3;
Fs = 1 / sampling;
t = 0:sampling:(4-sampling);
f = 4;

# signal
#wave_cos1 = 32 * cos.(2 * pi * f * t);
#wave_cos2 = 64 * cos.(2 * pi * 4f * t);
#wave_sin1 = 4 .* sin.(2 * pi * .5f * t .+ .75pi);
#signal = wave_cos1 .+ wave_cos2 .+ wave_sin1;
signal = 100 .* sin.(2 * pi * 4 * t);

#dft = my_DFT(signal);
F_k, X_k = my_CQT(signal; fs=Fs);
#display(plot(F_k, abs.(X_k), title="CQT(S(t))", seriestype=:scatter));

#display(plot(abs.(dft), title="DFT(S(t))"));
#display(plot(abs.(cqt), title="CQT(S(t))"));
