# Spiking neural network implementation[1] with AdEx neurons[2]

##@TODO:
* Add more compartments such that we can truthfully model A1 circuits of SST-expressing GABAergic interneurons firing at dendrites of excitatory neurons and PV-expressing GABAergic interneurons firing at somas of excitatory neurons, as per Park & Geffen [4]

* Test this by replicating the results of Pan et al.[3]

## References
* [2] Brette, R., & Gerstner, W. (2005). Adaptive exponential integrate-and-fire model as an effective description of neuronal activity. Journal of Neurophysiology, 94, 3637-3642. DOI: http://dx.doi.org/10.1152/jn.00686.2005.

* [1] Gerstner, W., Kistler, W.M., Naud, R., & Paninski, L. (2014). Neuronal Dynamics: From Single Neurons to Networks and Models of Cognition. New York: CUP.

* [3] Pan, Z., Chua, Y., Wu, J., Zhang, M., Li, H., & Ambikairajah, E. (2020). Motivated auditory neural encoding and decoding algorithm for spiking neural networks. Frontiers in Neuroscience: Neuromorphic Engineering, 13, 1420. DOI: http://dx.doi.org/10.3389/fnins.2019.01420

* [4] Park, Y., & Geffen, M.N. (preprint). A unifying mechanistic model of excitatory-inhibitory interactions in the auditory cortex. bioRxiv, 626358. DOI: http://dx.doi.org/10.1101/626358