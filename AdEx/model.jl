using Parameters

include("units.jl");
include("funcs.jl");

include("abstracts.jl");
include("synapse.jl");
include("neuron.jl");

@with_kw mutable struct AdEx_Model
    Neurons::Array{AdEx_Neuron} = AdEx_Neuron[];
end

@with_kw mutable struct AdEx_Model_Synapses
    T::Type
    C::Array{Int}
end

@with_kw mutable struct AdEx_Model_Neurons
    T::Type
    N::Int
    S::Array{AdEx_Model_Synapses}
end

function AdEx_Model_Create(ns::Array{AdEx_Model_Neurons})
    model = AdEx_Model();

    for nse in ns
        for i = 1:nse.N
            s = AdEx_Synapse[];
            for j = 1:size(nse.S)[1]
                for c in nse.S[j].C
                    push!(s, nse.S[j].T(PreSyn=(size(model.Neurons)[1] + 1), PostSyn=c));
                end
            end
            push!(model.Neurons, nse.T(Synapses=s));
        end
    end

    model;
end

function AdEx_Model_Simulate(model::AdEx_Model, T::Tuple{AdEx_Float, AdEx_Float}, I_inj_kw::Array{Tuple{Int,Array{AdEx_Float,1}},1}; dt::AdEx_Float=0.1ms)
    ## setup injection currents & spike bin
    I_inj = map(x -> zeros(floor(Int, T[2]+1)), 1:size(model.Neurons)[1]);
    spike_bin::Array{Array{AdEx_Float}} = AdEx_Float[];

    for t in I_inj_kw
        I_inj[t[1]] = t[2];
    end

    for i = 1:size(model.Neurons)[1]
        model.Neurons[i].I = I_inj[i];
        push!(spike_bin, AdEx_Float[]);
    end

    ## integration loop
    for t = T[1]:dt:(T[2]-dt)
        # neuron loop
        for i = 1:size(model.Neurons)[1]
            # neuron, using Heun's method
            model.Neurons[i].V = model.Neurons[i].V + (dt / 2) * (AdEx_Neuron_dVdt(model.Neurons[i], t) + AdEx_Neuron_dVdt(model.Neurons[i], (t + dt), (model.Neurons[i].V + dt * AdEx_Neuron_dVdt(model.Neurons[i], t))));
            if (AdEx_Neuron_Firing_Condition(model.Neurons[i], t))
                AdEx_Neuron_Firing_Affect(model.Neurons[i], t);
                spike_bin[i] = [spike_bin[i]; t];
            end
            model.Neurons[i].w = model.Neurons[i].w + (dt / 2) * (AdEx_Neuron_dwdt(model.Neurons[i], t) + AdEx_Neuron_dwdt(model.Neurons[i], (t + dt), (model.Neurons[i].w + dt * AdEx_Neuron_dwdt(model.Neurons[i], t))));

            # synapses
            if model.Neurons[i].t_f > -1
                for j = 1:size(model.Neurons[i].Synapses)[1]
                    model.Neurons[i].Synapses[j].g = AdEx_Synapse_g(model.Neurons[i].Synapses[j], t, model.Neurons[i].t_f, model.Neurons[i].Θ_reset);

                    # account for differences in conductance between Exc -> SST, PV -> Exc & regular connections
                    if (typeof(model.Neurons[1]) in [AdEx_Neuron_Excitatory, AdEx_Interneuron_PV])
                        if model.Neurons[i].Synapses[j].PostSyn > 0
                            if ((typeof(model.Neurons[i]) == AdEx_Neuron_Excitatory) && (typeof(model.Neurons[model.Neurons[i].Synapses[j].PostSyn]) == AdEx_Interneuron_SST))
                                # Exc -> SST, using Heun's method
                                model.Neurons[i].Synapses[j].F = model.Neurons[i].Synapses[j].F + (dt / 2) * (AdEx_Synapse_dFdt(model.Neurons[i].Synapses[j], model.Neurons[i], t) + AdEx_Synapse_dFdt(model.Neurons[i].Synapses[j], model.Neurons[i], (t + dt), (model.Neurons[i].Synapses[j].F + dt * AdEx_Synapse_dFdt(model.Neurons[i].Synapses[j], model.Neurons[i], t))));
                                model.Neurons[i].Synapses[j].I = AdEx_Synapse_I_F(model.Neurons[i].Synapses[j], t, model.Neurons[i].Θ_reset);
                                model.Neurons[model.Neurons[i].Synapses[j].PostSyn].I[floor(Int, (t + dt)) + 1] += model.Neurons[i].Synapses[j].I;
                            elseif ((typeof(model.Neurons[i]) == AdEx_Interneuron_PV) && (typeof(model.Neurons[model.Neurons[i].Synapses[j].PostSyn]) == AdEx_Neuron_Excitatory))
                                # PV -> Exc, using Heun's method
                                model.Neurons[i].Synapses[j].D = model.Neurons[i].Synapses[j].D + (dt / 2) * (AdEx_Synapse_dDdt(model.Neurons[i].Synapses[j], model.Neurons[i], t) + AdEx_Synapse_dDdt(model.Neurons[i].Synapses[j], model.Neurons[i], (t + dt), (model.Neurons[i].Synapses[j].D + dt * AdEx_Synapse_dDdt(model.Neurons[i].Synapses[j], model.Neurons[i], t))));
                                model.Neurons[i].Synapses[j].I = AdEx_Synapse_I_D(model.Neurons[i].Synapses[j], t, model.Neurons[i].Θ_reset);
                                model.Neurons[model.Neurons[i].Synapses[j].PostSyn].I[floor(Int, (t + dt)) + 1] += model.Neurons[i].Synapses[j].I;
                            else
                                # Fringe cases handled regularly
                                model.Neurons[i].Synapses[j].I = AdEx_Synapse_I(model.Neurons[i].Synapses[j], t, model.Neurons[i].Θ_reset);
                                model.Neurons[model.Neurons[i].Synapses[j].PostSyn].I[floor(Int, (t + dt)) + 1] += model.Neurons[i].Synapses[j].I;
                            end
                        else
                            model.Neurons[i].Synapses[j].I = AdEx_Synapse_I(model.Neurons[i].Synapses[j], t, model.Neurons[i].Θ_reset);
                        end
                    else
                        model.Neurons[i].Synapses[j].I = AdEx_Synapse_I(model.Neurons[i].Synapses[j], t, model.Neurons[i].Θ_reset);
                        if model.Neurons[i].Synapses[j].PostSyn > 0
                            model.Neurons[model.Neurons[i].Synapses[j].PostSyn].I[floor(Int, (t + dt)) + 1] += model.Neurons[i].Synapses[j].I;
                        end
                    end

                    # synapse histories
                    model.Neurons[i].Synapses[j].g_history = [model.Neurons[i].Synapses[j].g_history; model.Neurons[i].Synapses[j].g];
                    model.Neurons[i].Synapses[j].I_history = [model.Neurons[i].Synapses[j].I_history; model.Neurons[i].Synapses[j].I];
                end
            end

            # neuron histories
            model.Neurons[i].V_history = [model.Neurons[i].V_history; model.Neurons[i].V];
            model.Neurons[i].w_history = [model.Neurons[i].w_history; model.Neurons[i].w];
        end
    end

    spike_bin;
end
