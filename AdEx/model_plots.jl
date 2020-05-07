using Plots

function AdEx_Plot_Spikes(s::Array{Array{AdEx_Float}}, T::Tuple{AdEx_Float, AdEx_Float}; dt::AdEx_Float=0.1ms)
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
