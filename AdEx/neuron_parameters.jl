# AdEx neuron parameters

## T1 neuron taken from Brette & Gerstner (2005)
@with_kw mutable struct AdEx_Neuron_T1 <: AdEx_Neuron
    V_history::Array{AdEx_Float} = AdEx_Float[];
    w_history::Array{AdEx_Float} = AdEx_Float[];
    I::Array{AdEx_Float} = AdEx_Float[];
    Synapses::Array{AdEx_Synapse} = AdEx_Synapse[];
    g_L::AdEx_Float = 30nS
    E_L::AdEx_Float = -70.6mV
    Δ_T::AdEx_Float = 0.5mV
    𝜗_rh::AdEx_Float = -45.4mV
    C::AdEx_Float = 281pF
    C⁻::AdEx_Float = 1/C
    τ_w::AdEx_Float = 144ms
    τ_w⁻::AdEx_Float = 1/τ_w
    Θ_reset::AdEx_Float = 20mV
    Δ_abs::AdEx_Float = 5ms
    α::AdEx_Float = 4nS
    β::AdEx_Float = 0.0805nA
    V::AdEx_Float = E_L
    w::AdEx_Float = 0nA
    t_f::AdEx_Float = -1ms
end

## T2 neuron taken from NeuronalDynamics book
@with_kw mutable struct AdEx_Neuron_T2 <: AdEx_Neuron
    V_history::Array{AdEx_Float} = AdEx_Float[];
    w_history::Array{AdEx_Float} = AdEx_Float[];
    I::Array{AdEx_Float} = AdEx_Float[];
    Synapses::Array{AdEx_Synapse} = AdEx_Synapse[];
    u_rest::AdEx_Float = -70.6mV
    Δ_T::AdEx_Float = 2mV
    𝜗_rh::AdEx_Float = -45.4mV
    C::AdEx_Float = 281pF
    C⁻::AdEx_Float = 1/C
    R::AdEx_Float = 10Ω
    τ_w::AdEx_Float = 144ms
    τ_w⁻::AdEx_Float = 1/τ_w
    Θ_reset::AdEx_Float = 20mV
    V::AdEx_Float = u_rest;
    t_f::AdEx_Float = -1ms
    α::AdEx_Float = 4nS
    β::AdEx_Float = 0.0805nA
    u::AdEx_Float = u_rest
    w::AdEx_Float = 0nA
end

## Excitatory neuron taken from Park & Geffen (2020)
@with_kw mutable struct AdEx_Neuron_Excitatory <: AdEx_Neuron
    V_history::Array{AdEx_Float} = AdEx_Float[];
    w_history::Array{AdEx_Float} = AdEx_Float[];
    I::Array{AdEx_Float} = AdEx_Float[];
    Synapses::Array{AdEx_Synapse} = AdEx_Synapse[];

    C::AdEx_Float = 281pF
    C⁻::AdEx_Float = 1/C
    g_L::AdEx_Float = 40nS
    E_L::AdEx_Float = -70.6mV
    τ_w::AdEx_Float = 144ms
    τ_w⁻::AdEx_Float = 1/τ_w
    α::AdEx_Float = 4nS
    β::AdEx_Float = 0.805nA
    Δ_T::AdEx_Float = 2mV
    𝜗_rh::AdEx_Float = -44mV
    Θ_reset::AdEx_Float = -50.4mV

    V::AdEx_Float = E_L
    w::AdEx_Float = 0nA
    t_f::AdEx_Float = -1ms
end

## PV neuron taken from Park & Geffen (2020)
@with_kw mutable struct AdEx_Interneuron_PV <: AdEx_Neuron
    V_history::Array{AdEx_Float} = AdEx_Float[];
    w_history::Array{AdEx_Float} = AdEx_Float[];
    I::Array{AdEx_Float} = AdEx_Float[];
    Synapses::Array{AdEx_Synapse} = AdEx_Synapse[];

    C::AdEx_Float = 281pF
    C⁻::AdEx_Float = 1/C
    g_L::AdEx_Float = 40nS
    E_L::AdEx_Float = -70.6mV
    τ_w::AdEx_Float = 144ms
    τ_w⁻::AdEx_Float = 1/τ_w
    α::AdEx_Float = 4nS
    β::AdEx_Float = 0.805nA
    Δ_T::AdEx_Float = 2mV
    𝜗_rh::AdEx_Float = -44mV
    Θ_reset::AdEx_Float = -50.4mV

    V::AdEx_Float = E_L
    w::AdEx_Float = 0nA
    t_f::AdEx_Float = -1ms
end

## SST neuron taken from Park & Geffen (2020)
@with_kw mutable struct AdEx_Interneuron_SST <: AdEx_Neuron
    V_history::Array{AdEx_Float} = AdEx_Float[];
    w_history::Array{AdEx_Float} = AdEx_Float[];
    I::Array{AdEx_Float} = AdEx_Float[];
    Synapses::Array{AdEx_Synapse} = AdEx_Synapse[];

    C::AdEx_Float = 281pF
    C⁻::AdEx_Float = 1/C
    g_L::AdEx_Float = 40nS
    E_L::AdEx_Float = -70.6mV
    τ_w::AdEx_Float = 144ms
    τ_w⁻::AdEx_Float = 1/τ_w
    α::AdEx_Float = 4nS
    β::AdEx_Float = 0.805nA
    Δ_T::AdEx_Float = 2mV
    𝜗_rh::AdEx_Float = -44mV
    Θ_reset::AdEx_Float = -50.4mV

    V::AdEx_Float = E_L
    w::AdEx_Float = 0nA
    t_f::AdEx_Float = -1ms
end
