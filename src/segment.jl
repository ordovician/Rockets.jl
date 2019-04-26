export Segment, isbelow, ison, isonend, tovector, intersection, isintersecting, intersection2

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

"""
    intersection(s1, s2)
Find intersection point of segment `s1` and `s2`. If no such point is found,
return `nothing`.

Line segments are defined at endpoints 
so linesegments e.g. sharing endpoints are said to intersect, unless they are parallell.
Parallell line segments are defined as not intersecting even if they overlap.

Since we are using floatingpoint numbers the calculations are not 100% accurate. Thus
there is a chance the algorithm will report parallel segments as intersecting
"""
function intersection(s1::Segment, s2::Segment)
	d = tovector(s1)
	v = tovector(s2)
	
  	num = s1.source - s2.source
 	denom  = cross(d, v)

 	# Check if line segments are parallel
 	if denom == 0.0
		return nothing
    end
	t = cross(v, num)/denom
	s = cross(d, num)/denom

	if t > 1.0 || t < 0.0 || s > 1.0 || s < 0.0
        return nothing
    end
    s1.source + t * d
end

# Replace intersection with this, once we know which one make most correct computation
function intersection2(s1::Segment, s2::Segment)
    # Lets us define s1, as a segment (p, p + r) where p is a point and r is a vector
    # s2 is defined as a segment (q, q + s) where q is a point and s a vector
    p = s1.source
    r = tovector(s1)
    q = s2.source
    s = tovector(s2)
    
    # Then any point on s1 is representable as p + tr, where 0 <= t <= 1
    # Any point on s2 is representable as q + us, where 0 <= u <= 1
    # Then two lines intersect if we can find a t and u such that
    #   p + tr = q + us
    #   (p + tr) × s = (q + us) × s
    #   p × s + t(r × s) = q×s + u(s×s)
    #   t(r × s) = q×s - p×s + u*0
    #   t = (q - p) × s / (r × s)
    
    # Doing the same for u:
    #   (p + t r) × r = (q + u s) × r
    #   u (s × r) = (p − q) × r
    #   u = (p − q) × r / (s × r)
    # 
    # Rewrite s × r = − r × s) to get:
    #   u = (q − p) × r / (r × s)
    
    # Then we'll simplify this avoid extra computations
    
    denom = r × s
    num   = q - p
     
    # check if lines are parallel 
 	if iszero(denom)
		return nothing
    end
    
    t = num × s / denom
    u = num × s / denom
    
    # remember the intersection point is at
    # p + tr or q + us. But both scalars have to be in range (0, 1)
	if 0 <= t <= 1 && 0 <= u <= 1
        return p + t*r
    end
    
    nothing
end

isintersecting(s1::Segment, s2::Segment) = intersection(s1, s2) != nothing
