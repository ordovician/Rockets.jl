import Base: iterate

iterate(ship::SpaceVehicle) = iterate(ship.active_stage)
iterate(payload::Payload) = payload, nothing
iterate(r::Rocket) = r, r.payload
iterate(::Union{SpaceVehicle, Rocket}, state) = state == nothing ? nothing : iterate(state)

Base.IteratorSize(::Union{SpaceVehicle, Rocket}) = Base.SizeUnknown()