# main file for the BAE implementation

using FileIO: load, save, loadstreaming, savestreaming
using FFTW
using SampledSignals
using Plots
import LibSndFile

include("funcs.jl");

function get_audio_file(s::String)
    file = load(s);
    file, length(file), samplerate(file);
end

function get_cochlear_filterbank(s::Float64, L::Int, Fs::Float64)

end

function get_BAE(s::Float64, L::Int, Fs::Float64)
    signal = get_cochlear_filterbank(s, L, Fs);
end
