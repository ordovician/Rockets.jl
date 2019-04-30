import CSV
import DataFrames: eachrow, ismissing
import Base: getindex

export load_rocket_engines, load_propellant_tanks

const mass_multiplier = 1 # reading masses in tons but want to store them in Kg. However thrust in kN
						  # so it should even out

"""
    load_rocket_engines()
Loads rocket engine definition stored in CSV file, and creates and array of
rocket engine objects, which can be used to assemble a rocket for the simulator.
"""
function load_rocket_engines()
    engines_table = CSV.read("data/rocket-engines.csv")
    rocket_engines = RocketEngine[]
    for row in eachrow(engines_table)
        throttle = row[:throttle]
        if ismissing(throttle)
            throttle = 1.0
        end
        
        thrust = row[:thrust_SL]
        if ismissing(thrust)
            thrust = row[:thrust_Vac]
        end
        
        Isp = row[:Isp_SL]
        if ismissing(Isp)
            Isp = row[:Isp_Vac]
        end
        
        mass = row[:mass] * mass_multiplier
        if ismissing(mass)
            continue
        end
        
        engine = RocketEngine(row[:name], mass, thrust, throttle, Isp)
        push!(rocket_engines, engine)
    end
    rocket_engines
end

"""
	getindex(engines::Array{RocketEngine}, key)
Gives a dictionary style interface to an array of rocket engines, so we can conveniently lookup an engine
based on a name.

## Example
	engines = load_rocket_engines()
	kestrel = engines["Kestrel 2"]
"""
function getindex(engines::Array{RocketEngine}, key::AbstractString)
   i = findfirst(e -> e.name == key, engines)
   if i == nothing
       throw(KeyError(key))
   end
   engines[i]
end

function load_propellant_tanks()
    tanks_table = CSV.read("data/propellant-tanks.csv")
    tanks = Dict{String, PropellantTank}()
    for row in eachrow(tanks_table)
        if any(ismissing, row) continue end
        name = row[:name]
        total_mass = row[:total_mass] * mass_multiplier # Given in tons in the file
        dry_mass   = row[:dry_mass]   * mass_multiplier
        tanks[name] = PropellantTank(dry_mass, total_mass, 0.0)
    end
    tanks
end
