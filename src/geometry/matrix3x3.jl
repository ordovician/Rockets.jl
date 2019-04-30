import Base: size, IndexStyle, setindex!, getindex, transpose

export  Matrix3x3, zerotransform, eye, rotate, scale, transpose, 
        location, direction, xloc, yloc

mutable struct Matrix3x3{T <: Number} <: AbstractArray{T, 2}
    m::Matrix{T}
end

size(M::Matrix3x3) = size(M.m)
IndexStyle(::Type{<:Matrix3x3}) = IndexLinear()

setindex!(M::Matrix3x3, v::Number, I::Vararg{Int,2}) = M.m[I...] = v
getindex(M::Matrix3x3, i::Int) = M.m[i]

zerotransform(::Type{E}) where {E <: Number} = Matrix3x3(zeros(E, 3, 3))

function eye(::Type{E}) where {E <: Number}
	a = zerotransform(E)
	a.m[1, 1] = one(E)
	a.m[2, 2] = one(E)
	a.m[3, 3] = one(E)
	
	return a
end


function Matrix3x3(pos::Point, ang::Number)
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

location(a::Matrix3x3) = Point(a.m[1, 3], a.m[2, 3])
direction(a::Matrix3x3) = Vector2D(a.m[1, 1], a.m[2, 1])
xloc(a::Matrix3x3) = a.m[1, 3]
yloc(a::Matrix3x3) = a.m[2, 3]
  

function *(a::Matrix3x3, b::Matrix3x3)
    T = promote_type(eltype(a), eltype(b))
    c = Matrix3x3(Matrix{T}(undef, 3, 3))
    for i in 1:3, j in 1:3
        sum = zero(T)
        for k in 1:3
            sum += a[i, k] * b[k, j]
        end
        c[i, j] = sum
    end
    c
end

function *(a::Matrix3x3, v::Point)
	Point(v.x*a.m[1, 1] + v.y*a.m[1, 2] + a.m[1, 3],
		  v.x*a.m[2, 1] + v.y*a.m[2, 2] + a.m[2, 3])
end

*(v::Point, a::Matrix3x3) = a * v

function *(a::Matrix3x3, v::Vector2D)
	Vector2D(v.x*a.m[1, 1] + v.y*a.m[1, 2], 
			 v.x*a.m[2, 1] + v.y*a.m[2, 2])
end

*(v::Vector2D, a::Matrix3x3) = a * v


function transpose(a::Matrix3x3)
    data = Matrix{eltype(a)}(undef, 3, 3)
	t = Matrix3x3(data)
    
    for i in 1:3, j in 1:3
       t.m[i, j] = a.m[j, i] 
    end
    t
end