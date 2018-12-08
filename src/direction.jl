norm(v::Direction{T})    where T <: Number = one(T)
sqrnorm(v::Direction{T}) where T <: Number = one(T)
unit(v::Direction) = v  

# To project a point along an axis
dot(p::Point, v::Direction) = dot(vector2D(p), v)
dot(v::Direction, p::Point) = dot(p, v)

similar(v::Direction) = Direction(v.x, v.y)
copy(v::Direction) = Direction(v.x, v.y)
