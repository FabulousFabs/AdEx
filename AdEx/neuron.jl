# AdEx Neuron implementation

# neuron parameter declarations
@with_kw struct AdEx_Parameters
    g_L::Float64 = 30nS
    E_L::Float64 = -70.6mV
    Δ_T::Float64 = 2mV
    𝜗_rh::Float64 = -45.4mV
    C::Float64 = 281pF
    τ_w::Float64 = 144mS
    Θ_reset::Float64 = 20mV
end

# neuron struct declarations
@with_kw mutable struct AdEx_Neuron
    p::AdEx_Parameters = AdEx_Parameters()
    α::Float64 = 4nS
    β::Float64 = 0.0805nA
    V::Float64 = p.E_L;
    w::Float64 = 0nA
end
