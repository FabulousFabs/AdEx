## AdEx helper functions

# dirac delta spikes
δ(t::AdEx_Float) = (t == 0 ? 1 : 0);
δ(t::StepRangeLen{AdEx_Float,Base.TwicePrecision{AdEx_Float},Base.TwicePrecision{AdEx_Float}}) = map(x -> x == 0 ? 1 : 0, t);

# heaviside step approximation
Θ(t::StepRangeLen{AdEx_Float,Base.TwicePrecision{AdEx_Float},Base.TwicePrecision{AdEx_Float}}) = 1 ./ (1 .+ exp.(-2 .* 10000 .* t));
Θ(t::AdEx_Float) = 1 ./ (1 .+ exp.(-2 .* 10000 .* t));

# common input functions
AdEx_boxcar(t::StepRangeLen{AdEx_Float,Base.TwicePrecision{AdEx_Float},Base.TwicePrecision{AdEx_Float}}, a::AdEx_Float, b::AdEx_Float, A::AdEx_Float) = A .* (Θ(t .- a) .- Θ(t .- b));
AdEx_sin(t::StepRangeLen{AdEx_Float,Base.TwicePrecision{AdEx_Float},Base.TwicePrecision{AdEx_Float}}, A::AdEx_Float, f::AdEx_Float) = A .* sin.(2 .* π .* f .* t);
AdEx_pulse(t::StepRangeLen{AdEx_Float,Base.TwicePrecision{AdEx_Float},Base.TwicePrecision{AdEx_Float}}, t_p::AdEx_Float, A::AdEx_Float) = A .* δ(t .- t_p);
AdEx_null(t::StepRangeLen{AdEx_Float,Base.TwicePrecision{AdEx_Float},Base.TwicePrecision{AdEx_Float}}) = t .* 0;
