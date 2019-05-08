export build_spaceship, simstep!, runsimulator, simulate_launch, delta_velocity

# using Plots
# plotly()
# GR()


"Use to find items in array"
equal(x) = y -> y == x

function build_spaceship(engines::Array{Engine}, tanks::Dict{String,Tank})
	tank1 = tanks["F9 1st stage"]
	tank2 = tanks["F9 2nd stage"]

	merlin  = engines["Merlin 1D"]
	kestrel = engines["Kestrel 2"]

	payload = Sattelite(22.8)

	stage2 = Rocket(payload, tank2, kestrel)
	stage1 = Rocket(stage2, tank1, EngineCluster(merlin, 9))

	falcon9 = SpaceVehicle(stage1)
end

function simstep!(rocket, t, Δt)
	update!(rocket, t, Δt)
	p = position(rocket)
	(p.x, p.y, propellant(rocket.active_stage))
end

function runsimulator(t1 = 0, Δt = 1, t2 = 10)
	engines = load_engines()
	tanks   = load_tanks()

	rocket = build_spaceship(engines, tanks) :: SpaceVehicle
    plot(t1:Δt:t2) do t
        simstep!(rocket, t, Δt)
    end
    # T = t1:Δt:t2
    # Y = zeros(length(T), 2)
    # for (i, t) in enumerate(T)
    #     _, y, mass = simstep!(rocket, t, Δt)
    #     Y[i, 1] = y
    #     Y[i, 2] = mass
    # end
    # plot(T, Y)
end

"""
	simulate_launch(rocket, Δt; max_duration = 2000)
Returns a rocket object giving all state after all fuel is spent. You can specify a 
maxium duration `max_duration` of the flight in seconds. This is practical to avoid
the simulated launch never terminating.
"""
function simulate_launch(spaceship::SpaceVehicle, Δt::Number; max_duration::Number = 2000)
	t = 0			# start time
    ship = copy(spaceship)
	while ship.active_stage isa Rocket
		while propellant(ship) > 0 && t <= max_duration
			boosters = sideboosters(ship)
			if !isempty(boosters) && sum(propellant.(boosters)) <= 0
				detach_sideboosters!(ship)
			end
			update!(ship, t, Δt)
			t += Δt
		end
		stage_separate!(ship)
	end
    ship    
end

"""
	delta_velocity(rocket, Δt)
Calculate Δv of rocket using integration as opposed to using Tsiolkovsky rocket equation.
It copies the `rocket` object, so it never gets mutated.
"""
function delta_velocity(rocket::SpaceVehicle, Δt::Number)
    r = simulate_launch(rocket, Δt)
	velocity(r)
end

