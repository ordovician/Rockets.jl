export Polygon, isintersecting, boundingbox

struct Polygon{T <: Number}
	points::Vector{Point{T}}
end

function Polygon(r::Rect)
	Polygon([bottomleft(r),
		  bottomright(r),
		  topright(r),
		  topleft(r)])
end

length(poly::Polygon) = length(poly.points)

"List of the normals on each polygon edge"
function sepaxis(poly::Polygon)
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
function project(poly::Polygon, axis::Direction)
	result = similar(poly.points)
	for i = 1:length(result)
		result[i] = dot(poly.points[i], axis)
	end
	
	return result
end

function isintersecting(a::Polygon, b::Polygon)
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

function isintersecting(poly::Polygon, circle::Circle)
	ps = poly.points
	for i = 2:length(ps)
		if isintersecting(circle, Segment(ps[i - 1], ps[i]))
			return true
		end
	end
	
	return isintersecting(circle, Segment(ps[end], ps[1]))
end

"Only works for convex shapes which are counter clockwise"
function isinside(poly::Polygon, q::Point)
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

function transform(poly::Polygon, m::Matrix3x3)
	ps = poly.points
	qs = similar(ps)
	
	for i = 1:length(ps)
		qs[i] = m * p[i]
	end
	return Polygon(qs)
end

function boundingbox(poly::Polygon{T}) where T <: Number
	h = typemin(T)
	l = typemax(T)
	
	r = Rect(h, h, l, l)
	for i = 1:lenght(poly)
		r = surround(r, poly.points[i])
	end
	return r
end