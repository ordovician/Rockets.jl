# Make it easier to mix degrees (0 - 360) with radians (0 - 2π) without accidentally using the wrong "unit"
# Thus is a function expects a degrees from 0 to 360, it will specify Degree as type, while if it takes
# radians it will just take a number

import Base: *, +, -, /, convert

export Degree, °

struct Degree{T <: Number}
    value::T
end

convert(::Type{Degree{T}}, radians::T) where {T <: Number} = Degree(rad2deg(radians))
convert(::Type{T}, degrees::Degree{T}) where {T <: Number} = deg2rad(degrees.value)

*(x::Number, y::Degree{T}) where {T <: Number} = Degree(x * y.value)
/(x::Degree{T}, y::Number) where {T <: Number} = Degree(x.value / y)
/(x::Degree{T}, y::Degree{S}) where {T <: Number, S <: Number} = x.value / y.value

-(x::Degree, y::Degree) = Degree(x.value - y.value)
+(x::Degree, y::Degree) = Degree(x.value + y.value)

# Combined with * operator this allows you to write 20° instead of Degree(20). 
# It translates into 20 * Degree(1)
 
const ° = Degree(1)