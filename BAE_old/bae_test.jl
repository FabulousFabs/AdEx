# main file for the BAE implementation

using FileIO: load, save, loadstreaming, savestreaming
using FFTW
using SampledSignals
using Plots
using DSP
import LibSndFile

include("funcs.jl");

## import file
test_file_vowel_i = load("/users/fabianschneider/desktop/university/master/sem2/lab rotation III/julia/BAE/resources/Close_front_unrounded_vowel.ogg");

## get parameters of the file
L = length(test_file_vowel_i); # length of signal in entries
Fs = samplerate(test_file_vowel_i); # Sampling rate Hz
T = L / Fs; # length of signal in seconds
t = collect(1:L); # time vector

## plot original signal
#display(plot(t, real.(test_file_vowel_i)));

## FFT and plot
fft_A = rfft(test_file_vowel_i);
fft_F = fftfreq(L, Fs);
#display(plot(fft_F, abs.(fft_A)));

## simultaneous masking
masking_sim_thresholds = T_a(abs.(fft_F));
fft_masked_bin = map((A, th) -> ((2 .* abs(A)) <= abs(th) ? 0 : 1), fft_A, masking_sim_thresholds); #abs.(masking_sim_thresholds) >= abs.(fft_A)[:,:];
fft_masked_new = fft_A .* fft_masked_bin;
#display(plot(fft_F, abs.(fft_masked_new)));
signal_masked = ifft(fft_masked_new);
#display(plot(t, real.(signal_masked)));

## temporal masking
mask_bin = [1];
peaks = Int[1];
last_peak = abs(signal_masked[1]);
for i = 2:size(signal_masked)[1]
    global peaks, last_peak, signal_masked;
    if abs(signal_masked[i]) >= y(i - peaks[end], last_peak)
        push!(peaks, i);
        last_peak = abs(signal_masked[i]);
    end
    push!(mask_bin, (peaks[end] == i ? 1 : 0));
end
signal_final = signal_masked .* mask_bin;
#display(plot(t, real.(signal_final)));

#save("/users/fabianschneider/desktop/university/master/sem2/lab rotation III/julia/BAE/i_after_new2_final.ogg", abs.(signal_final), samplerate=Fs);
#save("/users/fabianschneider/desktop/university/master/sem2/lab rotation III/julia/BAE/i_after_new2_masked.ogg", abs.(signal_masked), samplerate=Fs);
#save("/users/fabianschneider/desktop/university/master/sem2/lab rotation III/julia/BAE/a_after_1.ogg", abs.(signal_final));
#my_signal = real.(signal_final);
#save("/users/fabianschneider/desktop/university/master/sem2/lab rotation III/julia/BAE/a_after_2.ogg", my_signal);
#my_signal2 = abs.(signal_final) .* (map(x -> x < 0 ? -1 : 1, real.(signal_final)));
#save("/users/fabianschneider/desktop/university/master/sem2/lab rotation III/julia/BAE/a_after_3.ogg", my_signal2, samplerate=44100);
