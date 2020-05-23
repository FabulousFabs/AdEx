# AdEx synapse functions

include("synapse_parameters.jl");

## Transmission current functions
AdEx_Synapse_I(s::AdEx_Synapse, t::AdEx_Float, V::AdEx_Float) = -s.g * ((V - s.E_syn));
AdEx_Synapse_I_D(s::AdEx_Synapse, t::AdEx_Float, V::AdEx_Float) = -s.g * (s.a_scale * s.D) * ((V - s.E_syn));
AdEx_Synapse_I_F(s::AdEx_Synapse, t::AdEx_Float, V::AdEx_Float) = -s.g * (s.b_scale * s.F) * ((V - s.E_syn));

AdEx_Synapse_dDdt(s::AdEx_Synapse, n::AdEx_Neuron, t::AdEx_Float, D::AdEx_Float) = (1 - D) / s.τ_D1 - (D * AdEx_Neuron_I(n, t)) / s.τ_D2;
AdEx_Synapse_dDdt(s::AdEx_Synapse, n::AdEx_Neuron, t::AdEx_Float) = (1 - s.D) / s.τ_D1 - (s.D * AdEx_Neuron_I(n, t)) / s.τ_D2;

AdEx_Synapse_dFdt(s::AdEx_Synapse, n::AdEx_Neuron, t::AdEx_Float, F::AdEx_Float) = (1 - F) / s.τ_F1 - (F * AdEx_Neuron_I(n, t)) / s.τ_F2;
AdEx_Synapse_dFdt(s::AdEx_Synapse, n::AdEx_Neuron, t::AdEx_Float) = (1 - s.F) / s.τ_F1 - (s.F * AdEx_Neuron_I(n, t)) / s.τ_F2;

## NMDA synapse
AdEx_Synapse_dgdt(s::AdEx_Synapse_NMDA, t::AdEx_Float, t_f::AdEx_Float, V::AdEx_Float) = s.g_c_NMDA * (1 - exp(-((t - t_f) / s.τ_rise))) * exp(-((t - t_f) / s.τ_decay)) * (1 + s.β * exp(-s.α * V) * s.Mg2p)^(-1) * Θ(t - t_f);

## GABA synapses
AdEx_Synapse_dgdt(s::AdEx_Synapse_GABA_A, t::AdEx_Float, t_f::AdEx_Float, V::AdEx_Float) = s.g_c_GABA_A * (1 - exp(-((t - t_f) / s.τ_rise))) * (s.a * exp(-((t - t_f) / s.τ_fast))) * Θ(t - t_f);
AdEx_Synapse_dgdt(s::AdEx_Synapse_GABA_B, t::AdEx_Float, t_f::AdEx_Float, V::AdEx_Float) = s.g_c_GABA_B * (1 - exp(-((t - t_f) / s.τ_rise))) * (s.a * exp(-((t - t_f) / s.τ_fast)) + (1 - s.a) * exp(-((t - t_f) / s.τ_slow))) * Θ(t - t_f);

## AMPA synapse
AdEx_Synapse_dgdt(s::AdEx_Synapse_AMPA, t::AdEx_Float, t_f::AdEx_Float, V::AdEx_Float) = s.g_c_AMPA * exp(-((t - t_f) / s.τ)) * Θ(t - t_f);
