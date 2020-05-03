# main file for testing our AdEx implementation

include("AdEx-NeuronalDynamics/model.jl");

# injection functions
I_boxcar(t) = (t >= 80ms) && (t <= 120ms) ? 80mV : 0;
I_pulse(t) = (t == 120ms) ? 220mV : 0;
I_sin(t) = 2mV * sin(2 * π * 0.01 * t) + 2mV;
I_cos(t) = 2mV * cos(2 * π * 0.01 * t) + 2mV;
I_null(t) = 0;

# create model
model = AdEx_Model_Create(1);

# run a couple of simulations
solutions = AdEx_Model_Run(model, (0ms, 200ms), I_boxcar);
solutions2 = AdEx_Model_Run(model, (0ms, 200ms), I_pulse);
solutions3 = AdEx_Model_Run(model, (0ms, 200ms), I_sin);
solutions4 = AdEx_Model_Run(model, (0ms, 200ms), I_cos);
solutions5 = AdEx_Model_Run(model, (0ms, 200ms), I_null);

# make injection vectors for visualisation
vec_I_boxcar = map(x -> I_boxcar(x), collect(1ms:size(solutions[1])[1]ms));
vec_I_pulse = map(x -> I_pulse(x), collect(1ms:size(solutions2[1])[1]ms));
vec_I_sin = map(x -> I_sin(x), collect(1ms:size(solutions3[1])[1]ms));
vec_I_cos = map(x -> I_cos(x), collect(1ms:size(solutions4[1])[1]ms));
vec_I_null = map(x -> I_null(x), collect(1ms:size(solutions5[1])[1]ms));

# plot our results
solutions[1] = [vec_I_boxcar    solutions[1]];
solutions2[1] = [vec_I_pulse    solutions2[1]];
solutions3[1] = [vec_I_sin  solutions3[1]];
solutions4[1] = [vec_I_cos solutions4[1]];
solutions5[1] = [vec_I_null solutions5[1]];
AdEx_Model_Plot([solutions; solutions2; solutions3; solutions4; solutions5], 4);
