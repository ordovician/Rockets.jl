export integrate, explicit_euler, semi_implicit_euler

# Numerical integraion of equation for motion
# this is the approach we usually use in computer games and physics simulations
# where an accurate equation for the movement of physics bodies cannot be derived.
#
# A great source of information about this can be found at: 
#   https://gafferongames.com/post/integration_basics/


# Integration methods

"""
     explicit_euler(body, Δt)
Perform one integration step using the explict euler method. This will update
the position and velocity of the `body` by advancing the time with `Δt`
"""
function explicit_euler(body::AbstractBody{T}, Δt::Number) where T <: Number
    body.position += body.velocity * Δt
    body.velocity += body.acceleration * Δt
end

"""
     semi_implicit_euler(body, Δt)
Perform one integration step using the semi implicit euler method. This will update
the position and velocity of the `body` by advancing the time with `Δt`
"""
function semi_implicit_euler(body::AbstractBody{T}, Δt::Number) where T <: Number
    body.velocity += body.acceleration * Δt
    body.position += body.velocity * Δt
end

# Set the default function for integrating position and volocity of a physics body
global integrate = explicit_euler

# Runge-Kutta method: https://en.wikipedia.org/wiki/Runge–Kutta_methods
# dy(t)/dt = f(t, y),  y(t0) = y0    # Calculates derivative of y at t.
# dr(t)/dt = f(t, r),  r(t0) = r0
# y is the unknown function we are approximating.
# So in our example r(t), the distance traveled at time t. r0 is distance
#   traveled at time t0 = 0 (or initial time).
# yn+1 = yn + (1/6)(k1 + 2k2 + 2k3 + k4), tn+1 = tn + h
# Means:     y(t + Δt) = y(t) +  (1/6)(k1 + 2k2 + 2k3 + k4)
# Equals to: r(t + Δt) = r(t) +  (1/6)(k1 + 2k2 + 2k3 + k4)
# k1 = Δt * f(t, r)
# k2 = Δt * f(t + Δt/2, r + k1/2)
# k3 = Δt * f(t + Δt/2, r + k2/2)
# k4 = Δt * f(t + Δt,   r + k3)
# I think f(t, r) calculates the derivative of r in t.
# So f could get acceleration at time t, and use it to get the change/derivative
#   of velocity or position (r).