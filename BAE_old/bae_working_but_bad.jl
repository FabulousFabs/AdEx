# main file for the BAE implementation

using FileIO: load, save, loadstreaming, savestreaming
using FFTW
using SampledSignals
using Plots
using DSP
import LibSndFile

include("funcs.jl");

function get_audio_file(s::String)
    file::SampleBuf{Float32, 2} = load(s);
    file;
end

function get_spectrogram(f::SampleBuf{Float32, 2}, L::Int, Fs::Float64, T::Float64; stride_s::Float64 = 10e-3, window_s::Float64 = 20e-3, eps::Float64 = 1e-14, cutoff::Float64 = 20e3)
    # sizing
    stride_size::Int = floor(Int, Fs * stride_s);
    window_size::Int = floor(Int, Fs * window_s);

    # extract strided windows
    truncate_size::Int = (L - window_size) % stride_size;
    samples::Vector{Float64} = f[1:(L - truncate_size), 1];
    nshape::Tuple{Int, Int} = (window_size, floor(Int, (size(samples)[1] - window_size) / stride_size) + 1);
    nstrides::Tuple{Int, Int} = (strides(samples)[1], strides(samples)[1] * stride_size);
    windows = zeros(nshape);
    weighting = zeros(nshape);
    @views for column in 1:size(windows)[2]
        c_strides = zeros(window_size);
        for i = 1:floor(Int, window_size / stride_size)
            s = (i + column - 2) * stride_size;
            e = s + stride_size;
            c_strides[((i - 1) * stride_size) + 1:((i - 1) * stride_size) + stride_size] = samples[s+1:e];
        end
        weighting[:, column] = hanning(c_strides);
        windows[:,column] = c_strides;
    end

    # transform signals to frequency domain
    fft_A_original = rfft(windows .* weighting, 1); # fft along columns
    fft_A = abs.(fft_A_original).^2;

    scale = sum(weighting.^2) * Fs;
    fft_A[2:(end-1), :] = fft_A[2:(end-1), :] .* (2.0 ./ scale) .* 10e9;
    fft_A[1,:] = fft_A[1,:] ./ scale .* 10e9;
    fft_A[end,:] = fft_A[end,:] ./ scale .* 10e9;

    # frequencies
    fft_F = (float(Fs) ./ window_size) .* collect(1:size(fft_A)[1]);

    # compute and return spectrogram until cut off
    n = 
    spectrogram = log.(fft_A[:,:] .+ eps);
    spectrogram, fft_F;
end

function plot_spectrogram(s::Array{Float64}, F::Array{Float64}, t::String)
    gr();
    display(heatmap(
        (1:size(s, 2)) .* 1e-2,
        (F ./ 1000),
        s,
        c=cgrad([:white, :blue, :red, :yellow]),
        xlabel="t, w", ylabel="Frequencies (kHz)",
        title=t
    ));
end

function get_simultaneous_mask(s::Array{Float64}, F::Array{Float64})
    thresholds::Array{Float64} = T_a(F);
    mask::Array{Float64} = zeros(size(s));

    for i = 1:size(s)[2]
        mask[:,i] = map((A, th) -> (A >= th ? 1 : 0), s[:,i], thresholds);
    end

    mask;
end

function get_temporal_mask(s::Array{Float64}, F::Array{Float64})
    mask_bin::Array{Float64} = zeros(size(s));
    last_peak::Array{Float64} = zeros(size(s)[1]);
    last_peak_time::Array{Float64} =  zeros(size(s)[1]);

    for f_bin = 1:size(s)[1]
        for i = 1:size(s)[2]
            if abs(s[f_bin, i]) >= y(i - last_peak_time[f_bin], last_peak[f_bin])
                last_peak[f_bin] = abs(s[f_bin, i]);
                last_peak_time[f_bin] = i;
                mask_bin[f_bin, i] = 1;
            end
        end
    end

    mask_bin;
end

function get_BAE(f::SampleBuf{Float32, 2}, neurons::Int; dt::Float64=0.001, do_plot::Bool=false)
    # get parameters and signal (step A)
    L::Int = length(f);
    Fs::Float64 = samplerate(f);
    T::Float64 = L / Fs;

    # get spectrogram (step B)
    s::Array{Float64}, F::Array{Float64} = get_spectrogram(f, L, Fs, T);

    # get simultaneous mask (step D)
    mask_simultaneous = get_simultaneous_mask(s, F);

    # get temporal mask (step C)
    mask_temporal = get_temporal_mask(s, F);

    # combine masks (step E)
    mask = mask_simultaneous .* mask_temporal;

    # make neuron matrix
    matrix = zeros((neurons, size(s)[2]));
    for f in F

    end

    # produce plots
    if (do_plot)
        plot_spectrogram(s, F, "Raw spectrogram of signal");
        plot_spectrogram(s .* mask_simultaneous, F, "Simultaneous mask");
        plot_spectrogram(s .* mask_temporal, F, "Temporal mask");
        plot_spectrogram(s .* mask, F, "Masked signal");
    end
end
