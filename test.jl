# main file for testing our AdEx implementation

include("AdEx/model.jl");

# injection current
A = 2mV;

# injection functions
I_boxcar(t) = (t >= 80ms) && (t <= 120ms) ? A : 0;
I_pulse(t) = (t == 120ms) ? A : 0;
I_sin(t) = A * sin(2 * π * 0.01 * t) + 1/2 * A;
I_null(t) = 0;

# create model
model = AdEx_Model_Create(1);

# run a couple of simulations
solutions = AdEx_Model_Run(model, (0ms, 200ms), I_boxcar);
solutions2 = AdEx_Model_Run(model, (0ms, 200ms), I_pulse);
solutions3 = AdEx_Model_Run(model, (0ms, 200ms), I_sin);
solutions4 = AdEx_Model_Run(model, (0ms, 200ms), I_null);

# plot our results
AdEx_Model_Plot([solutions; solutions2; solutions3; solutions4]);
