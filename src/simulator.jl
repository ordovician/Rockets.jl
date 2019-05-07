export build_rocket, simstep!, runsimulator

# using Plots
# plotly()
# GR()


"Use to find items in array"
equal(x) = y -> y == x

function build_rocket(engines::Array{Engine}, tanks::Dict{String,PropellantTank})
	tank1 = copy(tanks["F9 1st stage"])
	tank2 = copy(tanks["F9 2nd stage"])

	merlin  = engines["Merlin 1D"]
	kestrel = engines["Kestrel 2"]

	payload = Sattelite(22.8)

	stage2 = Stage(payload, SingleBooster(tank2, kestrel, 1))
	stage1 = Stage(stage2, SingleBooster(tank1, merlin, 9))

	falcon9 = Rocket(stage1)
end

function simstep!(rocket, t, Δt)
	update!(rocket, t, Δt)
	p = position(rocket)
	(p.x, p.y, propellant_mass(rocket.active_stage))
end

function runsimulator(t1 = 0, Δt = 1, t2 = 10)
	engines = load_rocket_engines()
	tanks   = load_propellant_tanks()

	rocket = build_rocket(engines, tanks) :: Rocket
	fulltank!(rocket)
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
