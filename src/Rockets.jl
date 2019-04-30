"""
A module for doing simple Newton style physics related to the movement
of bodies. In particular it was made to do simple rocket equations.
"""
module Rockets

include("geometry/Geometri.jl")
include("physics/Fysikk.jl")
include("rocket-equations.jl")
include("transform.jl")
include("rocket-parts.jl")
include("rocket.jl")
include("rocket-builder.jl")
include("simulator.jl")
include("plotting.jl")

end # module
