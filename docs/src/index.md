# Rockets.jl Documentation

Rockets is a simple package for simulating rocket launches. It is primarily meant as an educational tool, both in how rockets work, but also in terms of how you design Julia software. To reach that goal whenever realism requires a lot of complexity which would get in the way of either understanding rocket software or the design of Julia software we will skip the realism. The goal is to keep things as simple as possible while still being acceptably realistic.

## Building a Rocket
Before you can actually launch a virtual rocket you need to assemble it from parts. The following section discusses what parts make up a rocket and how you can combine them using Julia code.

```@contents
Pages = ["assemble-rocket.md"]
Depth = 2
```

## Launch the Rocket!
Once you got a rocket assembled, you have different ways of simulating a launch of the rocket. The sections below cover the different ways of simulating a launch as well as what kind of data gets collected.

```@contents
Pages = ["simulate-launches.md"]
Depth = 2
```

## Rocket Equations
The simulation of the rocket launches are built upon a set of standard rocket equations. Here is a discussion of what they are and how they are used.

```@contents
Pages = ["rocket-equations.md"]
Depth = 2
```