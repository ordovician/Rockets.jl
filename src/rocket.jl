import 	Base: position, copy

export  SpaceVehicle, Rocket,
        mass, force, update!, stage_separate!,
        fulltank!, delta_velocity, simulate_launch,
		propellant_mass


"Represents a rocket in flight, with all its stages and payload."
mutable struct SpaceVehicle
	active_stage::Payload
    body::RigidBody
	gravity::Bool		# Is rocket affected by gravity
end


"""
A stage in a rocket. Is part of the static description of a rocket. Has no concepts of
where it is in space, velocity and acceleration. Rockets exist mainly to be able to keep track
of the force generated by the boosters in the rocket, as well as keeping track of mass of the
rocket as fuel is getting consumed.
"""
mutable struct Rocket <: Payload
    payload::Payload
    booster::Booster
end

########### Rocket ###################################################################
mass( s::Rocket) = mass(s.payload) + mass(s.booster)
force(s::Rocket) = force(s.booster)

update!(s::Rocket, t::Number, Δt::Number) = update!(s.booster, t, Δt)
propellant_mass(s::Rocket) = propellant_mass(s.booster)

"""
	stage_separate!(r::SpaceVehicle)
Decouple bottom stage from rocket. This will typically lower the mass of the rocket.
If stage separation succeeded function will return `true`.
"""
function stage_separate!(r::SpaceVehicle)
	if r.active_stage isa Rocket
		r.active_stage = r.active_stage.payload
		true
	else
		false
	end
end

copy(s::Rocket) = Rocket(copy(s.payload), copy(s.booster))

########### SpaceVehicle ###################################################################
function SpaceVehicle(stage::Rocket, gravity::Bool = true)
	body = RigidBody(mass(stage), 0.0)
	SpaceVehicle(stage, body, gravity)
end

copy(r::SpaceVehicle) = SpaceVehicle(copy(r.active_stage), copy(r.body), r.gravity)

position(r::SpaceVehicle) = r.body.position
velocity(r::SpaceVehicle) = r.body.velocity

mass( r::SpaceVehicle) = mass(r.active_stage)
force(r::SpaceVehicle) = force(r.active_stage)
 
"""
	update!(r::SpaceVehicle, t::Number, Δt::Number)
Perform a time step. At time `t` advance the time with `Δt` and update the mass, force, acceleration,
velocity and position of rocket.
"""
function update!(r::SpaceVehicle, t::Number, Δt::Number)
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

propellant_mass(r::SpaceVehicle) = propellant_mass(r.active_stage)

"""
	simulate_launch(rocket, Δt)
Returns a rocket object giving all state after all fuel is spent.
"""
function simulate_launch(rocket::SpaceVehicle, Δt::Number)
	t = 0
    r = copy(rocket)
	while r.active_stage isa Rocket
		while propellant_mass(r) > 0
			update!(r, t, Δt)
			t += Δt
		end
		stage_separate!(r)
	end
    r    
end

"""
	delta_velocity(rocket, Δt)
Calculate Δv of rocket using integration as opposed to using Tsiolkovsky rocket equation.
It copies the `rocket` object, so it never gets mutated.
"""
function delta_velocity(rocket::SpaceVehicle, Δt::Number)
    r = simulate_launch(rocket, Δt)
	velocity(r)
end
