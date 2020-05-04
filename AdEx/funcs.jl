## AdEx helper functions

δ(t) = map(x -> x == 0 ? 1 : 0, t); # dirac delta spikes
Θ(t) = 1 ./ (1 .+ exp.(-2 .* 1000 .* t)); # heaviside step approximation

AdEx_boxcar(t, a, b, A) = A .* (Θ(t .- a) .- Θ(t .- b));
AdEx_pulse(t, t_p, A) = A .* δ(t .- t_p);
AdEx_null(t) = t .* 0;
