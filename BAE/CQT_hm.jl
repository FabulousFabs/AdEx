# Constant Q Transforms

W(k::Int, n::Vector{Int}, N_k::Int, a::Float64) = a .+ (1 .- a) .* cos.(2 .* π .* n ./ N_k); # Window function
# this was a hamming window but (apparently) Pan et al. use hanning

function CQT(x::Array{Float64, 1}; f0::Int = 15, fm::Int = 8000, b::Float64 = 1.0, fs::Int = 16000)
    K::Int = ceil(Int, b * log2(fm / f0)); # Brown et al. 91/92, papers introducing CQTs
    Q::Float64 = (2^(1 / b) - 1)^(-1); # Brown et al. 91/92, papers introducing CQTs

    X::Vector{Complex{Float64}} = []; # container

    @fastmath for k = 1:K
        f_k::Float64 = (f0 * 2 ^ ((k - 1) / b)); # f[k]
        B_k::Float64 = f_k / Q; # B[k]
        N_k::Int = round(Int, Q * fs / f_k); # N[k]
        n::Vector{Int} = (0:(N_k - 1)); # n indices of N[k]
        W_k_n::Vector{Float64} = W(k, n, N_k, 25 / 46); # window functions; Hamming windows
        e::Vector{Complex{Float64}} = exp.((-2im .* π .* Q .* n) ./ N_k); # e term
        xp::Vector{Float64} = length(x) < N_k ? [x; zeros(N_k - length(x))] : x; # pad the signal with zeros
        X_k::Complex{Float64} = N_k^(-1) .* sum( W_k_n .* xp[1:N_k] .* e ); # compute X[k]
        push!(X, X_k);
    end

    X;
end

function CQT(x::Array{Float64, 2}; f0::Int = 15, fm::Int = 8000, b::Float64 = 1.0, fs::Int = 16000)
    K::Int = ceil(Int, b * log2(fm / f0)); # Brown et al. 91/92, papers introducing CQTs
    Q::Float64 = (2^(1 / b) - 1)^(-1); # Brown et al. 91/92, papers introducing CQTs

    X::Vector{Complex{Float64}} = []; # container

    @fastmath for k = 1:K
        f_k::Float64 = (f0 * 2 ^ ((k - 1) / b)); # f[k]
        B_k::Float64 = f_k / Q; # B[k]
        N_k::Int = round(Int, Q * fs / f_k); # N[k]
        n::Vector{Int} = (0:(N_k - 1)); # n indices of N[k]
        W_k_n::Vector{Float64} = W(k, n, N_k, 25 / 46); # window functions; Hamming windows
        e::Vector{Complex{Float64}} = exp.((-2im .* π .* Q .* n) ./ N_k); # e term
        xp::Array{Float64, 2} = length(x) < N_k ? [x; zeros(N_k - length(x))] : x; # pad the signal with zeros
        X_k::Complex{Float64} = N_k^(-1) .* sum( W_k_n .* xp[1:N_k] .* e ); # compute X[k]
        push!(X, X_k);
    end

    X;
end

function CQT_freq(;f0::Int = 15, fm::Int = 8000, b::Float64 = 1.0, fs::Int = 16000)
    K::Int = ceil(Int, b * log2(fm / f0)); # Brown et al. 91/92, papers introducing CQTs
    Q::Float64 = (2^(1 / b) - 1)^(-1); # Brown et al. 91/92, papers introducing CQTs

    F::Vector{Float64} = [];
    B::Vector{Float64} = [];

    for k = 1:K
        f_k::Float64 = (f0 * 2 ^ ((k - 1) / b)); # f[k]
        B_k::Float64 = f_k / Q; # B[k]
        push!(F, f_k);
        push!(B, B_k);
    end

    F, B;
end

function CQT_spectrogram(x::Array{Float64, 1}; b::Float64 = 3.0, l::Int = 32, s::Int = 16, fs::Int = 16000)
    x = [x; zeros(l - rem(length(x), l))]; # pad the signal with zeros

    X = CQT(zeros(l); f0 = 15, fm = convert(Int, fs / 2), b = b, fs = fs);

    for i = 1:convert(Int, length(x) / l)
        # window of x
        window::Vector{Float64} = [];

        for j = 1:convert(Int, l / s)
            # stride j of x
            stride_start::Int = (i - 1) * l + (j - 1) * s + 1;
            stride_end::Int = stride_start + s - 1;

            window = [window; x[stride_start:stride_end]];
        end

        X_n = CQT(window; b = b, fs = fs); # get the CQT of our window
        X = [X X_n]; # add to matrix
    end

    X = X[:,2:end]; # delete the dummy we placed as a hacky size work-around
    F, B = CQT_freq(b = b, fs = fs); # get descriptors

    X, F, B;
end

function CQT_spectrogram(x::Array{Float64, 2}; b::Float64 = 3.0, l::Int = 32, s::Int = 16, fs::Int = 16000)
    x = [x; zeros(l - rem(length(x), l))]; # pad the signal with zeros

    X = CQT(zeros(l); f0 = 15, fm = convert(Int, fs / 2), b = b, fs = fs);

    for i = 1:convert(Int, length(x) / l)
        # window of x
        window::Vector{Float64} = [];

        for j = 1:convert(Int, l / s)
            # stride j of x
            stride_start::Int = (i - 1) * l + (j - 1) * s + 1;
            stride_end::Int = stride_start + s - 1;

            window = [window; x[stride_start:stride_end]];
        end

        X_n = CQT(window; b = b, fs = fs); # get the CQT of our window
        X = [X X_n]; # add to matrix
    end

    X = X[:,2:end]; # delete the dummy we placed as a hacky size work-around
    F, B = CQT_freq(b = b, fs = fs); # get descriptors

    X, F, B;
end

function plot_spectrogram(m, F, l, t)
    gr();
    display(heatmap(
        (1:size(m)[2]) .* l .* 1e-4,
        F,
        m,
        c=cgrad([:blue, :red, :yellow]),
        xlabel="t(s), in seconds", ylabel="Frequencies",
        title=t
    ));
end
