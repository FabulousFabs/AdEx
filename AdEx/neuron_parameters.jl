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
    τ_w::AdEx_Float = 144mS
    Θ_reset::AdEx_Float = 28mV
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
    R::AdEx_Float = 10Ω
    τ_w::AdEx_Float = 144mS
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
    g_L::AdEx_Float = 6.25nS
    E_L::AdEx_Float = -60mV
    Δ_T::AdEx_Float = 1mV
    𝜗_rh::AdEx_Float = -40mV
    C::AdEx_Float = 180pF
    τ_w::AdEx_Float = 144mS
    Θ_reset::AdEx_Float = 28mV
    Δ_abs::AdEx_Float = 5ms
    α::AdEx_Float = 4nS
    β::AdEx_Float = 0.0805nA
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
    g_L::AdEx_Float = 5nS
    E_L::AdEx_Float = -60mV
    Δ_T::AdEx_Float = 0.25mV
    𝜗_rh::AdEx_Float = -40mV
    C::AdEx_Float = 80pF
    τ_w::AdEx_Float = 144mS
    Θ_reset::AdEx_Float = 28mV
    Δ_abs::AdEx_Float = 5ms
    α::AdEx_Float = 4nS
    β::AdEx_Float = 0.0805nA
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
    g_L::AdEx_Float = 5nS
    E_L::AdEx_Float = -60mV
    Δ_T::AdEx_Float = 1mV
    𝜗_rh::AdEx_Float = -45mV
    C::AdEx_Float = 80pF
    τ_w::AdEx_Float = 144mS
    Θ_reset::AdEx_Float = 28mV
    Δ_abs::AdEx_Float = 5ms
    α::AdEx_Float = 4nS
    β::AdEx_Float = 0.0805nA
    V::AdEx_Float = E_L
    w::AdEx_Float = 0nA
    t_f::AdEx_Float = -1ms
end
