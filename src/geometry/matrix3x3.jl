import Base: size, IndexStyle, setindex!, getindex, transpose

export  Matrix2D, zerotransform, eye, rotate, scale, transpose, 
        location, direction, xloc, yloc

mutable struct Matrix2D{T <: Number} <: AbstractArray{T, 2}
    m::Matrix{T}
end

size(M::Matrix2D) = size(M.m)
IndexStyle(::Type{<:Matrix2D}) = IndexLinear()

setindex!(M::Matrix2D, v::Number, I::Vararg{Int,2}) = M.m[I...] = v
getindex(M::Matrix2D, i::Int) = M.m[i]

zerotransform(::Type{E}) where {E <: Number} = Matrix2D(zeros(E, 3, 3))

function eye(::Type{E}) where {E <: Number}
	a = zerotransform(E)
	a.m[1, 1] = one(E)
	a.m[2, 2] = one(E)
	a.m[3, 3] = one(E)
	
	return a
end


function Matrix2D(pos::Point2D, ang::Number)
	a = eye(Float64)
	a.m[1, 3] = pos.x
	a.m[2, 3] = pos.y
	
	cosine = cos(ang)
	sine   = sin(ang)
	
	a.m[1, 1] = cosine
	a.m[1, 2] = -sine
	a.m[2, 1] = sine
	a.m[2, 2] = cosine
	
	return a
end

function translate(v::Vector2D)
	a = eye(eltype(v))
	a.m[1, 3] = v.x
	a.m[2, 3] = v.y
	
	return a
end

function scale(x::T, y::T) where {T <: Number}
	a = zerotransform(T)
	a.m[1, 1] = x
	a.m[2, 2] = y
	a.m[3, 3] = zero(T)
	
	return m
end

function rotate(ang::Number)
	a = eye(Float64)
	sine = sin(ang)
	cosine = cos(ang)
	
	a.m[1, 1] = cosine
	a.m[1, 2] = -sine
	a.m[2, 1] = sine
	a.m[2, 2] = cosine
    
    a
end

location(a::Matrix2D) = Point2D(a.m[1, 3], a.m[2, 3])
direction(a::Matrix2D) = Vector2D(a.m[1, 1], a.m[2, 1])
xloc(a::Matrix2D) = a.m[1, 3]
yloc(a::Matrix2D) = a.m[2, 3]
  

function *(a::Matrix2D, b::Matrix2D)
    T = promote_type(eltype(a), eltype(b))
    c = Matrix2D(Matrix{T}(undef, 3, 3))
    for i in 1:3, j in 1:3
        sum = zero(T)
        for k in 1:3
            sum += a[i, k] * b[k, j]
        end
        c[i, j] = sum
    end
    c
end

function *(a::Matrix2D, v::Point2D)
	Point2D(v.x*a.m[1, 1] + v.y*a.m[1, 2] + a.m[1, 3],
		  v.x*a.m[2, 1] + v.y*a.m[2, 2] + a.m[2, 3])
end

*(v::Point2D, a::Matrix2D) = a * v

function *(a::Matrix2D, v::Vector2D)
	Vector2D(v.x*a.m[1, 1] + v.y*a.m[1, 2], 
			 v.x*a.m[2, 1] + v.y*a.m[2, 2])
end

*(v::Vector2D, a::Matrix2D) = a * v


function transpose(a::Matrix2D)
    data = Matrix{eltype(a)}(undef, 3, 3)
	t = Matrix2D(data)
    
    for i in 1:3, j in 1:3
       t.m[i, j] = a.m[j, i] 
    end
    t
end