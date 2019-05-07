export visitpart

function dovisitpart(f::Function, kind::DataType, part)
    if typeof(part) <: kind
        f(part)
    end
end

"""
    visitpart(f, kind, part)
Used for traversing all the parts of the rocket. `kind` is the type of the part you want to visit.
Calls function `f(part)` if part is of type kind or a subtype.
"""
visitpart(f::Function, kind::DataType, part) = dovisitpart(f, kind, part)

function visitpart(f::Function, kind::DataType, r::SpaceVehicle)
	dovisitpart(f, kind, r)
    visitpart(f, kind, r.active_stage)	
end

function visitpart(f::Function, kind::DataType, s::Stage)
	dovisitpart(f, kind, s)
    visitpart(f, kind, s.booster)	
	visitpart(f, kind, s.payload)
end

function visitpart(f::Function, kind::DataType, b::MultiBooster)
    dovisitpart(f, kind, b)
    
    for booster in b.boosters
        visitpart(f, kind, booster)
    end
end

function visitpart(f::Function, kind::DataType, b::SingleBooster)
    dovisitpart(f, kind, b)
    visitpart(f, kind, b.tank)
    visitpart(f, kind, b.engine)
end


"""
    fulltank!(r::SpaceVehicle)
Fill up all tanks of rocket to full
"""
function fulltank!(r::SpaceVehicle)
    # traverse rocket structure as a graph of parts, only visiting
    # parts which are Propellant Tanks. for all of these, fill them up.
    visitpart(PropellantTank, r) do tank
        fulltank!(tank)
    end
end
