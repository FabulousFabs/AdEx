# helper file for the BAE implementation

#=

## frequency shenanigans
struct GeometricFrequency
    min::Float64
    max::Float64
    bins::Float64

    function GeometricFrequency(;min::Float64=8., max::Float64=16000., bins::Float64=20.)
        new(min, max, bins);
    end
end

n_bins_per_octave(freq::GeometricFrequency) = freq.bins;

## q-factor
q(bins::Float64, rate::Float64=1.) = 1. / (2^(1. / bins) - 2^(-1. / bins));
q(freq::GeometricFrequency, rate::Float64=1.) = q(freq.bins, rate);

=#
