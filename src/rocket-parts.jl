import Base: getproperty

export RocketEngine, PropellantTank, Capsule, Sattelite,
       Booster, SingleBooster, MultiBooster,
       mass, force, update!

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

abstract type Payload end

"""
    A booster is the bottom stage of a rocket, containing fuel tanks and rocket engines.
    A booster push a payload up from the ground.
"""
abstract type Booster end

"""
Heat shield below and typically no rocket engines or fuel tanks
"""
mutable struct Capsule <: Payload

end

mutable struct Sattelite <: Payload

end

mutable struct  SingleBooster <: Booster
    tank::PropellantTank
    engine::RocketEngine
    no_engines::Int64
    no_active_engines::Int64
    throttle::Float64
end

mutable struct  MultiBooster <: Booster
    boosters::Array{SingleBooster}
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


########### SingleBooster ###################################################################
mass(b::SingleBooster) = mass(b.tanks) + mass(b.engine)*b.no_engines

function thrust(b::SingleBooster)
    @assert b.no_active_engines <= b.no_engines "Can't have more active engines than there are engines"
    @assert b.throttle >= b.engine.min_throttle "Can't throttle engine below minimum required throttle"
    b.engine.max_thrust * b.throttle * b.no_active_engines
end

force(b::Booster) = thrust(b)

function update!(b::SingleBooster, t::Number, Δt::Number)
    mflow = mass_flow(thrust(b), b.engine.Isp)
    b.tank.propellant_mass -= min(mflow * Δt, b.tank.propellant_mass)
    if b.tank.propellant_mass == 0
        b.no_active_engines = 0
    end
end


########### MultiBooster ###################################################################
mass( b::MultiBooster) = sum(mass.(b.boosters))
force(b::MultiBooster) = sum(force.(b.boosters))

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
