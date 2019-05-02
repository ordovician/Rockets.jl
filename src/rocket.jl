import 	Base: position, copy

export  Rocket, Stage,
        mass, force, update!, stage_separate!,
        fulltank!, delta_velocity,
		propellant_mass


"Represents a rocket in flight, with all its stages and payload."
mutable struct Rocket
	active_stage::Payload
    body::RigidBody
	gravity::Bool		# Is rocket affected by gravity
end


"""
A stage in a rocket. Is part of the static description of a rocket. Has no concepts of
where it is in space, velocity and acceleration. Stages exist mainly to be able to keep track
of the force generated by the boosters in the rocket, as well as keeping track of mass of the
rocket as fuel is getting consumed.
"""
mutable struct  Stage <: Payload
    payload::Payload
    booster::Booster
end

########### Stage ###################################################################
mass( s::Stage) = mass(s.payload) + mass(s.booster)
force(s::Stage) = force(s.booster)

update!(s::Stage, t::Number, Δt::Number) = update!(s.booster, t, Δt)
propellant_mass(s::Stage) = propellant_mass(s.booster)

"""
	stage_separate!(r::Rocket)
Decouple bottom stage from rocket. This will typically lower the mass of the rocket.
If stage separation succeeded function will return `true`.
"""
function stage_separate!(r::Rocket)
	if r.active_stage isa Stage
		r.active_stage = r.active_stage.payload
		true
	else
		false
	end
end

copy(s::Stage) = Stage(copy(s.payload), copy(s.booster))

########### Rocket ###################################################################
function Rocket(stage::Stage, gravity::Bool = true)
	body = RigidBody(mass(stage), 0.0)
	Rocket(stage, body, gravity)
end

copy(r::Rocket) = Rocket(copy(r.active_stage), copy(r.body), r.gravity)

position(r::Rocket) = r.body.position
velocity(r::Rocket) = r.body.velocity

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
	if r.gravity
	    body.force += gravity_force(body.mass)
	end
    integrate!(body, Δt)
end

propellant_mass(r::Rocket) = propellant_mass(r.active_stage)

"""
	delta_velocity(rocket, Δt)
Calculate Δv of rocket using integration as opposed to using Tsiolkovsky rocket equation.
It copies the `rocket` object, so it never gets mutated.
"""
function delta_velocity(rocket::Rocket, Δt::Number)
	t = 0
    r = copy(rocket)
	while r.active_stage isa Stage
		while propellant_mass(r) > 0
			update!(r, t, Δt)
			t += Δt
		end
		stage_separate!(r)
	end
	velocity(r)
end
