export  RocketFactory, FalconFactory, ElectronFactory,
        sl_engine, vac_engine,
        booster_tank, second_stage_tank,
        booster, second_stage,
        assemble_rocket

"Produces rocket parts for a particular type of rocket"
abstract type RocketFactory end


"""
    sl_engine(factory::RocketFactory) -> Engine
Produce a sea level rocket engine. 
Concrete factories must implement this method.
"""
function sl_engine end

"""
    vac_engine(factory::RocketFactory) -> Engine
Produce a vacuum level rocket engine.
Concrete factories must implement this method.
"""
function vac_engine end

"""
    booster_tank(factory::RocketFactory) -> Tank
Create a propellant tank for the booster stage.
Concrete factories must implement this method.
"""
function booster_tank end

"""
    second_stage_tank(factory::RocketFactory) -> Tank
Create a propellant tank for the second stage.
Concrete factories must implement this method.
"""
function second_stage_tank end


"""
    booster(factory::RocketFactory) -> Rocket
Have the rocket `factory` produce a booster stage.
Concrete factories must implement this method.
"""
function booster end

"""
    second_stage(factory::RocketFactory) -> Rocket
Have the rocket `factory` produce a second stage.
This is optional for concrete factories to implement
"""
function second_stage(factory::RocketFactory)
    tank    = second_stage_tank(factory)
    engine  = vac_engine(factory)
    Rocket(nopayload, tank, engine)
end

function assemble_rocket(factory::RocketFactory)
    SpaceVehicle([booster(factory), second_stage(factory)])
end

####################################################

"""
Factory for making Falcon 9 and Falcon Heavy style rockets
"""
struct FalconFactory <: RocketFactory end


function sl_engine(::FalconFactory)
    Engine("Merlin 1D", 845e3, 282, mass = 470)
end

function vac_engine(::FalconFactory)
    Engine("Kestrel 2", 31e3, 311, mass = 52)
end

function booster_tank(::FalconFactory)
    Tank(23.1e3, 418.8e3)
end

function second_stage_tank(::FalconFactory)
    Tank(3.9e3, 96.57e3)
end

function booster(factory::FalconFactory)
    tank    = booster_tank(factory)
    engine  = sl_engine(factory)
    cluster = EngineCluster(engine, 9)
    Rocket(nopayload, tank, cluster)
end

####################################################
# https://www.spacelaunchreport.com/electron.html

"""
Factory for the Electron rocket.
"""
struct ElectronFactory <: RocketFactory end


function sl_engine(::ElectronFactory)
    Engine("Rutherford", 25e3, 311, mass = 35)
end

function vac_engine(::ElectronFactory)
    Engine("Rutherford", 26e3, 343, mass = 35)    
end

function booster_tank(::ElectronFactory)
    Tank(0.95e3, 10.2e3)
end

function second_stage_tank(::ElectronFactory)
    Tank(0.25e3, 2.3e3)
end

function booster(factory::ElectronFactory)
    tank    = booster_tank(factory)
    engine  = sl_engine(factory)
    cluster = EngineCluster(engine, 9)
    Rocket(nopayload, tank, cluster)
end

