# Assemble a Rocket from Parts

Before discussing how a rocket is assebled with code it is useful to get the terminology right. In the title I am using a rather vague term "Rocket". In code we use far more specific terminology. Almost anything could be labeled a rocket. All you need is something with a rocket engine attached. 

However rockets that deliver payload into earth orbit are complex machinery, which requires a bit more precise terminology to describe. What we usually call a rocket, is actually assembled from multiple smaller rockets in stages. Together these rockets form a multi-stage rocket.

The most precise terminology for this whole thing is a [space vehicle](https://en.wikipedia.org/wiki/Space_vehicle). It is a multi-stage rocket carrying some payload into orbit from a planetary surface. 

## Propellant Tanks

Hold the fuel and oxidizer used by attached rocket engines. Fuel is typically something like kerosene or hydrogen, while the ozidizer is typically liquid oxygen. Together these are referred to as the propellant. A propellant is a particular combination of fuel and oxygen. Kerolox  propellant means kerosene and liquid oxygen e.g. While hydrolox means hydrogen and liquid oxygen.

In this simulation we don't care much about how big the tanks or how many liters of fuel and oxiders is in them. We only care about the mass of the propellants together. So a tank has two properites `dry mass` and `total mass`. The former is the mass of a tank without any propellant, while the latter is the mass of an empty tank. This creates a tank which weighs 1 kg empty and 10 kg full. 

```@setup parts
using Rockets
```

```@repl parts
t = Tank(1, 10)
```

Stored in the `data` directory of the Rocket package we have `.csv` files containing information about some common rocket tanks and rocket engines. 

```@eval
using Rockets
using CSV
using Latexify
dir, _ = splitdir(pathof(Rockets))
path = joinpath(dir, "..", "data/propellant-tanks.csv")
 tanks_table = CSV.read(path)
mdtable(tanks_table,latex=false)
```

We can load these tanks using `load_tanks()` which will return a dictionary of tank objects.

```@repl parts
tanks = load_tanks()
```
This makes it easy for us to locate a tank by name.


## Rocket Engines

Rocket engines are characterized by how powerful they are given by their thrust, measured in Newtons, and their fuel efficiency, specific impulse (Isp) measured in seconds. 

```@repl parts
engine1  = Engine("Merlin 1D", 845, 282)
```

There is also a a `.csv` storing data about rocket engines which can be looked up.

```@eval
using Rockets
using CSV
using Latexify
dir, _ = splitdir(pathof(Rockets))
path = joinpath(dir, "..", "data/rocket-engines.csv")
 tanks_table = CSV.read(path)
mdtable(tanks_table,latex=false)
```

Just use the  `load_engines()` functions returning a list of rocket engine objects.

```@repl rockets
tanks = load_tanks()
```

Since they are stored in a dictionary we can look up a particular engine type by name.

## Rocket Stages

In Rockets.jl the `Rocket` type refers to a single stage in our space vehicle. It is assbled from tanks and engines.

Let us us assemble the second stage of the rocket, which will hold the payload, a sattelite weighing 22.8 tons, which happens to be the payload capcity of a Falcon 9, when sending payload into low earth orbit (LEO).

```@example falcon9
using Rockets   # hide
kestrel  = Engine("Kestrel 2", 31e3, 311, mass = 52)
stage2_tank  = Tank(3.9e3, 96.57e3)
stage2 = Rocket(Sattelite(22.8e3), stage2_tank, kestrel)

merlin = Engine("Merlin 1D", 845e3, 282, mass = 470)
stage1_tank = Tank(23.1e3, 418.8e3)
stage1 = Rocket(stage2, stage1_tank, EngineCluster(merlin, 9))

ship = SpaceVehicle(stage1)
```

As you can see each stage is made by attacking a stage higher up along with a tank and a rocket engine. The engine can be an `EngineCluster` is the rocket stage use more of the same type of rocket engine. E.g. the bottom stage of a Falcon 9 rocket has 9 Merlin 1D engines attached to it.
