# main file for testing our AdEx implementation

include("AdEx/model.jl");

# draw up model
network_draft = [
    AdEx_Model_Neurons(
        T=AdEx_Neuron_T1,
        N=2,
        S=AdEx_Model_Synapses(
            T=AdEx_Synapse_AMPA,
            C=Int[3]
        )
    ),
    AdEx_Model_Neurons(
        T=AdEx_Neuron_T1,
        N=1,
        S=AdEx_Model_Synapses(
            T=AdEx_Synapse_GABA_B,
            C=Int[1, 2]
        )
    )
];

model = AdEx_Model_Create(network_draft);

T = (0ms, 2000ms);
I = [
    (1, AdEx_boxcar(T[1]:T[2], 100ms, 1400ms, 2mV)),
    (2, AdEx_boxcar(T[1]:T[2], 100ms, 1400ms, 2mV))
];

spikes = AdEx_Model_Simulate(model, T, I; dt=1ms);
display(AdEx_Plot_Spikes(spikes, T; dt=1ms));
