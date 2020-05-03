using Parameters, DifferentialEquations, Plots

include("units.jl");
include("funcs.jl");
include("neuron.jl");

@with_kw mutable struct AdEx_Model
    Neurons::Array{AdEx_Neuron}
end

function AdEx_Model_Create(Number::Int)
    Neurons = AdEx_Neuron[];

    for i = 1:Number
        push!(Neurons, AdEx_Neuron());
    end

    AdEx_Model(Neurons=Neurons);
end

function AdEx_ODE(du, u, p, t)
    global integrator;
    u_, w = u;
    u_rest, Δ_T, 𝜗_rh, R, τ_w, Θ_reset, t_f, a, b, I = p;

    if (u_ >= Θ_reset)
        terminate!(integrator);
    end

    du[1] = -(u_ - u_rest) + Δ_T * exp((u_ - 𝜗_rh) / Δ_T) - R * w + R * I(t);
    du[2] = a * (u_ - u_rest) - w + b * τ_w * δ(t - t_f);
end

function AdEx_Model_Run(m::AdEx_Model, T::Tuple{Float64, Float64}, I::Function)
    results = [];
    spikes = [];

    for i = 1:size(m.Neurons)[1]
        ## initial run of neuron
        # prepare p
        @unpack u_rest, Δ_T, 𝜗_rh, R, τ_w, Θ_reset = m.Neurons[i].p;
        p = [u_rest, Δ_T, 𝜗_rh, R, τ_w, Θ_reset, m.Neurons[i].t_f, m.Neurons[i].α, m.Neurons[i].β, I];

        # prepare and solve ODE
        prob = ODEProblem(AdEx_ODE, [m.Neurons[i].u, m.Neurons[i].w], T, p);
        alg, extra_kwargs = default_algorithm(prob);
        global integrator = init(prob, alg);
        sol = solve!(integrator);

        # write histories
        solution_u1 = sol[1,:];
        solution_u2 = sol[2,:];

        ## re-compute for spikes
        while size(solution_u1)[1] < T[2]
            # prepare u & p
            u1 = [u_rest, solution_u2[end]]; # reset u
            p[7] = size(solution_u1)[1]; # set t_f
            append!(spikes, p[7]); # spike bin

            # re-solve ODE
            reinit!(integrator, u1; t0=(p[7]));
            sol1 = solve!(integrator);

            # write histories
            solution_u1 = [solution_u1; sol1[1,:]];
            solution_u2 = [solution_u2; sol1[2,:]];
        end

        # write spike bins
        spike_bin = collect(1:size(solution_u1)[1]);
        spike_bin = map(x -> ifelse(x in spikes, 1, 0), spike_bin);

        push!(results, [solution_u1 solution_u2 spike_bin]);
    end

    results
end

function AdEx_Model_Plot(r, c)
    s = size(r)[1];
    display(plot(r, layout=(s, c), lw=1, legend=false));
end

function AdEx_Model_Plot(r)
    AdEx_Model_Plot(r, 3);
end
