# How to Simulate a Rocket Launch

Once you  have your space vehicle assembled as described in [Assemble a Rocket from Parts](@ref) you are ready to launch it.

When simulating a launch you need to be aware of several properties and operations which can be performed on a space vehicle.

## Advance Simulation a Time Step

A launch is simulated by approximation. We advance  small timestep Δt  at a time. Every time we advance the time step we calculate propellant consumed, current remaining mass of rocket, its current acceleration, accumulated velocity and position. 

Callintg the `update!(ship)` method will do that. 

```@docs
update!
```

## Stage Separation

As you are advacing the simulation by calling `update!()` you need to keep track of whether the propellant in the first stage has been spent or not. If it has, it is time to peform a stage sepration, done with `stage_separate!()`. This will jetson off the bottom stage, thus getting rid of mass weighing down the space vehicle. 

Depending on your setup you may have a parallel staged space vehicle, meaning there are side boosters. In that case you will check the propellant of the side boosters and call `detach_sideboosters!()` if they are empty to get rid of them.
```@docs
stage_separate!
detach_sideboosters!
```

## Example of Simulating Launch

Putting all this together we can simulate a launch by keeping track of propellant used make time steps and jetson of stages when needed.

```@setup falcon9
using Rockets   # hide
kestrel  = Engine("Kestrel 2", 31e3, 311, mass = 52)
stage2_tank  = Tank(3.9e3, 96.57e3)
stage2 = Rocket(Satellite(22.8e3), stage2_tank, kestrel)

merlin = Engine("Merlin 1D", 845e3, 282, mass = 470)
stage1_tank = Tank(23.1e3, 418.8e3)
stage1 = Rocket(stage2, stage1_tank, EngineCluster(merlin, 9))

ship = SpaceVehicle(stage1)
```

```@example falcon9
t   = 0
Δt = 0.1
while ship.active_stage isa Rocket	
	while propellant(ship) > 0 && t <=  2000
		boosters = sideboosters(ship)
		if !isempty(boosters) && sum(propellant.(boosters)) <= 0
			detach_sideboosters!(ship)
		end
		update!(ship, t, Δt)
		# t += Δt
	end
	stage_separate!(ship)
end
```