using DSP
using Plots

signal = 2.5 .* sin.(2 .* pi .* 4 .* ((1:1000) .* 1e-3));

display(plot(1:1000, signal));
display(plot(1:1000, signal .* hamming(1000)));
