import CSV
import DataFrames: eachrow, ismissing
import Base: getindex

export load_engines, load_tanks

const mass_multiplier = 1000 # reading masses in tons but want to store them in Kg. However thrust in kN
						  # so it should even out
const thrust_multiplier = mass_multiplier

"""
    load_rocket_engines()
Loads rocket engine definition stored in CSV file, and creates and array of
rocket engine objects, which can be used to assemble a rocket for the simulator.
"""
function load_engines()
	path = joinpath(@__DIR__, "..", "data/rocket-engines.csv")
    engines_table = CSV.read(path)
    rocket_engines = Engine[]
    for row in eachrow(engines_table)
        throttle = row[:throttle]
        if ismissing(throttle)
            throttle = 1.0
        end
        
        thrust = row[:thrust_SL] * thrust_multiplier
        if ismissing(thrust)
            thrust = row[:thrust_Vac] * thrust_multiplier
        end
        
        Isp = row[:Isp_SL]
        if ismissing(Isp)
            Isp = row[:Isp_Vac]
        end
        
        mass = row[:mass] * mass_multiplier
        if ismissing(mass)
            continue
        end
        
        engine = Engine(row[:name], thrust, Isp, mass = mass, throttle = throttle)
        push!(rocket_engines, engine)
    end
    rocket_engines
end

"""
	getindex(engines::Array{Engine}, key)
Gives a dictionary style interface to an array of rocket engines, so we can conveniently lookup an engine
based on a name.

## Example
	engines = load_rocket_engines()
	kestrel = engines["Kestrel 2"]
"""
function getindex(engines::Array{Engine}, key::AbstractString)
   i = findfirst(e -> e.name == key, engines)
   if i == nothing
       throw(KeyError(key))
   end
   engines[i]
end

function load_tanks()
	path = joinpath(@__DIR__, "..", "data/propellant-tanks.csv")
    tanks_table = CSV.read(path)
    tanks = Dict{String, Tank}()
    for row in eachrow(tanks_table)
        if any(ismissing, row) continue end
        name = row[:name]
        total_mass = row[:total_mass] * mass_multiplier # Given in tons in the file
        dry_mass   = row[:dry_mass]   * mass_multiplier
        tanks[name] = Tank(dry_mass, total_mass)
    end
    tanks
end
