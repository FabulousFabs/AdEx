# main file for testing our AdEx SNN implementation

include("AdEx/model.jl");
include("AdEx/model_plots.jl");

## draw up model
A1_microcircuit = [
    AdEx_Model_Neurons(
        T=AdEx_Neuron_Excitatory,
        N=1,
        S=[AdEx_Model_Synapses(
            T=AdEx_Synapse_AMPA,
            C=Int[2, 3]
        )]
    ),
    AdEx_Model_Neurons(
        T=AdEx_Interneuron_PV,
        N=1,
        S=[AdEx_Model_Synapses(
            T=AdEx_Synapse_GABA_B,
            C=Int[1, 3]
        )]
    ),
    AdEx_Model_Neurons(
        T=AdEx_Interneuron_SST,
        N=1,
        S=[AdEx_Model_Synapses(
            T=AdEx_Synapse_GABA_A,
            C=Int[1, 2]
        )]
    )
];

## create models
model = AdEx_Model_Create(A1_microcircuit);

## setup simulation
T = (0ms, 2000ms);
I = [
    (1, AdEx_boxcar(T[1]:T[2], 200ms, 1600ms, 2200pA))
];

## run a couple of simulations
spikes = AdEx_Model_Simulate(model, T, I; dt=1ms, σ=350pA);

## plot spike trains
display(AdEx_Plot_Spikes(spikes, T; dt=1ms));
