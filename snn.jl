# main file for testing our AdEx SNN implementation

include("AdEx/model.jl");
include("AdEx/model_plots.jl");

## draw up model
network_draft = [
    AdEx_Model_Neurons(
        T=AdEx_Neuron_Excitatory,
        N=2,
        S=[AdEx_Model_Synapses(
            T=AdEx_Synapse_AMPA,
            C=Int[5, 6]
        )]
    ),
    AdEx_Model_Neurons(
        T=AdEx_Interneuron_SST,
        N=1,
        S=[AdEx_Model_Synapses(
            T=AdEx_Synapse_GABA_A,
            C=Int[1]
        )]
    ),
    AdEx_Model_Neurons(
        T=AdEx_Interneuron_PV,
        N=1,
        S=[AdEx_Model_Synapses(
            T=AdEx_Synapse_GABA_A,
            C=Int[2]
        )]
    ),
    AdEx_Model_Neurons(
        T=AdEx_Neuron_Excitatory,
        N=2,
        S=[AdEx_Model_Synapses(
            T=AdEx_Synapse_AMPA,
            C=Int[3, 4]
        )]
    )
];

## create model
model = AdEx_Model_Create(network_draft);

## setup simulation
T = (0ms, 2000ms);
I = [
    (1, AdEx_boxcar(T[1]:T[2], 100ms, 1400ms, 2mV)),
    (2, AdEx_boxcar(T[1]:T[2], 100ms, 1400ms, 2mV)),
];

## run simulation
spikes = AdEx_Model_Simulate(model, T, I; dt=1ms);

## plot spike trains
#display(AdEx_Model_Plot_Synapses(model));
#display(AdEx_Model_Plot_Neurons(model));
display(AdEx_Plot_Spikes(spikes, T; dt=1ms));
