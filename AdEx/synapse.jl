# AdEx Neuron implementation

abstract type AdEx_Synapse end

@with_kw mutable struct AdEx_Synapse_NMDA <: AdEx_Synapse
    g_history::Array{AdEx_Float} = AdEx_Float[];
    I_history::Array{AdEx_Float} = AdEx_Float[];
    PreSyn::Int = -1
    PostSyn::Int = -1
    g_c_NMDA::AdEx_Float = 1.5nS
    τ_rise::AdEx_Float = 3ms
    τ_decay::AdEx_Float = 40ms
    Mg2p::AdEx_Float = 1.2mM
    α::AdEx_Float = (0.062mV)^-1
    β::AdEx_Float = 1 / 3.57mM
    g::AdEx_Float = 0nS
    I::AdEx_Float = 0mV
    E_syn::AdEx_Float = 0mV
end

AdEx_Synapse_g(s::AdEx_Synapse_NMDA, t, t_f, V) = s.g_c_NMDA * (1 - exp(-((t - t_f) / s.τ_rise))) * exp(-((t - t_f) / s.τ_decay)) * (1 + s.β * exp(-s.α * V) * s.Mg2p)^(-1) * Θ(t - t_f);
AdEx_Synapse_I(s::AdEx_Synapse_NMDA, t, V) = s.g * (V - s.E_syn);
