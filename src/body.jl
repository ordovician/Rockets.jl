import Base: getproperty
export RigidBody, force, mass, acceleration,
       apply_earth_gravity

"""
Represents a physics body with a position, velocity and mass onto which a force
acts to change its acceleration.
"""
mutable struct RigidBody{T <: Number}
    position::Point{T}    # Postion, with x,y coordinates in meters
    velocity::Vector2D{T} # Current velocity in m/s
    force::Vector2D{T}    # Accumulated force acting upon body in Newton
    orientation::T        # In radians
    mass::T               # Kg
end

force(body::RigidBody) = body.force
mass(body::RigidBody)  = body.mass
acceleration(body::RigidBody) = force(body) / mass(body)

"Add the effects of gravity to the accumulated force working on the body"
gravity_force(mass::Number) = Vector2D(0, -9.8 * mass)