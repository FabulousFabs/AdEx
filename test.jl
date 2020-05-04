# main file for testing our AdEx implementation

include("AdEx/model.jl");

# draw up model
network_draft = [
    AdEx_Model_Neurons(
        T=AdEx_Neuron_T1,
        N=1,
        S=AdEx_Model_Synapses(
            T=AdEx_Synapse_NMDA,
            C=Int[2]
        )
    ),
    AdEx_Model_Neurons(
        T=AdEx_Neuron_T1,
        N=1,
        S=AdEx_Model_Synapses(
            T=AdEx_Synapse_NMDA,
            C=Int[]
        )
    )
];

# create model
model = AdEx_Model_Create(network_draft);

# setup simulation
T = (0ms, 200ms);
I = [
     (1, AdEx_boxcar(T[1]:T[2], 40ms, 80ms, 2mV)),
     (2, AdEx_null(T[1]:T[2]))
    ];

# run simulation
my_results = AdEx_Model_Simulate(model, T, I);
AdEx_Model_Plot(my_results);
