import Base: getproperty, show

export RigidBody, force, mass, acceleration,
       apply_earth_gravity

"""
Represents a physics body with a position, velocity and mass onto which a force
acts to change its acceleration.
"""
mutable struct RigidBody{T <: AbstractFloat}
    position::Point{T}    # Postion, with x,y coordinates in meters
    velocity::Vector2D{T} # Current velocity in m/s
    force::Vector2D{T}    # Accumulated force acting upon body in Newton
    orientation::T        # In radians
    mass::T               # Kg
end

function RigidBody(mass::AbstractFloat, force::AbstractFloat)
    mass, force = promote(mass, force)
    z = zero(mass)
    zerovec = Vector2D(z, z)
    RigidBody(Point(z, z), Vector2D(z, z), Vector2D(force, z), z, mass)
end

force(body::RigidBody) = body.force
mass(body::RigidBody)  = body.mass
acceleration(body::RigidBody) = force(body) / mass(body)

"Add the effects of gravity to the accumulated force working on the body"
function gravity_force(mass::AbstractFloat)
    Vector2D(zero(mass), typeof(mass)(-g₀) * mass)
end

function show(io::IO, b::RigidBody)
    print(io, "RigidBody(pos = $(b.position), vel = $(b.velocity), force = $(b.force), orient = $(b.orientation), mass = $(b.mass))")
end