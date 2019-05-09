import Base: show

const tab = "   "

function show(io::IO, engine::Engine, depth::Integer = 0)
    println(io, tab^depth, "engine:")
    depth += 1
    println(io, tab^depth, "name   = ", name(engine))
    println(io, tab^depth, "thrust = ", thrust(engine))    
    println(io, tab^depth, "Isp    = ", Isp(engine))      
end

function show(io::IO, tank::Tank, depth::Integer = 0)
    println(io, tab^depth, "tank:")
    depth += 1
    println(io, tab^depth, "dry   = ", tank.dry_mass)
    println(io, tab^depth, "total = ", tank.total_mass)    
end

function print_stage(io::IO, rocket::Rocket, depth::Number)
    println(io, tab^depth, "throttle   = ", rocket.throttle)
    println(io, tab^depth, "propellant = ", rocket.propellant)
    
    println(io)
    show(io, rocket.tank, depth)
    println(io)  

    show(io, rocket.engine, depth)
    println(io)  
end

function print_stage(io::IO, payload::Payload, depth::Number)
    println(io, tab^depth, payload)
    println(io)    
end

function show(io::IO, payload::Payload, depth::Number)
    print(io, tab^depth, payload)
end

function show(io::IO, ship::SpaceVehicle)
    println(io, "position = ", position(ship))
    println(io, "velocity = ", velocity(ship))
    println(io)
    for (i, part) in enumerate(reverse(collect(ship)))
        println(io, "stage ", i, ": ")
        print_stage(io, part, 1)
    end
end

function show(io::IO, r::Rocket, depth::Integer = 0)
    println(io, tab^depth, "Rocket:")
    
    depth += 1
    println(io, tab^depth, "throttle   = ", r.throttle)
    println(io, tab^depth, "propellant = ", r.propellant)    
    println(io)
    
    show(io, r.tank, depth)
    println(io)
    show(io, r.engine, depth)
    println(io)
    
    println(io, tab^depth , "Payload:")
    show(io, r.payload, depth + 1)
end