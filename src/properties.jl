export position, velocity, force, thrust, mass, propellant_mass

position(r::SpaceVehicle) = r.body.position
velocity(r::SpaceVehicle) = r.body.velocity

###################### thrust #############################################
force(r::SpaceVehicle) = force(r.active_stage)
force(payload::Payload) = 0.0
force(s::Rocket) = force(s.booster)
force(b::Booster) = thrust(b)


function thrust(b::SingleBooster)
    @assert b.no_active_engines <= b.no_engines "Can't have more active engines than there are engines"
    @assert b.throttle >= b.engine.min_throttle "Can't throttle engine below minimum required throttle"
    b.engine.max_thrust * b.throttle * b.no_active_engines
end

thrust(b::MultiBooster) = sum(force.(b.boosters))


###################### thrust #############################################
mass(r::SpaceVehicle)      = mass(r.active_stage)
mass(payload::Payload)     = error("mass not defined for ", typeof(payload))
mass(sattelite::Sattelite) = sattelite.mass
mass(capsule::Capsule)     = capsule.mass
mass(s::Rocket)            = mass(s.payload) + mass(s.booster)
mass(engine::Engine)       = engine.mass

function mass(tank::Tank)
    @assert tank.total_mass >= tank.dry_mass + tank.propellant_mass "Combined mass of propellant and dry mass, cannot exceed specified total mass for tank"
    tank.dry_mass + tank.propellant_mass
end

mass(b::SingleBooster) = mass(b.tank) + mass(b.engine)*b.no_engines
mass(b::MultiBooster)  = sum(mass.(b.boosters))

propellant_mass(b) = 0.0
propellant_mass(r::SpaceVehicle) = propellant_mass(r.active_stage)
propellant_mass(s::Rocket) = propellant_mass(s.booster)
propellant_mass(b::SingleBooster) = b.tank.propellant_mass
propellant_mass(multi::MultiBooster) = sum([propellant_mass(b.tank) in multi.booster])

