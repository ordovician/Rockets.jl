export Circle, isinside, isintersecting, transform, boundingbox

struct Circle{T <: Number}
	center::Point{T}
	radius::T
end

isinside(c::Circle, p::Point) = norm(p - c.center) < c.radius
isintersecting(c::Circle, k::Circle) = norm(k.center - c.center) < c.radius + k.radius

function isintersecting(c::Circle, r::Rect)
	r2 = c.radius^2
	
	# translate coordinate system placing circle at center
	rmax = r.max - c.center
	rmin = r.min - c.center
	
	if rmax.x < 0.0
		if rmax.y < 0.0
			sqrnorm(rmax) < r2
		elseif rmin.y > 0.0
			rmax.x^2 + rmin.y^2 < r2
		else
			abs(rmax.x) < c.radius
		end
	# Right of circle center?
	elseif rmin.x > 0.0
		if rmax.y < 0.0 			# Lower right corner
			rmin.x^2 + rmax.y^2 < r2
		elseif rmin.y > 0.0         # Upper right corner
		  sqrnorm(rmin) < r2
		else                      # Is right of circle
		  rmin.x < c.radius
  	end
	# rangle on circle vertical centerline
	else
		if rmax.y < 0.0
			abs(rmax.y) < c.radius
		elseif rmin.y > 0.0
			rmin.y < c.radius
		else
			true
		end
	end
	false
end

isintersecting(r::Rect, c::Circle) = isintersecting(c, r)
transform(c::Circle, m::Matrix3x3) = Circle(m * c.center, c.radius)

function boundingbox(c::Circle)
    Rect(c.center - Vector2D(c.radius, c.radius), c.center + Vector2D(c.radius, c.radius))
end