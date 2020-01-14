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

    tank    = Tank(mf, m₀, m₀ - mf)
    engine  = Engine("LAS100", thrust, Isp)
    stage   = Rocket(Satellite(0.0), tank, engine)
    gravity = true
    rocket  = SpaceVehicle(stage, gravity)

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

    tank    = Tank(mf, m₀)
    engine  = Engine("ArianeSRB", thrust, Isp)
    stage   = Rocket(Satellite(0.0), tank, engine)
    gravity = true
    rocket  = SpaceVehicle(stage, gravity)

    Δt = 0.1
    simulate_launch(rocket, Δt).body
end
