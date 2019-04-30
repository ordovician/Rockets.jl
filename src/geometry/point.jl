import Base: zero, show

"""
    zero(::Type{Point2D})
    zero(p::Point2D)
Gives origin for a point of a particular type
"""
zero(::Type{Point2D{T}}) where T <: Number = Point2D{T}(zero(T), zero(T))
zero(p::Point2D{T})      where T <: Number = zero(typeof(p))
  
ismin(p::Point2D, q::Point2D) = p.x < q.x || (p.x == q.x && p.y < q.y)
ismax(p::Point2D, q::Point2D) = p.x > q.x || (p.x == q.x && p.y > q.y)
min(u::Point2D, v::Point2D) = ismin(u, v) ? u : v
max(u::Point2D, v::Point2D) = ismax(u, v) ? u : v

-(p::Point2D, q::Point2D) = Vector2D(p.x - q.x, p.y - q.y)
-(p::Point2D, v::Vector2D) = Point2D(p.x - v.x, p.y - v.y)
+(p::Point2D, v::Vector2D) = Point2D(p.x + v.x, p.y + v.y)
+(v::Vector2D, p::Point2D) = p + v

vector2D(p::Point2D) = Vector2D(p.x, p.y)

similar(v::Point2D) = Point2D(v.x, v.y)
copy(v::Point2D) = Point2D(v.x, v.y)

function show(io::IO, p::Point2D)
    print(io, "(", p.x, ", ", p.y ,")")
end