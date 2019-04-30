import Base: length, abs, +, -, *, /, ==, !=, 
			 size, ndims, eltype, similar, min, max

export 	Point2D, ismin, ismax,
		Vector2D, dot, cross, ⋅, ×,
		sqrnorm, 
		unit, 
		normal, 
		angle
        

struct Point2D{T <: Number}
	x::Number
	y::Number
end

Point2D(x::T, y::T) where T <: Number = Point2D{T}(x, y)

struct Vector2D{T <: Number}
	x::Number
	y::Number
end

Vector2D(x::T, y::T) where T <: Number = Vector2D{T}(x, y)

struct Direction2D{T <: Number}
	x::Number
	y::Number
end

Direction2D(x::T, y::T) where T <: Number = Direction2D{T}(x, y)


VecOrDir      = Union{Vector2D, Direction2D}
PointVecOrDir = Union{Vector2D, Direction2D, Point2D}
PointOrVec    = Union{Vector2D, Point2D}

include("point.jl")
include("vector2d.jl")
include("direction.jl")
include("segment.jl")
include("matrix3x3.jl")
include("rectangle.jl")
include("circle.jl")
