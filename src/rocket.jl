import 	Base: position

export  Rocket, Stage,
        mass, force, update!, stage_separate!,
        fulltank!

mutable struct Rocket
	active_stage::Payload
    body::RigidBody
end

"""
	stage_separate!(r::Rocket)
Decouple bottom stage from rocket. This will typically lower the mass of the rocket
"""
function stage_separate!(r::Rocket)
	r.active_stage = r.active_stage.payload
end

mutable struct  Stage <: Payload
    payload::Payload
    booster::Booster
end

########### Stage ###################################################################
mass( s::Stage) = mass(s.payload) + mass(s.booster)
force(s::Stage) = force(s.booster)

update!(s::Stage, t::Number, Δt::Number) = update!(s.booster, t, Δt)
propellant_mass(s::Stage) = propellant_mass(s.booster)

########### Rocket ###################################################################
function Rocket(stage::Stage)
	body = RigidBody(mass(stage), 0.0)
	Rocket(stage, body)
end

position(r::Rocket) = r.body.position

mass( r::Rocket) = mass(r.active_stage)
force(r::Rocket) = force(r.active_stage)
 
"""
	update!(r::Rocket, t::Number, Δt::Number)
Perform a time step. At time `t` advance the time with `Δt` and update the mass, force, acceleration,
velocity and position of rocket.
"""
function update!(r::Rocket, t::Number, Δt::Number)
    stage = r.active_stage
    body  = r.body
	
	update!(stage, t, Δt)

    body.mass   = mass(r)
    body.force  = rotate(body.orientation) * Vector2D(0.0, force(r))
    body.force += gravity_force(body.mass)
    
    integrate!(body, Δt)
end


