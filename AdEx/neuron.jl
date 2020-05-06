# AdEx neuron implementations

## abstract neuron definition
abstract type AdEx_Neuron end

AdEx_Neuron_I(n::AdEx_Neuron, t) = n.I[floor(Int, t) + 1];

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

AdEx_Neuron_dVdt(n::AdEx_Neuron_T1, t, V) = -n.g_L * (V - n.E_L) + n.g_L * n.Δ_T * exp((V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w;
AdEx_Neuron_dVdt(n::AdEx_Neuron_T1, t) = -n.g_L * (n.V - n.E_L) + n.g_L * n.Δ_T * exp((n.V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w;

AdEx_Neuron_dwdt(n::AdEx_Neuron_T1, t, w) = n.α * (n.V - n.E_L) - w + n.β * n.τ_w * δ(t - n.t_f);
AdEx_Neuron_dwdt(n::AdEx_Neuron_T1, t) = n.α * (n.V - n.E_L) - n.w + n.β * n.τ_w * δ(t - n.t_f);

AdEx_Neuron_Firing_Condition(n::AdEx_Neuron_T1, t) = n.V >= n.Θ_reset;

function AdEx_Neuron_Firing_Affect(n::AdEx_Neuron_T1, t)
    n.w += n.β;
    n.t_f = t;
    n.V = n.E_L;
end

## T2 neuron taken from NeuronalDynamics book
@with_kw mutable struct AdEx_Neuron_T2 <: AdEx_Neuron
    V_history::Array{AdEx_Float} = AdEx_Float[];
    w_history::Array{AdEx_Float} = AdEx_Float[];
    I::Array{AdEx_Float} = AdEx_Float[];
    Synapses::Array{AdEx_Synapse} = AdEx_Synapse[];
    u_rest::Float64 = -70.6mV
    Δ_T::Float64 = 2mV
    𝜗_rh::Float64 = -45.4mV
    R::Float64 = 10Ω
    τ_w::Float64 = 144mS
    Θ_reset::Float64 = 20mV
    V::AdEx_Float = u_rest;
    t_f::Float64 = -1ms
    α::Float64 = 4nS
    β::Float64 = 0.0805nA
    u::Float64 = u_rest
    w::Float64 = 0nA
end

AdEx_Neuron_dVdt(n::AdEx_Neuron_T2, t, V) = -(V - n.u_rest) + n.Δ_T * exp((V - n.𝜗_rh) / n.Δ_T) - n.R * n.w + n.R * AdEx_Neuron_I(n, t);
AdEx_Neuron_dVdt(n::AdEx_Neuron_T2, t) = -(n.V - n.u_rest) + n.Δ_T * exp((n.V - n.𝜗_rh) / n.Δ_T) - n.R * n.w + n.R * AdEx_Neuron_I(n, t);

AdEx_Neuron_dwdt(n::AdEx_Neuron_T2, t, w) = n.α * (n.V - n.u_rest) - w + n.β * n.τ_w * δ(t - n.t_f);
AdEx_Neuron_dwdt(n::AdEx_Neuron_T2, t) = n.α * (n.V - n.u_rest) - n.w + n.β * n.τ_w * δ(t - n.t_f);

AdEx_Neuron_Firing_Condition(n::AdEx_Neuron_T2, t) = n.V >= n.Θ_reset;

function AdEx_Neuron_Firing_Affect(n::AdEx_Neuron_T2, t)
    n.w += n.β;
    n.t_f = t;
    n.V = n.u_rest;
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

AdEx_Neuron_dVdt(n::AdEx_Neuron_Excitatory, t, V) = -n.g_L * (V - n.E_L) + n.g_L * n.Δ_T * exp((V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w;
AdEx_Neuron_dVdt(n::AdEx_Neuron_Excitatory, t) = -n.g_L * (n.V - n.E_L) + n.g_L * n.Δ_T * exp((n.V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w;

AdEx_Neuron_dwdt(n::AdEx_Neuron_Excitatory, t, w) = n.α * (n.V - n.E_L) - w + n.β * n.τ_w * δ(t - n.t_f);
AdEx_Neuron_dwdt(n::AdEx_Neuron_Excitatory, t) = n.α * (n.V - n.E_L) - n.w + n.β * n.τ_w * δ(t - n.t_f);

AdEx_Neuron_Firing_Condition(n::AdEx_Neuron_Excitatory, t) = n.V >= n.Θ_reset;

function AdEx_Neuron_Firing_Affect(n::AdEx_Neuron_Excitatory, t)
    n.w += n.β;
    n.t_f = t;
    n.V = n.E_L;
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

AdEx_Neuron_dVdt(n::AdEx_Interneuron_PV, t, V) = -n.g_L * (V - n.E_L) + n.g_L * n.Δ_T * exp((V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w;
AdEx_Neuron_dVdt(n::AdEx_Interneuron_PV, t) = -n.g_L * (n.V - n.E_L) + n.g_L * n.Δ_T * exp((n.V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w;

AdEx_Neuron_dwdt(n::AdEx_Interneuron_PV, t, w) = n.α * (n.V - n.E_L) - w + n.β * n.τ_w * δ(t - n.t_f);
AdEx_Neuron_dwdt(n::AdEx_Interneuron_PV, t) = n.α * (n.V - n.E_L) - n.w + n.β * n.τ_w * δ(t - n.t_f);

AdEx_Neuron_Firing_Condition(n::AdEx_Interneuron_PV, t) = n.V >= n.Θ_reset;

function AdEx_Neuron_Firing_Affect(n::AdEx_Interneuron_PV, t)
    n.w += n.β;
    n.t_f = t;
    n.V = n.E_L;
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

AdEx_Neuron_dVdt(n::AdEx_Interneuron_SST, t, V) = -n.g_L * (V - n.E_L) + n.g_L * n.Δ_T * exp((V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w;
AdEx_Neuron_dVdt(n::AdEx_Interneuron_SST, t) = -n.g_L * (n.V - n.E_L) + n.g_L * n.Δ_T * exp((n.V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w;

AdEx_Neuron_dwdt(n::AdEx_Interneuron_SST, t, w) = n.α * (n.V - n.E_L) - w + n.β * n.τ_w * δ(t - n.t_f);
AdEx_Neuron_dwdt(n::AdEx_Interneuron_SST, t) = n.α * (n.V - n.E_L) - n.w + n.β * n.τ_w * δ(t - n.t_f);

AdEx_Neuron_Firing_Condition(n::AdEx_Interneuron_SST, t) = n.V >= n.Θ_reset;

function AdEx_Neuron_Firing_Affect(n::AdEx_Interneuron_SST, t)
    n.w += n.β;
    n.t_f = t;
    n.V = n.E_L;
end
