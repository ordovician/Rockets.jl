import Base: zero

"""
    zero(::Type{Point})
    zero(p::Point)
Gives origin for a point of a particular type
"""
zero(::Type{Point{T}}) where T <: Number = Point{T}(zero(T), zero(T))
zero(p::Point{T})      where T <: Number = zero(typeof(p))
  
ismin(p::Point, q::Point) = p.x < q.x || (p.x == q.x && p.y < q.y)
ismax(p::Point, q::Point) = p.x > q.x || (p.x == q.x && p.y > q.y)
min(u::Point, v::Point) = ismin(u, v) ? u : v
max(u::Point, v::Point) = ismax(u, v) ? u : v

-(p::Point, q::Point) = Vector2D(p.x - q.x, p.y - q.y)
+(p::Point, v::Vector2D) = Point(u.x + v.x, u.y + v.y)
+(v::Vector2D, p::Point) = p + v

vector2D(p::Point) = Vector2D(p.x, p.y)

similar(v::Point) = Point(v.x, v.y)
copy(v::Point) = Point(v.x, v.y)
