using Plots

# auxiliary functions
H(n, m) = 0.54 .- 0.46 .* cos.((2 .* pi .* n) ./ (m .- 1)); # hamming window

# setup signal
x = 1:10; # frequency bins
y = 0:0.001:0.099; # time vector
W = H(x, x[end]);
S = sin.(2 .* pi .* x .* 10 .* y');

x_axis = repeat(x, 1, length(y));
y_axis = repeat(y', length(x), 1);
z_axis = W .* S;

#display(plot(x_axis', y_axis', z_axis'));
display(plot(x_axis', y_axis', z_axis', lt=:path3d));
