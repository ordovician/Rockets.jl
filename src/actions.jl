import Base: copy
export stage_separate!, update!, fulltank! 

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
copy(s::Rocket) = Rocket(copy(s.payload), copy(s.booster))

function copy(b::SingleBooster)
    # don't need to copy engine as it cannot be mutated.
    SingleBooster(copy(b.tank), b.engine, b.no_engines, b.no_active_engines, b.throttle)
end

function copy(tank::Tank)
	Tank(tank.dry_mass, tank.total_mass, tank.propellant_mass)
end



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
    body.force  = rotate(body.orientation) * Vector2D(0.0, force(r))
	if r.gravity
	    body.force += gravity_force(body.mass)
	end
	integrate!(body, Δt)
end

update!(s::Rocket, t::Number, Δt::Number) = update!(s.booster, t, Δt)

function update!(b::SingleBooster, t::Number, Δt::Number)
    mflow = mass_flow(thrust(b), b.engine.Isp)
    b.tank.propellant_mass -= min(mflow * Δt, b.tank.propellant_mass)
end

"""
    update!(r::MultiBooster, t, Δt)
    
Called each step in the simulation of a multiple booster worker as first stage of a rocket. 
Each step we advance the present time `t` with Δt. 
This means typically adjusting the mass of propellant which is left, which will alter the total
mass of the rocket, which will affect its acceleration.
"""
function update!(b::MultiBooster, t::Number, Δt::Number)
    for booster in b.boosters
        update!(booster, t, Δt)
    end
end

###################### Propellant Tank #############################################


"""
     merge!(tank, addon)

Merge two propellant tanks into one. This is useful if we are building a rocket with multiple separat tanks.
For the purpose of simulation, it does not matter much whether the tanks are treated as separate or as one.
"""
function merge!(tank::Tank, addon::Tank)
   tank.dry_mass += addon.dry_mass
   tank.total_mass += addon.total_mass
   tank.propellant_mass += propellant_mass
   @assert tank.total_mass >= tank.dry_mass + tank.propellant_mass "The new merged than has a mismatch between expected total mass and the dry mass and propellant mass"
   tank
end



"""
	fulltank!(tank::Tank)
Refills the tank to full.
"""
function fulltank!(tank::Tank)
	tank.propellant_mass = tank.total_mass - tank.dry_mass
end

