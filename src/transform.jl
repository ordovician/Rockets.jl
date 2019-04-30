import Base: position

export Transform

"""
    Transforms forms hierarchies to describe the position of objects with a relationship with each other.
"""
mutable struct Transform
   world::Matrix2D{Float64}    # Position, orientation and scale in world coordinates
   lokal::Matrix2D{Float64}    # Position, orientation and scale in local coordinates
end

orientation(t::Transform) = unit(dir(t.world))
position(t::Transform) = Point2D(x(t.world), y(t.world))