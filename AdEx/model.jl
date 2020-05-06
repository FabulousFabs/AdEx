using Parameters, Plots

include("units.jl");
include("funcs.jl");

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
            #for c in nse.S.C
            #    push!(s, nse.S.T(PreSyn=(size(model.Neurons)[1] + 1), PostSyn=c));
            #end
            push!(model.Neurons, nse.T(Synapses=s));
        end
    end

    model;
end

function AdEx_Model_Simulate(model::AdEx_Model, T::Tuple{AdEx_Float, AdEx_Float}, I_inj_kw; dt=0.1ms)
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
                    model.Neurons[i].Synapses[j].I = AdEx_Synapse_I(model.Neurons[i].Synapses[j], t, model.Neurons[i].Θ_reset);
                    if model.Neurons[i].Synapses[j].PostSyn > 0
                        model.Neurons[model.Neurons[i].Synapses[j].PostSyn].I[floor(Int, (t + dt)) + 1] += model.Neurons[i].Synapses[j].I;
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

function AdEx_Plot_Spikes(s, T; dt=0.1ms)
    labels = Array{String}(undef, 1, 0)
    X::Array{Array{AdEx_Float}} = AdEx_Float[];
    Y = 1:size(s)[1];
    y = 0;

    for i in Y
        y += 1;
        labels = [labels    "Neuron " * string(y) * ""];
        push!(X, collect(T[1]:dt:(T[2] + T[2] / 4)) .* 0);

        for j = 1:size(s[i])[1]
            X[i][floor(Int, s[i][j])] = i;
        end
    end

    p = plot(X, seriestype=:scatter, markershape=:vline, ylims = (0.5, floor(Int, y) + 0.5), yaxis=(:flip, false), grid=:x, label=labels, legend=:best, title="Spike trains");
end

function AdEx_Model_Plot_Neurons(model::AdEx_Model)
    plots = [];
    labels = Array{String}(undef, 1, 0);

    for i = 1:size(model.Neurons)[1]
        l = ["N" * string(i) * ":I(t)"  "N" * string(i) * ":V(t)"   "N" * string(i) * ":w(t)"];
        labels = [labels    l];
        push!(plots, [model.Neurons[i].I, model.Neurons[i].V_history, model.Neurons[i].w_history]);
    end

    p = plot(plots, layout=(size(plots)[1], 3), lw=1, label=labels, legend=:best);
end

function AdEx_Model_Plot_Synapses(model::AdEx_Model)
    plots = [];
    labels = Array{String}(undef, 1, 0);

    for i = 1:size(model.Neurons)[1]
        for j = 1:size(model.Neurons[i].Synapses)[1]
            l = ["I(" * string(i) * "_" * string(j) * ", t)"    "g(" * string(i) * "_" * string(j) * ", t)"];
            labels = [labels    l];
            push!(plots, [model.Neurons[i].Synapses[j].I_history, model.Neurons[i].Synapses[j].g_history]);
        end
    end

    p = plot(plots, layout=(size(plots)[1], 2), lw=1, label=labels, legend=:best);
end
