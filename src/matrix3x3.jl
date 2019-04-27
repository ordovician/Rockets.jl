import Base: eltype

export Matrix3x3, zerotransform, eye, rotate, scale, transpose, pos, x, y

mutable struct Matrix3x3{T <: Number}
	# First row
	m11::T
	m12::T
	m13::T
	
	# Second row
	m21::T
	m22::T
	m23::T
	
	# Third row
	m31::T
	m32::T
	m33::T
end

eltype(::Type{Matrix3x3{E}}) where {E <: Number} = @isdefined(E) ? E : Any

function zerotransform(::Type{E}) where {E <: Number}
	z = zero(E)
    Matrix3x3(
	 z,	z, z,   
	 z,	z, z,
	 z,	z, z)
end

function eye(::Type{E}) where {E <: Number}
	a = zerotransform(E)
	a.m11 = one(E)
	a.m22 = one(E)
	a.m33 = one(E)
	
	return a
end


function Matrix3x3(pos::Point, ang::Number)
	a = eye(Float64)
	a.m13 = pos.x
	a.m23 = pos.y
	
	cosine = cos(ang)
	sine   = sin(ang)
	
	a.m11 = cosine
	a.m12 = -sine
	a.m21 = sine
	a.m22 = cosine
	
	return a
end

function translate(v::Vector2D)
	a = eye(eltype(v))
	a.m13 = v.x
	a.m23 = v.y
	
	return a
end

function scale(x::T, y::T) where {T <: Number}
	a = zerotransform(T)
	a.m11 = x
	a.m22 = y
	a.m33 = zero(T)
	
	return m
end

function rotate(ang::Number)
	a = eye(Float64)
	sine = sin(ang)
	cosine = cos(ang)
	
	a.m11 = cosine
	a.m12 = -sine
	a.m21 = sine
	a.m22 = cosine
    
    a
end

pos(a::Matrix3x3) = Point(a.m13, a.m23)
dir(a::Matrix3x3) = Vector2D(a.m11, a.m21)
x(a::Matrix3x3) = a.m13
y(a::Matrix3x3) = a.m23
  
function +(a::Matrix3x3, b::Matrix3x3)
	Matrix3x3(
		a.m11 + b.m11,
		a.m12 + b.m12,
		a.m13 + b.m13,
		
		a.m21 + b.m21,
		a.m22 + b.m22,
		a.m23 + b.m23,
		
		a.m31 + b.m31,
		a.m32 + b.m32,
		a.m33 + b.m33
	)
end

function -(a::Matrix3x3, b::Matrix3x3)
	Matrix3x3(
		a.m11 - b.m11,
		a.m12 - b.m12,
		a.m13 - b.m13,

		a.m21 - b.m21,
		a.m22 - b.m22,
		a.m23 - b.m23,

		a.m31 - b.m31,
		a.m32 - b.m32,
		a.m33 - b.m33)
end

function *(a::Number, b::Matrix3x3)
	Matrix3x3(
		a * b.m11,
		a * b.m12,
		a * b.m13,

		a * b.m21,
		a * b.m22,
		a * b.m23,

		a * b.m31,
		a * b.m32,
		a * b.m33)
end

*(a::Matrix3x3, b::Number) = b * a

function *(a::Matrix3x3, v::Point)
	Point(v.x*a.m11 + v.y*a.m12 + a.m13,
		  v.x*a.m21 + v.y*a.m22 + a.m23)
end

*(v::Point, a::Matrix3x3) = a * v

function *(a::Matrix3x3, v::Vector2D)
	Vector2D(v.x*a.m11 + v.y*a.m12, 
			 v.x*a.m21 + v.y*a.m22)
end

*(v::Vector2D, a::Matrix3x3) = a * v


function transpose(a::Matrix3x3)
	Matrix3x3(
		a.m11,
		a.m21,
		a.m31,
		
		a.m12,
		a.m22,
		a.m32,
		
		a.m13,
		a.m23,
		a.m33)
end