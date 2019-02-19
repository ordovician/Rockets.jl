import Base: getproperty

mutable struct RocketEngine
    name::String
    mass::Float64
    max_thrust::Float64
    min_throttle::Float64
    Isp::Float64    
end

mutable struct PropellantTank
   dry_mass::Float64
   total_mass::Float64
   propellant_mass::Float64 
end

abstract type Payload <: AbstractBody end

"""
A rocket is an abstraction of rockets single stage and multi stage rockets
"""
abstract type Rocket  <: Payload end

"""
Heat shield below and typically no rocket engines or fuel tanks
"""
mutable struct Capsule <: Payload
    body::Body{Float64}
end

mutable struct  SingleStageRocket <: Rocket
    tank::PropellantTank
    engine::RocketEngine
    no_engines::Int64
    no_active_engines::Int64
    throttle::Float64
end

mutable struct  MultiStageRocket <: Rocket
    payload::Payload
    boosters::Array{SingleStageRocket}
end

########### RocketEngine #############################################################################
RocketEngine(name, mass, max_thrust, Isp) = RocketEngine(name, mass, max_thrust, 0.0, Isp) 

mass(engine::RocketEngine) = engine.mass


########### Propellant Tank ##########################################################################
"""
     merge!(tank, addon)

Merge two propellant tanks into one. This is useful if we are building a rocket with multiple separat tanks.
For the purpose of simulation, it does not matter much whether the tanks are treated as separate or as one.
"""
function merge!(tank::PropellantTank, addon::PropellantTank)
   tank.dry_mass += addon.dry_mass
   tank.total_mass += addon.total_mass
   tank.propellant_mass += propellant_mass
   @assert tank.total_mass >= tank.dry_mass + tank.propellant_mass "The new merged than has a mismatch between expected total mass and the dry mass and propellant mass"
   tank
end

function mass(tank::PropellantTank)
    @assert tank.total_mass >= tank.dry_mass + tank.propellant_mass "Combined mass of propellant and dry mass, cannot exceed specified total mass for tank"
    tank.dry_mass + tank.propellant_mass
end

########### Capsule #############################################################################
mass(capsule::Capsule) = mass(capsule.body)


########### SingleStageRocket ###################################################################
mass(r::SingleStageRocket) = mass(r.tanks) + mass(r.engine)*r.no_engines

function thrust(r::SingleStageRocket)
    @assert r.no_active_engines <= r.no_engines "Can't have more active engines than there are engines"
    @assert r.throttle >= engine.min_throttle "Can't throttle engine below minimum required throttle"
    r.engine.max_thrust * r.throttle * r.no_active_engines
end

force(r::SingleStageRocket) = thrust(r)

function update!(r::SingleStageRocket, t::Number, Δt::Number)
    mflow = mass_flow(thrust(r), r.engine.Isp)
    r.tank.propellant_mass -= min(mflow * Δt, r.tank.propellant_mass)
    if r.tank.propellant_mass == 0
        r.no_active_engines = 0
    end
end


########### MultiStageRocket ###################################################################
mass( r::MultiStageRocket) = mass(r.payload) + sum(mass.(r.boosters))
force(r::MultiStageRocket) = sum(force.(r.boosters))

"""
    update!(r::MultiStageRocket, t, Δt)
    
Called each step in the simulation of a multistage rocket. Each step we advance the present time `t`
with Δt. This means typically adjusting the mass of propellant which is left, which will alter the total
mass of the rocket, which will affect its acceleration.
"""
function update!(r::MultiStageRocket, t::Number, Δt::Number)
    for booster in r.boosters
        update!(booster, t, Δt)
    end
end