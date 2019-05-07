import Base: iterate

iterate(r::Rocket) = r, r.payload
iterate(payload::Payload) = nothing