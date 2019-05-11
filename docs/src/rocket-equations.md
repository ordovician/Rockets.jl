# Rocket Equations
There are the physics equations we use to calculate how much thrust a rocket engine generates, how much fuel it consumes, and how much it changes its velocity.

## Launch Calculations

The flight of rockets in the Rockets.jl package is calculated using integration. By that we mean discretizing the world, turning it into tiny time stepds of some lenght `Δt = 0.1` second. Within each of these time steps we calculate how much mass the rocket lose in that time period from ejecting propellant. We do that by calculating the mass flow with [`mass_flow`](@ref). The mass flow gives us the ability to calculate rocket thrust given that we know its specific impulse (Isp). 

With thrust at and remaining mass of rocket we can calculate the acceleration of the rocket. With acceleration we get the change in velocity for the   time period.

The total change in velocity from launching a rocket and flying it until it has spent all its fuel is called delta-v `Δt`. We can validate the result we get by using Tsiolkovsky's famous rocket equation [`delta_velocity`](@ref).

```@docs
mass_flow
exhaust_velocity
rocket_thrust
delta_velocity
```

## Orbit Calculations

When doing calculations in orbit the [`burn_length`](@ref) and [`propellant_consumption`](@ref) are useful calculations. They help orbital maneuvers.

```@docs
burn_length
propellant_consumption
```
