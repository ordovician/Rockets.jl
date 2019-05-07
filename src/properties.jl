export position, velocity, force, thrust, Isp, mass, propellant, max_propellant

position(r::SpaceVehicle) = r.body.position
velocity(r::SpaceVehicle) = r.body.velocity

###################### thrust #############################################
thrust(r::SpaceVehicle) = thrust(r.active_stage)
thrust(payload::Payload) = 0.0

function thrust(r::Rocket)
    @assert (r.engine.min_throttle <= r.throttle <= 1.0) || r.throttle == 0
    thrust(r.engine) * clamp(r.throttle, r.engine.min_throttle, 1.0)
end

thrust(engine::SingleEngine)   = engine.thrust
thrust(cluster::EngineCluster) = thrust(cluster.engine) * cluster.count

Isp(engine::SingleEngine)   = engine.Isp
Isp(cluster::EngineCluster) = Isp(cluster.engine)

###################### thrust #############################################
mass(ship::SpaceVehicle)     = mass(ship.active_stage)
mass(payload::Payload)       = error("mass not defined for ", typeof(payload))
mass(sattelite::Sattelite)   = sattelite.mass
mass(capsule::Capsule)       = capsule.mass
mass(r::Rocket)              = mass(r.payload) + mass(r.tank) + r.propellant + mass(r.engine)
mass(engine::SingleEngine)   = engine.mass
mass(cluster::EngineCluster) = mass(cluster.engine) * cluster.count
mass(tank::Tank) = tank.dry_mass

propellant(non_rocket) = 0.0
propellant(r::SpaceVehicle)    = propellant(r.active_stage)
propellant(r::Rocket)          = r.propellant

max_propellant(t::Tank)        = t.total_mass - t.dry_mass
