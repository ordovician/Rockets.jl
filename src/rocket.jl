export  Rocket,
        mass, force, update!

mutable struct  Rocket <: Payload
    payload::Payload
    booster::Booster
    body::RigidBody
end

########### Rocket ###################################################################
mass( r::Rocket) = mass(r.payload) + mass(r.boosters)
force(r::Rocket) = force(r.booster)

function update!(r::Rocket, t::Number, Δt::Number)
    update!(r.booster)
    body = r.body
    body.mass   = mass(r)
    body.force  = rotate(body.orientation) * Vector2D(0.0, force(r))
    body.force += gravity_force(body.mass)
    
    integrate!(body, Δt)
end