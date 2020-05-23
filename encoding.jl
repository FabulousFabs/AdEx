# main file for testing the BAE implementation as detailed in Pan et al. (2020)

include("BAE/bae.jl");

f, fs = BAE_get_audio_file("/users/fabianschneider/desktop/university/master/sem2/lab rotation III/julia/bae/data/TEST_DR6_FDRW0_SA1.WAV");
BAE_encode(f, fs);
