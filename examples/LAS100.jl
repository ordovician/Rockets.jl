# This is calculations to check the validity of the LAS 100 steam rocket, described in paper below
# http://www.arcaspace.com/docs/ARCA_LAS_White_Paper_May_1_2019_Issue_1.pdf
using Rockets

# Calculate Δv accomplished in gravity for LAS100 booster
function launch_las100()
    Isp = 60
    thrust = 100e3 * g₀
    m₀  = 50e3          # initial mass
    mf  = 5e3           # final mass    
    vₑ  = exhaust_velocity(Isp)
    Δv  = delta_velocity(vₑ, m₀, mf)

    tank    = PropellantTank(mf, m₀, m₀ - mf)
    engine  = Engine("LAS100", 0.0, thrust, 0.7, Isp)
    booster = SingleBooster(tank, engine, 1, 1, 1.0)
    stage   = Stage(Sattelite(0.0), booster)
    gravity = true
    rocket  = Rocket(stage, gravity)

    Δt = 0.1
    simulate_launch(rocket, Δt).body
end

# To compare with Arianne boosters
# Getting Data from https://www.spacelaunchreport.com/ariane5.html
# Isp and thrust numbers are vacuum. Not sure what sealevel is
function launch_ariane()
    Isp = 274.5
    thrust = 509.9e3 * g₀
    m₀  = 278e3                  # initial mass
    propellant_mass = 240e3
    mf  = m₀ - propellant_mass   # final mass
    burn_time = 130 # seconds
    
    vₑ  = exhaust_velocity(Isp)
    Δv  = delta_velocity(vₑ, m₀, mf)

    tank    = PropellantTank(mf, m₀, propellant_mass)
    engine  = Engine("ArianeSRB", 0.0, thrust, 0.7, Isp)
    booster = SingleBooster(tank, engine, 1, 1, 1.0)
    stage   = Stage(Sattelite(0.0), booster)
    gravity = true
    rocket  = Rocket(stage, gravity)

    Δt = 0.1
    simulate_launch(rocket, Δt).body
end