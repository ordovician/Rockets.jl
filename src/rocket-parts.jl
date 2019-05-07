export  Engine, Tank, 
        Booster, SingleBooster, MultiBooster

"""
Keeps track of information needed to calculate the thrust a rocket performs, as well as how much
it weighs. The weight of the rocket engines is an imporant part of the total weight of the rocket.
"""
struct Engine
    name::String			# An identifier such as Merlin 1D, RD-180
    mass::Float64			# Mass of rocket engine in Kg
    max_thrust::Float64		# Max amount of thrust engine can produce, measured in Newton.
    min_throttle::Float64	# Minimum amount engine can be throttled down, before it has to be shut down entirely
    Isp::Float64    		# Specific Impulse. A measure of propellant efficiency of engine.
end

mutable struct Tank
   dry_mass::Float64			# Mass of tank without propellant
   total_mass::Float64			# Mass of tank with propellant
   propellant_mass::Float64 	# Between 0 and total_mass - dry_mass	
end

"""
A booster is the bottom stage of a rocket, containing fuel tanks and rocket engines.
A booster push a payload up from the ground.
"""
abstract type Booster end


mutable struct  SingleBooster <: Booster
    tank::Tank
    engine::Engine
    no_engines::Int64				# Number of engines on this booster. E.g. 9 engines on Falcon 9 first stage
    no_active_engines::Int64		# Engines turned on. E.g. when Falcon 9 lands, only one engine is active.
    throttle::Float64				# Either 0 or in range (min_throttle, 1)
end

"Creates a booster where all engines are on at full throttle"
function SingleBooster(tank::Tank, engine::Engine, no_engines::Integer)
	SingleBooster(tank, engine, no_engines, no_engines, 1.0)
end

"""
Side boosters, such as the solid propellant first stage boosters on the Space Shuttle. Use this
when  you got boosters which are treated as one unit. E.g. the side boosters will fire at the same time, and
get stage separated at the same time.
"""
mutable struct  MultiBooster <: Booster
    boosters::Array{SingleBooster}
end

########### Constructors #############################################################################
Engine(name, mass, max_thrust, Isp) = Engine(name, mass, max_thrust, 0.0, Isp) 
