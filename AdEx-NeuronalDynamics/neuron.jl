# AdEx Neuron implementation

# neuron parameter declarations
@with_kw struct AdEx_Parameters
    u_rest::Float64 = -70.6mV
    Δ_T::Float64 = 2mV
    𝜗_rh::Float64 = -45.4mV
    R::Float64 = 10Ω
    τ_w::Float64 = 144mS
    Θ_reset::Float64 = 20mV
end

# neuron struct declarations
@with_kw mutable struct AdEx_Neuron
    p::AdEx_Parameters = AdEx_Parameters()
    t_f::Float64 = -1ms
    α::Float64 = 4nS
    β::Float64 = 0.0805nA
    u::Float64 = p.u_rest
    w::Float64 = 0.1nA
end
