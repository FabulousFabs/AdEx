# main file for testing our AdEx implementation

include("AdEx/model.jl");

# draw up model
network_draft = [
    AdEx_Model_Neurons(
        T=AdEx_Neuron_T1,
        N=2,
        S=[AdEx_Model_Synapses(
            T=AdEx_Synapse_AMPA,
            C=Int[4, 5]
        )]
    ),
    AdEx_Model_Neurons(
        T=AdEx_Neuron_T1,
        N=1,
        S=[AdEx_Model_Synapses(
            T=AdEx_Synapse_GABA_A,
            C=Int[1, 2]
        ), AdEx_Model_Synapses(
            T=AdEx_Synapse_AMPA,
            C=Int[6]
        )]
    ),
    AdEx_Model_Neurons(
        T=AdEx_Neuron_T1,
        N=2,
        S=[AdEx_Model_Synapses(
            T=AdEx_Synapse_NMDA,
            C=Int[1, 2]
        ), AdEx_Model_Synapses(
            T=AdEx_Synapse_AMPA,
            C=Int[3, 3, 3]
        )]
    ),
    AdEx_Model_Neurons(
        T=AdEx_Neuron_T1,
        N=1,
        S=[AdEx_Model_Synapses(
            T=AdEx_Synapse_GABA_A,
            C=Int[1, 2]
        )]
    )
];

# create model
model = AdEx_Model_Create(network_draft);

# setup simulation
T = (0ms, 2000ms);
I = [
    (1, AdEx_boxcar(T[1]:T[2], 100ms, 1400ms, 2mV)),
    (2, AdEx_sin(T[1]:T[2], 2mV, 0.001))
];

# run simulation
spikes = AdEx_Model_Simulate(model, T, I; dt=1ms);

# plot spike trains
Base.showable(::MIME"application/prs.juno.plotpane+html", plt::Plots.Plot) = false
display(AdEx_Model_Plot_Synapses(model));
#display(AdEx_Model_Plot_Neurons(model));
#display(AdEx_Plot_Spikes(spikes, T; dt=1ms));
