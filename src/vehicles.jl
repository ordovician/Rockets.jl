export  SpaceVehicle, 
        Payload, NoPayload, Rocket, Capsule, SpaceProbe, Sattelite

"""
Anything a stage pushes into the air/space with its booster. Could be e.g. a sattelite or another rocket stage
"""
abstract type Payload end

"Rocket with no payload, such as a detached booster."
struct NoPayload <: Payload
end

"""
A single stage rocket, with a payload which could potentially be another rocket 
thus making it multi-stage.
"""
mutable struct Rocket <: Payload
    payload::Payload
    tank::Tank
    engine::Engine
    throttle::Float64		# Either 0 or in range (min_throttle, 1)
    propellant::Float64     # Amount of propellant mass left
    sideboosters::Array{Rocket} # Side booster can fire engines along with core stage
end

function Rocket(payload::Payload, tank::Tank, engine::Engine, throttle = 1.0)
    Rocket(payload, tank, engine, throttle, max_propellant(tank), Rocket[])
end

"""
Heat shield below and typically no rocket engines or fuel tanks
"""
mutable struct Capsule <: Payload
	mass::Float64
end

struct SpaceProbe <: Payload
    mass::Float64
end

mutable struct Sattelite <: Payload
	mass::Float64
end

####################### SpaceVehicle #####################################

"Represents a rocket in flight, with all its stages and payload."
mutable struct SpaceVehicle
	active_stage::Payload
    body::RigidBody
	gravity::Bool		# Is rocket affected by gravity
end

function SpaceVehicle(r::Rocket, gravity::Bool = true)
	body = RigidBody(mass(r), 0.0)
	SpaceVehicle(r, body, gravity)
end