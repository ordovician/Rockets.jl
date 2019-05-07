import Base: copy
export stage_separate!, update!, combine, fulltank! 

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

###################### copy #############################################

copy(r::SpaceVehicle) = SpaceVehicle(copy(r.active_stage), copy(r.body), r.gravity)
copy(payload) = payload # assume payload is immutable
copy(r::Rocket) = Rocket(copy(r.payload), r.tank, r.engine, r.throttle)

###################### update! #############################################

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
    body.force  = rotate(body.orientation) * Vector2D(0.0, thrust(r))
	if r.gravity
	    body.force += gravity_force(body.mass)
	end
	integrate!(body, Δt)
end

function update!(r::Rocket, t::Number, Δt::Number)
    mflow = mass_flow(thrust(r), Isp(r.engine))
    r.propellant -= min(mflow * Δt, r.propellant)
end


###################### Propellant Tank #############################################

"""
     combine(tank, addon)

Merge two propellant tanks into one. This is useful if we are building a rocket with multiple separat tanks.
For the purpose of simulation, it does not matter much whether the tanks are treated as separate or as one.
"""
combine(t1::Tank, t2::Tank) = Tank(t1.dry_mass + t2.dry_mass, t1.total_mass + t2.total_mass)


"""
	fulltank!(r::Rocket)
Refills this rocket stage
"""
fulltank!(r::Rocket) = r.propellant = max_propellant(r.tank)
