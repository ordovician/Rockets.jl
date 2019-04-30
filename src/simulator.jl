export build_rocket, simstep!, runsimulator

"Use to find items in array"
equal(x) = y -> y == x

function build_rocket(engines::Array{RocketEngine}, tanks::Dict{String,PropellantTank})
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
	(p.x, p.y, mass(rocket))
end

function runsimulator(Δt = 1)
	engines = load_rocket_engines()
	tanks   = load_propellant_tanks()
	
	rocket = build_rocket(engines, tanks) :: Rocket
	fulltank!(rocket)
	plot(0:Δt:10) do t
		simstep!(rocket, t, Δt)
	end
end