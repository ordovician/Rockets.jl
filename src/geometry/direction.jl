import Base: copy

norm(v::Direction2D{T})    where T <: Number = one(T)
sqrnorm(v::Direction2D{T}) where T <: Number = one(T)
unit(v::Direction2D) = v  

# To project a point along an axis
dot(p::Point2D, v::Direction2D) = dot(vector2D(p), v)
dot(v::Direction2D, p::Point2D) = dot(p, v)

similar(v::Direction2D) = Direction2D(v.x, v.y)
copy(v::Direction2D) = Direction2D(v.x, v.y)
