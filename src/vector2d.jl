import Base: angle, eltype, isapprox

length(v::PointVecOrDir) = 2
norm(v::Vector2D) = sqrt(v.x^2 + v.y^2)
sqrnorm(v::Vector2D) = v.x^2 + v.y^2

==(u::PointVecOrDir, v::PointVecOrDir) = u.x == v.x && u.y == v.y
!=(u::PointVecOrDir, v::PointVecOrDir) = u.x != v.x || u.y != v.y

size(v::PointVecOrDir) = (2,)
ndims(v::PointVecOrDir) = 1

for T in [:Point, :Vector2D, :Direction]
    @eval eltype(::Type{$T{E}}) where {E <: Number} = @isdefined(E) ? E : Any
end


function unit(v::Vector2D)  
	len = norm(v);
	Direction(v.x/len, v.y/len)
end

isapprox(u::PointVecOrDir, v::PointVecOrDir) = isapprox(u.x, v.x) && isapprox(u.y, v.y)
dot(u::VecOrDir, v::VecOrDir) = u.x*v.x + u.y*v.y
cross(u::VecOrDir, v::VecOrDir) = u.x*v.y - u.y*v.x
abs(v::VecOrDir) = Vector2D(abs(v.x), abs(v.y))
angle(v::VecOrDir) = atan2(v.y, v.x)
  
const ⋅ = dot
const × = cross

+(u::Vector2D, v::Vector2D) = Vector2D(u.x + v.x, u.y + v.y)
-(u::Vector2D, v::Vector2D) = Vector2D(u.x - v.x, u.y - v.y)
*(factor::Number, v::VecOrDir) = Vector2D(v.x * factor, v.y * factor)
*(v::VecOrDir, factor::Number) = Vector2D(v.x * factor, v.y * factor)
/(v::VecOrDir, factor::Number) = Vector2D(v.x / factor, v.y / factor)

mincomp(u::T, v::T) where {T <: PointVecOrDir} = T(min(u.x, v.x), min(u.y, v.y))
maxcomp(u::T, v::T)  where {T <: PointVecOrDir} = T(max(u.x, v.x), max(u.y, v.y))

point(v::Vector2D) = Point(v.x, v.y)

similar(v::Vector2D) = Vector2D(v.x, v.y)
copy(v::Vector2D) = Vector2D(v.x, v.y)
