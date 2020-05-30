# BAE functions

include("dependencies.jl");
include("CQT_hm.jl");

function get_audio(s::String)
    x::Array{Float64, 2}, fs::Float64 = wavread(s);
    x, fs;
end

function plot_cochlear_wavelets(F_k, F, l);
    x = (1:size(F_k)[2]) .* l .* 1e-1; # time axis
    y = F;
    z = real.(F_k);

    for i = 1:size(z)[1]
        display(plot(x, z[i,:], ylims=(-5, 5)));
    end
end

function encode_audio(s::String)
    signal::Array{Float64, 2}, fs::Float64 = get_audio(s);

    X, F, B = CQT_spectrogram(signal .* fs; b = 2.2, l = 20, s = 10, fs = convert(Int, fs)); # get filters in frequency domain

    #X = CQT(signal .* fs; f0 = 15, fm = 8000, b = 2.2, fs = 16000);
    #F, B = CQT_freq(;f0 = 15, fm = 8000, b = 2.2, fs = 16000);

    wavelets = zeros(2607);
    #wavelets = [];

    for i = 1:size(X)[1]
        j = size(X)[1] + 1 - i;
        #j = i;
        x = X[j,:];
        f = F[j];
        #println("Wavelet" * string(j) * " with X=" * string(x) * " and F=" * string(f) * ".");

        #f = F[1];
        A = abs.(x);
        ϕ = atan.(imag.(x), real.(x));

        t = (1:2607) .* 1e-3;
        tt::Vector{Int} = 1:2607;
        wavelet = hanning(2607) .* A .* sin.(2 .* π .* f .* t .+ ϕ);
        #append!(wavelets, wavelet);
        #wavelets = [wavelets wavelet];
        wavelets = [wavelets wavelet];
    end

    wavelets = wavelets[:,2:end];

    #x_axis = map(z -> 1:length(F), length(F));
    #y_axis = map(z -> (1:100) .* 1e-3, length(F));
    x_axis = repeat(1:length(F), 1, 2607)';
    y_axis = repeat((1:2607) .* 1e-3, 1, 20);

    #println(size(x_axis));
    #println(size(y_axis));
    #println(size(wavelets));

    display(plot(x_axis, y_axis, wavelets, legend=false));

    #println(CQT(signal .* fs; f0 = 15, fm = 8000, b = 2.2, fs = 16000));

    #=X, F, B = CQT(signal .* fs; f0 = 15, fm = 8000, b = 2.2, fs = 16000);

    println(X);
    println(F);
    println(B);=#

    #=
    println("go");
    println("second");
    println(X);
    x = X[1];
    println(x);

    f = F[1];
    A = abs.(x);
    ϕ = atan.(imag.(x), real.(x));

    println(f);
    println(A);
    println(ϕ);

    t = 1:60;
    wavelets = A .* sin.(2 .* π .* f .* t .+ ϕ);

    display(plot(t, wavelets));=#


    #F_k = ifft(X, 2); # take IFFT to get impulse response
    #plot_cochlear_wavelets(F_k, F, 20);
    #display(plot((1:size(F_k)[2]) .* 32 .* 1e-4, real.(F_k[5,:])))

    #plot_spectrogram(abs.(F_k), F, 32, "F_k test");
end
