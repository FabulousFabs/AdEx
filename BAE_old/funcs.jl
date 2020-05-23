# helper functions for BAE implementation

# taken from pan et al., 2020
T_a(f) = 3.64 .* (1e-3 .* f).^(-0.8) .- 6.5 .* exp.(.-0.6 .* ((1e-3 .* f) .- 3.3).^2) .+ 1e-3 .* (1e-3 .* f).^4;

# taken from Ambikairajah et al., 2001
τ = 8e-3;
c = exp(-τ);
y(n, p1) = c^n * p1;

# hanning window (for spectrogram)
hanning(v) = .5 .- .5 .* cos.((2 .* π .* v) ./ (v .+ 1.0));
