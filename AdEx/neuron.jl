# AdEx neuron implementations

include("neuron_parameters.jl");

## Neuron I(t)
AdEx_Neuron_I(n::AdEx_Neuron, t::AdEx_Float) = n.I[floor(Int, t) + 1];

## T1 neuron taken from Brette & Gerstner (2005)
AdEx_Neuron_dVdt(n::AdEx_Neuron_T1, t::AdEx_Float, V::AdEx_Float) = -n.g_L * (V - n.E_L) + n.g_L * n.Δ_T * exp((V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w;
AdEx_Neuron_dVdt(n::AdEx_Neuron_T1, t::AdEx_Float) = -n.g_L * (n.V - n.E_L) + n.g_L * n.Δ_T * exp((n.V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w;

AdEx_Neuron_dwdt(n::AdEx_Neuron_T1, t::AdEx_Float, w::AdEx_Float) = n.α * (n.V - n.E_L) - w + n.β * n.τ_w * δ(t - n.t_f);
AdEx_Neuron_dwdt(n::AdEx_Neuron_T1, t::AdEx_Float) = n.α * (n.V - n.E_L) - n.w + n.β * n.τ_w * δ(t - n.t_f);

AdEx_Neuron_Firing_Condition(n::AdEx_Neuron_T1, t::AdEx_Float) = n.V >= n.Θ_reset;

function AdEx_Neuron_Firing_Affect(n::AdEx_Neuron_T1, t::AdEx_Float)
    n.w += n.β;
    n.t_f = t;
    n.V = n.E_L;
end

## T2 neuron taken from NeuronalDynamics book
AdEx_Neuron_dVdt(n::AdEx_Neuron_T2, t::AdEx_Float, V::AdEx_Float) = -(V - n.u_rest) + n.Δ_T * exp((V - n.𝜗_rh) / n.Δ_T) - n.R * n.w + n.R * AdEx_Neuron_I(n, t);
AdEx_Neuron_dVdt(n::AdEx_Neuron_T2, t::AdEx_Float) = -(n.V - n.u_rest) + n.Δ_T * exp((n.V - n.𝜗_rh) / n.Δ_T) - n.R * n.w + n.R * AdEx_Neuron_I(n, t);

AdEx_Neuron_dwdt(n::AdEx_Neuron_T2, t::AdEx_Float, w::AdEx_Float) = n.α * (n.V - n.u_rest) - w + n.β * n.τ_w * δ(t - n.t_f);
AdEx_Neuron_dwdt(n::AdEx_Neuron_T2, t::AdEx_Float) = n.α * (n.V - n.u_rest) - n.w + n.β * n.τ_w * δ(t - n.t_f);

AdEx_Neuron_Firing_Condition(n::AdEx_Neuron_T2, t::AdEx_Float) = n.V >= n.Θ_reset;

function AdEx_Neuron_Firing_Affect(n::AdEx_Neuron_T2, t::AdEx_Float)
    n.w += n.β;
    n.t_f = t;
    n.V = n.u_rest;
end

## Excitatory neuron taken from Park & Geffen (2020)
AdEx_Neuron_dVdt(n::AdEx_Neuron_Excitatory, t::AdEx_Float, V::AdEx_Float) = -n.g_L * (V - n.E_L) + n.g_L * n.Δ_T * exp((V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w;
AdEx_Neuron_dVdt(n::AdEx_Neuron_Excitatory, t::AdEx_Float) = -n.g_L * (n.V - n.E_L) + n.g_L * n.Δ_T * exp((n.V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w;

AdEx_Neuron_dwdt(n::AdEx_Neuron_Excitatory, t::AdEx_Float, w::AdEx_Float) = n.α * (n.V - n.E_L) - w + n.β * n.τ_w * δ(t - n.t_f);
AdEx_Neuron_dwdt(n::AdEx_Neuron_Excitatory, t::AdEx_Float) = n.α * (n.V - n.E_L) - n.w + n.β * n.τ_w * δ(t - n.t_f);

AdEx_Neuron_Firing_Condition(n::AdEx_Neuron_Excitatory, t::AdEx_Float) = n.V >= n.Θ_reset;

function AdEx_Neuron_Firing_Affect(n::AdEx_Neuron_Excitatory, t::AdEx_Float)
    n.w += n.β;
    n.t_f = t;
    n.V = n.E_L;
end

## PV neuron taken from Park & Geffen (2020)
AdEx_Neuron_dVdt(n::AdEx_Interneuron_PV, t::AdEx_Float, V::AdEx_Float) = -n.g_L * (V - n.E_L) + n.g_L * n.Δ_T * exp((V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w;
AdEx_Neuron_dVdt(n::AdEx_Interneuron_PV, t::AdEx_Float) = -n.g_L * (n.V - n.E_L) + n.g_L * n.Δ_T * exp((n.V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w;

AdEx_Neuron_dwdt(n::AdEx_Interneuron_PV, t::AdEx_Float, w::AdEx_Float) = n.α * (n.V - n.E_L) - w + n.β * n.τ_w * δ(t - n.t_f);
AdEx_Neuron_dwdt(n::AdEx_Interneuron_PV, t::AdEx_Float) = n.α * (n.V - n.E_L) - n.w + n.β * n.τ_w * δ(t - n.t_f);

AdEx_Neuron_Firing_Condition(n::AdEx_Interneuron_PV, t::AdEx_Float) = n.V >= n.Θ_reset;

function AdEx_Neuron_Firing_Affect(n::AdEx_Interneuron_PV, t::AdEx_Float)
    n.w += n.β;
    n.t_f = t;
    n.V = n.E_L;
end

## SST neuron taken from Park & Geffen (2020)
AdEx_Neuron_dVdt(n::AdEx_Interneuron_SST, t::AdEx_Float, V::AdEx_Float) = -n.g_L * (V - n.E_L) + n.g_L * n.Δ_T * exp((V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w;
AdEx_Neuron_dVdt(n::AdEx_Interneuron_SST, t::AdEx_Float) = -n.g_L * (n.V - n.E_L) + n.g_L * n.Δ_T * exp((n.V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w;

AdEx_Neuron_dwdt(n::AdEx_Interneuron_SST, t::AdEx_Float, w::AdEx_Float) = n.α * (n.V - n.E_L) - w + n.β * n.τ_w * δ(t - n.t_f);
AdEx_Neuron_dwdt(n::AdEx_Interneuron_SST, t::AdEx_Float) = n.α * (n.V - n.E_L) - n.w + n.β * n.τ_w * δ(t - n.t_f);

AdEx_Neuron_Firing_Condition(n::AdEx_Interneuron_SST, t::AdEx_Float) = n.V >= n.Θ_reset;

function AdEx_Neuron_Firing_Affect(n::AdEx_Interneuron_SST, t::AdEx_Float)
    n.w += n.β;
    n.t_f = t;
    n.V = n.E_L;
end
