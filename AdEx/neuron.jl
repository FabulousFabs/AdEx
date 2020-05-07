# AdEx neuron functions

include("neuron_parameters.jl");

## Neuron I(t)
AdEx_Neuron_I(n::AdEx_Neuron, t::AdEx_Float) = n.I[floor(Int, t) + 1];

## T2 neuron taken from neuronal dynamics book
AdEx_Neuron_dVdt(n::AdEx_Neuron_T2, t::AdEx_Float, V::AdEx_Float) = n.C⁻ * (-(V - n.u_rest) + n.Δ_T * exp((V - n.𝜗_rh) / n.Δ_T) - n.R * n.w + n.R * AdEx_Neuron_I(n, t));
AdEx_Neuron_dVdt(n::AdEx_Neuron_T2, t::AdEx_Float) = n.C⁻ * (-(n.V - n.u_rest) + n.Δ_T * exp((n.V - n.𝜗_rh) / n.Δ_T) - n.R * n.w + n.R * AdEx_Neuron_I(n, t));

AdEx_Neuron_dwdt(n::AdEx_Neuron_T2, t::AdEx_Float, w::AdEx_Float) = n.τ_w⁻ * (n.α * (n.V - n.u_rest) - w) + n.β * n.τ_w * δ(t - n.t_f);
AdEx_Neuron_dwdt(n::AdEx_Neuron_T2, t::AdEx_Float) = n.τ_w⁻ * (n.α * (n.V - n.u_rest) - n.w) + n.β * n.τ_w * δ(t - n.t_f);

AdEx_Neuron_Firing_Condition(n::AdEx_Neuron_T2, t::AdEx_Float) = n.V >= n.Θ_reset;

function AdEx_Neuron_Firing_Affect(n::AdEx_Neuron_T2, t::AdEx_Float)
    n.w += n.β;
    n.t_f = t;
    n.V = n.u_rest;
end

## Neuron_T1, Neuron_Excitatory, Interneuron_PV, Interneuron_SST
AdEx_Neuron_dVdt(n::AdEx_Neuron, t::AdEx_Float, V::AdEx_Float) = n.C⁻ * (-n.g_L * (V - n.E_L) + n.g_L * n.Δ_T * exp((V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w);
AdEx_Neuron_dVdt(n::AdEx_Neuron, t::AdEx_Float) = n.C⁻ * (-n.g_L * (n.V - n.E_L) + n.g_L * n.Δ_T * exp((n.V - n.𝜗_rh) / n.Δ_T) + AdEx_Neuron_I(n, t) - n.w);

AdEx_Neuron_dwdt(n::AdEx_Neuron, t::AdEx_Float, w::AdEx_Float) = n.τ_w⁻ * (n.α * (n.V - n.E_L) - w);
AdEx_Neuron_dwdt(n::AdEx_Neuron, t::AdEx_Float) = n.τ_w⁻ * (n.α * (n.V - n.E_L) - n.w);

AdEx_Neuron_Firing_Condition(n::AdEx_Neuron, t::AdEx_Float) = n.V >= n.Θ_reset;

function AdEx_Neuron_Firing_Affect(n::AdEx_Neuron, t::AdEx_Float)
    n.w += n.β;
    n.t_f = t;
    n.V = n.E_L;
end
