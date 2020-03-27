export RocketException, AssemblyError

"""
Exceptions related to constructing a rocket.
"""
abstract type RocketException <: Exception end


"""
An error occured in assembling rocket parts. They could not be added in
desired way.
"""
struct AssemblyError <: RocketException
   target::Rocket
   msg::AbstractString 
   addons::Array{Rocket}
end

AssemblyError(target::Rocket, msg::AbstractString) = AssemblyError(target, msg, Rocket[])