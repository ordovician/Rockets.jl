using CSV
using DataFrames

export load_rocket_engines

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
        
        mass = row[:mass]
        if ismissing(mass)
            continue
        end
        
        engine = RocketEngine(row[:name], mass, thrust, throttle, Isp)
        push!(rocket_engines, engine)
    end
    rocket_engines
end

function load_propellant_tanks()
    tanks_table = CSV.read("data/propellant-tanks.csv")
    tanks = Dict{String, PropellantTank}()
    for row in eachrow(tanks_table)
        if any(ismissing, row) continue end
        name = row[:name]
        total_mass = row[:total_mass]
        dry_mass   = row[:dry_mass]
        tanks[name] = PropellantTank(dry_mass, total_mass, 0.0)
    end
    tanks
end
    
end