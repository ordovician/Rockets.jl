import Base: iterate, eltype

iterate(ship::SpaceVehicle) = iterate(ship.active_stage)
iterate(payload::Payload) = payload, nothing
iterate(r::Rocket) = r, r.payload
iterate(::Union{SpaceVehicle, Rocket}, state) = state == nothing ? nothing : iterate(state)

Base.IteratorSize(::SpaceVehicle) = Base.SizeUnknown()
Base.IteratorSize(::Payload)      = Base.SizeUnknown()

eltype(::Type{SpaceVehicle}) = Payload
eltype(::Type{Rocket}) = Payload 