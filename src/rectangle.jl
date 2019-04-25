export  Rect, isinside, isintersecting, transform, boundingbox,
        center, size, halfsize, topleft, bottomright, topright, surround

struct Rect{T}
	min::Point{T}
	max::Point{T}
end

Rect(minx::Number, miny::Number, maxx::Number, maxy::Number) = Rect(Point(minx, miny), Point(maxx, maxy))

center(r::Rect) = Point((r.max.x + r.min.x) * 0.5, (r.max.y + r.min.y) * 0.5)
size(r::Rect) = abs(r.max - r.min)
halfsize(r::Rect) = 0.5 * size(r)

function isinside(r::Rect, p::Point)
	ismin(r.min, p) && ismax(r.max, p) ||
		pos == r.min || pos == r.max 
end

function isintersecting(r::Rect, s::Rect)
	d = abs(center(s) - center(r))
	h1 = halfsize(r)
	h2 = halfsize(s)
	
	d.x <= h1.x + h2.x &&
	d.y <= h1.y + h2.y
end

topleft(r::Rect)     = Vector2D(r.min.x, r.max.y)
bottomright(r::Rect) = Vector2D(r.max.x, r.min.y)
topright(r::Rect)    = r.max
bottomleft(r::Rect)  = r.min

transform(r::Rect, m::Matrix3x3) = Rect(m * r.min, m * r.max)

surround(r::Rect, p::Point) = Rect(mincomp(r.min, p), maxcomp(r.max, p))
surround(r::Rect, s::Rect) = Rect(mincomp(r.min, s.min), maxcomp(r.max, s.max))
boundingbox(r::Rect) = r