import Base: length, abs, +, -, *, /, ==, !=, 
			 size, ndims, eltype, similar, min, max

export 	Point2D, ismin, ismax,
		Vector2D, dot, cross, ⋅, ×,
		sqrnorm, 
		unit, 
		normal, 
		angle
        

struct Point2D{T <: Number}
	x::T
	y::T
end

struct Vector2D{T <: Number}
	x::T
	y::T
end

struct Direction2D{T <: Number}
	x::T
	y::T
end

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
