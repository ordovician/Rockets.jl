"""
A module for doing simple Newton style physics related to the movement
of bodies. In particular it was made to do simple rocket equations.
"""
module Rockets

include("geometry/Geometri.jl")
include("physics/Fysikk.jl")

include("transform.jl")

include("rocket-parts.jl")
include("vehicles.jl")

include("properties.jl")
include("actions.jl")

include("iteration.jl")
include("parts-loading.jl")

include("display.jl")
include("plotting.jl")
include("simulate.jl")


end # module
