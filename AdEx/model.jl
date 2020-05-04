using Parameters, DifferentialEquations, Sundials, Plots

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
    S::AdEx_Model_Synapses
end

function AdEx_Model_Create(ns::Array{AdEx_Model_Neurons})
    model = AdEx_Model();

    for nse in ns
        for i = 1:nse.N
            s = AdEx_Synapse[];
            for c in nse.S.C
                push!(s, nse.S.T(PreSyn=(size(model.Neurons)[1] + 1), PostSyn=c));
            end
            push!(model.Neurons, nse.T(Synapses=s));
        end
    end

    model;
end

function AdEx_ODE(du, u, p, t)
    p.V, p.w = u;

    if (p.V >= p.Θ_reset)
        terminate!(integrator);
    end

    du[1] = AdEx_Neuron_dVdt(p, t);
    du[2] = AdEx_Neuron_dwdt(p, t);
end

function AdEx_ODE_S(du, u, p, t)
    g_t = u;
    V, t_f, s = p;

    du[1] = AdEx_Synapse_g(s, t, t_f, V);
end

function AdEx_Model_Simulate(model::AdEx_Model, T::Tuple{AdEx_Float, AdEx_Float}, I_inj_kw)
    I_inj = map(x -> zeros(floor(Int, T[2]+1)), 1:size(model.Neurons)[1]);

    for t in I_inj_kw
        I_inj[t[1]] = t[2];
    end

    for i = 1:size(model.Neurons)[1]
        model.Neurons[i].I = I_inj[i];
    end

    solutions = [];

    for i = 1:size(model.Neurons)[1]
        prob = ODEProblem(AdEx_ODE, [model.Neurons[i].E_L, model.Neurons[i].w], T, model.Neurons[i]);
        global integrator = init(prob, Euler();
                                                saveat=1ms,
                                                dt=1ms,
                                                dtmin=1ms,
                                                dtmax=1ms,
                                                force_dtmin=true);
        sol = solve!(integrator);

        solution_u1 = sol[1,:];
        solution_u2 = sol[2,:];

        while (size(solution_u1)[1] < T[2])
            # synapses
            for j = 1:size(model.Neurons[i].Synapses)[1]
                s_prob = ODEProblem(AdEx_ODE_S, [0mV], T, [model.Neurons[i].V, size(solution_u2)[1]ms, model.Neurons[i].Synapses[j]]);
                s_integrator = init(prob, Euler();
                                                    saveat=1ms,
                                                    dt=1ms,
                                                    dtmin=1ms,
                                                    dtmax=1ms,
                                                    force_dtmin=true);
                s_sol = solve!(s_integrator);
                println(s_sol);
                #println(AdEx_Synapse_g(model.Neurons[i].Synapses[j], size(solution_u2)[1]ms, size(solution_u2)[1]ms, model.Neurons[i].V));
            end

            # prepare u & p
            model.Neurons[i].w += model.Neurons[i].β;
            u1 = [model.Neurons[i].E_L, model.Neurons[i].w]; # reset u
            model.Neurons[i].t_f = size(solution_u2)[1]ms; # reset t_f

            # re-solve ODE
            reinit!(integrator, u1; t0=model.Neurons[i].t_f);
            sol1 = solve!(integrator);

            # write histories
            solution_u1 = [solution_u1; sol1[1,:]];
            solution_u2 = [solution_u2; sol1[2,:]];
        end

        push!(solutions, [solution_u1, solution_u2]);
    end

    return solutions;
end

function AdEx_Model_Plot(r, c)
    s = size(r)[1];
    display(plot(r, layout=(s, c), lw=1, legend=false, ylims = (-90, 20)));
end

function AdEx_Model_Plot(r)
    AdEx_Model_Plot(r, 2);
end
