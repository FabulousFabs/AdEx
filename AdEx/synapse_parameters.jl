# AdEx Neuron implementation

abstract type AdEx_Synapse end

## NMDA synapse
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
    F::AdEx_Float = 1
    τ_F1::AdEx_Float = 1500ms
    τ_F2::AdEx_Float = 100ms
    b_scale::AdEx_Float = 3
end

## GABA synapses
@with_kw mutable struct AdEx_Synapse_GABA_A <: AdEx_Synapse
    g_history::Array{AdEx_Float} = AdEx_Float[];
    I_history::Array{AdEx_Float} = AdEx_Float[];
    PreSyn::Int = -1
    PostSyn::Int = -1
    a::AdEx_Float = 1
    τ_rise::AdEx_Float = 1ms
    τ_fast::AdEx_Float = 6ms
    E_syn::AdEx_Float = -75mV
    g::AdEx_Float = 0nS
    g_c_GABA_A::AdEx_Float = 40nS
    I::AdEx_Float = 0mV
    D::AdEx_Float = 1
    τ_D1::AdEx_Float = 1000ms
    τ_D2::AdEx_Float = 250ms
    a_scale::AdEx_Float = 1.7
end

@with_kw mutable struct AdEx_Synapse_GABA_B <: AdEx_Synapse
    g_history::Array{AdEx_Float} = AdEx_Float[];
    I_history::Array{AdEx_Float} = AdEx_Float[];
    PreSyn::Int = -1
    PostSyn::Int = -1
    a::AdEx_Float = 0.8
    τ_rise::AdEx_Float = 20ms
    τ_fast::AdEx_Float = 100ms
    τ_slow::AdEx_Float = 500ms
    E_syn::AdEx_Float = -75mV
    g::AdEx_Float = 0nS
    g_c_GABA_B::AdEx_Float = 40nS
    I::AdEx_Float = 0mV
    D::AdEx_Float = 1
    τ_D1::AdEx_Float = 1000ms
    τ_D2::AdEx_Float = 250ms
    a_scale::AdEx_Float = 1.7
end

## AMPA synapse
@with_kw mutable struct AdEx_Synapse_AMPA <: AdEx_Synapse
    g_history::Array{AdEx_Float} = AdEx_Float[];
    I_history::Array{AdEx_Float} = AdEx_Float[];
    PreSyn::Int = -1
    PostSyn::Int = -1
    g_c_AMPA::AdEx_Float = 40nS
    g::AdEx_Float = 0nS
    τ::AdEx_Float = 5ms
    I::AdEx_Float = 0mV
    E_syn::AdEx_Float = 0mV
    F::AdEx_Float = 1
    τ_F1::AdEx_Float = 1500ms
    τ_F2::AdEx_Float = 100ms
    b_scale::AdEx_Float = 3
end
