import Base: getproperty
export AbstractBody, Body, force, mass, acceleration

abstract type AbstractBody{T <: Number} end

"""
Represents a physics body with a position, velocity and mass onto which a force
acts to change its acceleration.
"""
mutable struct Body{T <: Number} <: AbstractBody{T}
    position::Point{T}
    velocity::Vector2D{T}
    force::Vector2D{T}
    mass::T
end

force(body::Body) = body.force
mass(body::Body)  = body.mass
acceleration(body::AbstractBody) = force(body) / mass(body)