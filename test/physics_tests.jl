@testset "Physics tests" begin
    @testset "integrators improve accuracy with smaller Δt" for integrator! in [explicit_euler!, semi_implicit_euler!]
		mass = 1.0
		force = 4.0
		acceleration = force/mass
		d0 = 0.0
		v0 = 0.0
		d = distance(d0, v0, acceleration)
		t = 200
		expected_distance = d(t)
		Δerror = Float64[]		# difference between calculated value and expected
		for Δt in [0.01, 0.1, 0.5, 1.0]
			b = RigidBody(mass, force)
			for t in 0:Δt:t
				integrator!(b, Δt)
			end	
			push!(Δerror, b.position.x - expected_distance)
		end
		# As we make time increments larger, the error should increase
		@test Δerror == sort(Δerror)
    end
	
	@testset "rocket equations for Falcon 9 first stage" begin
		# Using data from Falcon 9 to test rocket equations
		# Data from: http://spaceflight101.com/spacerockets/falcon-9-v1-1-f9r/
		#  covers Falcon 9 v1.1
		# dry mass of Falcon 9 1st stage.
		dry_mass   = 23.1e3   # In kg.
		total_mass = 418.8e3
		propellant_mass = total_mass - dry_mass
		
		# Merlin 1D rocket engine specs
		thrust = 845e3  # Newton at sea level.
		Isp    = 282    # specific impulse in seconds at sea level
		
		calc_mflow = mass_flow(thrust, Isp)
		calc_thrust = rocket_thrust(Isp, calc_mflow)
		@test calc_thrust == thrust
		
		vₑ = exhaust_velocity(Isp)
		Δv = delta_velocity(vₑ, total_mass, dry_mass)
		
		# First delta without payload and second stage is quite high.
		# delta-v to orbit on earth is around 9.4e3
		@test 7.8e3 < Δv < 9e3
		
		tank    = PropellantTank(dry_mass, total_mass, propellant_mass)
		engine  = RocketEngine("Merlin 1D", 0.0, thrust, 0.7, Isp)
		booster = SingleBooster(tank, engine, 1, 1, 1.0)
		stage   = Stage(Sattelite(0.0), booster)
		gravity = false  # Our Δv calculations above using the rocket equation 
						 # does not take gravity into account
		rocket  = Rocket(stage, gravity)
		Δerror = Float64[]           # Approximations to Δv for different values of Δt, when 
									 # using integration 
		for Δt in [0.01, 0.1, 0.5, 1.0]
			push!(Δerror, delta_velocity(rocket, Δt).y - Δv) 
		end
		# As we make time increments larger, the error should increase
		@test Δerror == sort(Δerror)
		
		# Check that the error relative to assumed correct value Δv is less
		# than 1% (0.01). This is a bit arbitrary chosen value. 
		@test all((Δerror ./ Δv) .< 0.01)
	end
	
	@testset "total delta-v for Falcon 9" begin
		# First stage - 22t dry mass, 411t fuel mass, 282s SL Isp, 311s Vac Isp (averaged to 296.5s Isp for first stage)
		# Second stage - 4t dry mass, 107.5t fuel mass, 348s Isp
		# Payload - either 22.8t or 8.3t	
		
		dry_mass1 = 22e3		   # dry mass first stage
		propellant_mass1 = 411e3   # propellant mass first stage
		
		dry_mass2 = 4e3				# dry mass second stage
		propellant_mass2 = 107.5e3	# propellant mass second stage
		
		payload_mass = 22.8e3		# payload to LEO for F9
				   		
  		total_mass2 = dry_mass2 + propellant_mass2 + payload_mass
		total_mass1 = dry_mass1 + propellant_mass1 + total_mass2	
		
		# Merlin 1D rocket engine specs
		thrust  = 845e3  # Newton at sea level.
		Isp_SL1  = 282    # specific impulse in seconds at sea level
		Isp_Vac1 = 311
		Isp_Vac2 = 348	 # specific impulse in vacuum for second stage
		vₑ = exhaust_velocity((Isp_SL1 + Isp_Vac1)/2)
		Δv₁ = delta_velocity(vₑ, total_mass1, total_mass1 - propellant_mass1)
		
		vₑ = exhaust_velocity(Isp_Vac2)
		Δv₂ = delta_velocity(vₑ, total_mass2, total_mass2 - propellant_mass2)
		Δv = Δv₁ + Δv₂
		
		# The range is a bit arbitrary. It is based on number seen online
		# by other doing the calculations and SpaceX offical numbers.
		#  remember this is a simplified calculation. 
		#  we are not taking into account gravity turn etc.
		@test 9e3 < Δv < 12e3
		
		tank1    = PropellantTank(dry_mass1, total_mass1 - total_mass2, propellant_mass1)
		engine1  = RocketEngine("Merlin 1D", 0.0, thrust, 0.7, (Isp_SL1 + Isp_Vac1)/2)
		booster1 = SingleBooster(tank1, engine1, 1, 1, 1.0)

		tank2	 = PropellantTank(dry_mass2, total_mass2  - payload_mass, propellant_mass2)
		engine2  = RocketEngine("MVac", 0.0, thrust, 0.7, Isp_Vac2)
		booster2 = SingleBooster(tank2, engine2, 1, 1, 1.0)
		stage2   = Stage(Sattelite(payload_mass), booster2)
		stage1   = Stage(stage2, booster1)		

		gravity  = false  # Our Δv calculations above using the rocket equation 
						 # does not take gravity into account
		rocket  = Rocket(stage1, gravity)
		Δerror  = Float64[]   # Approximations to Δv for different values of Δt, when 
							  # using integration 
		for Δt in [0.01, 0.1, 0.5, 1.0]
			push!(Δerror, delta_velocity(rocket, Δt).y - Δv) 
		end
		# As we make time increments larger, the error should increase
		@test Δerror == sort(Δerror)
	end
	
end