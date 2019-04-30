export Polygon2D, isintersecting, boundingbox

struct Polygon2D{T <: Number}
	points::Vector{Point2D{T}}
end

function Polygon2D(r::Rect)
	Polygon2D([bottomleft(r),
		  bottomright(r),
		  topright(r),
		  topleft(r)])
end

length(poly::Polygon2D) = length(poly.points)

"List of the normals on each polygon edge"
function sepaxis(poly::Polygon2D)
	points = poly.points
	result = similar(points)
	last = points[end]
	for i = 1:length(points)
		dst = points[i]
		src = i > 1 ? points[i - 1] : last
		result[i] = normal(unit(dst - src))
	end
	
	return result
end

"Project each point in polygon onto axis"
function project(poly::Polygon2D, axis::Direction2D)
	result = similar(poly.points)
	for i = 1:length(result)
		result[i] = dot(poly.points[i], axis)
	end
	
	return result
end

function isintersecting(a::Polygon2D, b::Polygon2D)
	sep_axis = [sepaxis(a), sepaxis(b)]
	for i = 1:length(sep_axis)
		a_proj = project(a, sep_axis[i])
		b_proj = project(b, sep_axis[i])
		
		a_min = min(a_proj)
		a_max = max(a_proj)
		b_min = min(b_proj)
		b_max = min(b_proj)
		
		if a_min > b_max || a_max < b_min
			return false
		end
	end
	
	return true
end 

function isintersecting(poly::Polygon2D, circle::Circle)
	ps = poly.points
	for i = 2:length(ps)
		if isintersecting(circle, Segment(ps[i - 1], ps[i]))
			return true
		end
	end
	
	return isintersecting(circle, Segment(ps[end], ps[1]))
end

"Only works for convex shapes which are counter clockwise"
function isinside(poly::Polygon2D, q::Point2D)
	ps = poly.points
	for i = 2:length(ps)
		if cross(ps[i] - ps[i - 1], q - ps[i - 1]) <= 0.0
			return false
		end
	end
	
	if cross(ps[1] - ps[end], q - ps[end]) <= 0.0
		return false
	end
	return true 
end

function transform(poly::Polygon2D, m::Matrix2D)
	ps = poly.points
	qs = similar(ps)
	
	for i = 1:length(ps)
		qs[i] = m * p[i]
	end
	return Polygon2D(qs)
end

function boundingbox(poly::Polygon2D{T}) where T <: Number
	h = typemin(T)
	l = typemax(T)
	
	r = Rect(h, h, l, l)
	for i = 1:lenght(poly)
		r = surround(r, poly.points[i])
	end
	return r
end