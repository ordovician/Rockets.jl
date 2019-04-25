export Segment, isbelow, ison, isonend, tovector, isintersecting

struct Segment{T <: Number}
	source::Point{T}
	target::Point{T}
end

min(s::Segment) = min(s.source, s.target)

function pointplacement(s::Segment, p::Point)
	smin = min(s)
	cross(max(s) - smin, p - smin)
end

# true if point p is below line defined by segment
isabove(s::Segment, p::Point) = pointplacement(s, p) < 0

# true if point p is above line defined by segment
isbelow(s::Segment, p::Point) = pointplacement(s, p) > 0
ison(s::Segment, p::Point)    = pointplacement(s, p) == 0
isonend(s::Segment, p::Point) = p == s.source || p == s.target
tovector(s::Segment) = s.target - s.source

function isintersecting(s1::Segment, s2::Segment)
	d = tovector(s1)
	v = tovector(s2)
	
  	num = s1.source - s2.source
 	denom  = cross(d, v)

 	# Check if line segments are parallel
 	if denom == 0.0
		return false
    end
	t = cross(v, num)/denom
	s = cross(d, num)/denom

	return !(t > 1.0 || t < 0.0 || s > 1.0 || s < 0.0)
end
