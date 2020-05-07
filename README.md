# Spiking neural network implementation<sup>[[1]](#references)</sup> with AdEx neurons<sup>[[2]](#references)</sup>

## To-do:
* [ ] Clean up AdEx/neuron_parameters.jl
* [ ] Test this by replicating the results of Pan et al.<sup>[[4]](#references)</sup>

## Current state
* [x] Pedantic Heun's method<sup>[[5]](#references)</sup> implemented (no longer utilises DifferentialEquations.jl)
* [x] AdEx_Neuron_T1<sup>[[2]](#references)</sup> implemented
* [x] AdEx_Neuron_T2<sup>[[1]](#references)</sup> implemented
* [x] AdEx_Neuron_Excitatory<sup>[[3]](#references)</sup> implemented
* [x] AdEx_Interneuron_SST<sup>[[3]](#references)</sup> implemented
* [x] AdEx_Interneuron_PV<sup>[[3]](#references)</sup> implemented
* [x] All (inter-)neurons can have multiple types of synapses
* [x] GABA_a, GABA_b, AMPA & NMDA synapses<sup>[[1]](#references)</sup> implemented
* [x] Now properly modelling interactions of Exc -> SST and PV -> Exc, as described by Park & Geffen<sup>[[3]](#references)</sup> and Tremblay et al.<sup>[[6]](#references)</sup>
* [x] White gaussian noise injection implemented for neurons
* [x] Comprehensive plots added
	* For example, for model:
		```julia
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
		
		...
		
		T = (0ms, 2000ms);
		I = [
		    (1, AdEx_boxcar(T[1]:T[2], 100ms, 1400ms, 2mV)),
		    (2, AdEx_sin(T[1]:T[2], 2mV, 0.001))
		];
		
		...
		
		AdEx_Model_Simulate(model, T, I; dt=1ms, σ=0.1mV);
		```
	* We get:
		* Spike train plots
			* <img src="https://i.imgur.com/97WRgjD.png" width="50%" height="50%" />
		* Neuron history plots
			* <img src="https://i.imgur.com/ivIvP73.png" width="50%" height="50%" />
		* Synapse history plots, left column I(t), right column g(t), rows = one synapse
			* <img src="https://i.imgur.com/Hqm3fm6.png" width="50%" height="50%" />

## Dependencies
* Parameters (required)
* Distributions (required)
* Plots (required only if AdEx/model_plots.jl is included)

## References
* [1] Gerstner, W., Kistler, W.M., Naud, R., & Paninski, L. (2014). Neuronal Dynamics: From Single Neurons to Networks and Models of Cognition. New York: CUP.

* [2] Brette, R., & Gerstner, W. (2005). Adaptive exponential integrate-and-fire model as an effective description of neuronal activity. Journal of Neurophysiology, 94, 3637-3642. DOI: http://dx.doi.org/10.1152/jn.00686.2005.

* [3] Park, Y., & Geffen, M.N. (preprint). A unifying mechanistic model of excitatory-inhibitory interactions in the auditory cortex. bioRxiv, 626358. DOI: http://dx.doi.org/10.1101/626358

* [4] Pan, Z., Chua, Y., Wu, J., Zhang, M., Li, H., & Ambikairajah, E. (2020). Motivated auditory neural encoding and decoding algorithm for spiking neural networks. Frontiers in Neuroscience: Neuromorphic Engineering, 13, 1420. DOI: http://dx.doi.org/10.3389/fnins.2019.01420

* [5] Numerical Methods--Heun's method. (n.d.). CalculusLab, San Joaquin Delta College. Retrieved May 5, 2020, from http://calculuslab.deltacollege.edu/ODE/7-C-2/7-C-2-h.html

* [6] Tremblay, R., Lee, S., & Rudy, B. (2016). GABAergic interneurons in the neocortex: From cellular properties to circuits. Neuron, 91, 260-292. DOI: http://dx.doi.org/10.1016/j.neuron.2016.06.033