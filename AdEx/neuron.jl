# AdEx Neuron implementation

## abstract neuron definition
abstract type AdEx_Neuron end

AdEx_Neuron_I(n::AdEx_Neuron, t) = n.I[floor(Int, t) + 1];

## T1 neuron taken from Brette & Gerstner (2005)
@with_kw mutable struct AdEx_Neuron_T1 <: AdEx_Neuron
    I::Array{AdEx_Float} = AdEx_Float[0.0];
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
    t_f::AdEx_Float = -10ms
end

AdEx_Neuron_dVdt(n::AdEx_Neuron_T1, t) = -n.g_L * (n.V - n.E_L) + n.g_L * n.Δ_T * exp((n.V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w;
AdEx_Neuron_dwdt(n::AdEx_Neuron_T1, t) = n.α * (n.V - n.E_L) - n.w + n.β * n.τ_w * δ(t - n.t_f);

## T2 neuron taken from NeuronalDynamics book
