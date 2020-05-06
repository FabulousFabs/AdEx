# Spiking neural network implementation<sup>[[1]](#references)</sup> with AdEx neurons<sup>[[2]](#references)</sup>

## To-do:
* [ ] Add different neuron markers for excitatory, SST-expressing and PV-expressing neurons such that we can truthfully model A1 circuits of excitatory neurons and SST-expressing GABAergic INs firing at dendrites and PV-expressing GABAergic INs firing at somas of excitatory neurons, as per Park & Geffen<sup>[[3, 6]](#references)</sup>
	* This could be achieved by implementing a non-linear cable equation<sup>[[1]](#references)</sup>:
		```math
		$`\displaystyle\frac{\partial}{\partial t}\,u(t,x)-\frac{\partial^{2}}{\partial x%^{2}}\,u(t,x)+u(t,x)+g_{\text{syn}}(t,x)[u(t,x)-E_{\text{syn}}] = 0`$
		$`\displaystyle\frac{\partial}{\partial t}g_{\text{syn}}(t,x)-\tau_{\text{syn}}^%{-1}\,g_{\text{syn}}(t,x) = S(t,x)`$
		```
	* This could then be used to model decay of input currents differently between excitatory/SST/PV (inter-)neurons.

* [ ] Test this by replicating the results of Pan et al.<sup>[[4]](#references)</sup>

## Current state
* [x] AdEx_Neuron_T1<sup>[[2]](#references)</sup> implemented
* [x] AdEx_Neuron_T2<sup>[[1]](#references)</sup> implemented
* [x] Pedantic Heun's method<sup>[[5]](#references)</sup> implemented (no longer utilises DifferentialEquations.jl)
* [x] GABA_a, GABA_b, AMPA & NMDA synapses<sup>[[1]](#references)</sup> implemented
* [x] Neurons can have multiple types of synapses
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
		```
	* We get:
		* Spike train plots
			* <img src="https://i.imgur.com/97WRgjD.png" width="50%" height="50%" />
		* Neuron history plots
			* <img src="https://i.imgur.com/ivIvP73.png" width="50%" height="50%" />
		* Synapse history plots, left column I(t), right column g(t), rows = one synapse
			* <img src="https://i.imgur.com/Hqm3fm6.png" width="50%" height="50%" />

## References
* [1] Gerstner, W., Kistler, W.M., Naud, R., & Paninski, L. (2014). Neuronal Dynamics: From Single Neurons to Networks and Models of Cognition. New York: CUP.

* [2] Brette, R., & Gerstner, W. (2005). Adaptive exponential integrate-and-fire model as an effective description of neuronal activity. Journal of Neurophysiology, 94, 3637-3642. DOI: http://dx.doi.org/10.1152/jn.00686.2005.

* [3] Park, Y., & Geffen, M.N. (preprint). A unifying mechanistic model of excitatory-inhibitory interactions in the auditory cortex. bioRxiv, 626358. DOI: http://dx.doi.org/10.1101/626358

* [4] Pan, Z., Chua, Y., Wu, J., Zhang, M., Li, H., & Ambikairajah, E. (2020). Motivated auditory neural encoding and decoding algorithm for spiking neural networks. Frontiers in Neuroscience: Neuromorphic Engineering, 13, 1420. DOI: http://dx.doi.org/10.3389/fnins.2019.01420

* [5] Numerical Methods--Heun's method. (n.d.). CalculusLab, San Joaquin Delta College. Retrieved May 5, 2020, from http://calculuslab.deltacollege.edu/ODE/7-C-2/7-C-2-h.html

* [6] Tremblay, R., Lee, S., & Rudy, B. (2016). GABAergic interneurons in the neocortex: From cellular properties to circuits. Neuron, 91, 260-292. DOI: http://dx.doi.org/10.1016/j.neuron.2016.06.033