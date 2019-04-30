export velocity, acceleration, distance

# Laws of Motion
# v = at + v0
# r = r0 + v0*t + 0.5a*t^2
# r = r0 + 0.5(v + v0)t
# v^2 = v0^2 + 2a(r - r0)
# r = r0 + v*t - 0.5a*t^2
#
# When doing this with vectors we need some changes
# dot(v, v) = dot(v0, v0) + dot(2*a, r - r0))
#  

dot(x::Number, y::Number) = x * y

"""
    velocity(r0, v0, a)

An implementation of the following equation:
    v = at + v0
It is made so it returns a function of time:
    v = velocity(r0, v0, a)  # Returns a function r(t)
    dist = v(t)
"""
velocity(v0::T, a::T) where T <: Union{Number, Vector2D} = t::Number -> a*t + v0


"""
    distance(r0, v0, a)

An implementation of the following equation:
    r = r0 + v0*t + 0.5a*t^2
It is made so it returns a function of time:
    r = distance(r0, v0, a)  # Returns a function r(t)
    dist = r(t)
"""
function distance(r0::T, v0::T, a::T) where T <: Union{Number, Vector2D}
    t::Number -> r0 + v0*t + 0.5*a*t^2
end

"""
    square_velocity(r0, r, v0, a)

This calculates the following equation:
    v^2 = v0^2 + 2a(r - r0)
"""
function square_velocity(r0::T, r::T, v0::T, a::T) where T <: Union{Number, Vector2D}
    dot(v0, v0) + dot(2*a, r - r0)
end
