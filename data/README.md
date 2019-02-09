# Data for Rocket Calculations
To be able to do some ballpark calculations to check if the rocket equations work okay, I've provided some CSV files with data about various fuel tanks and rocket engines.

None of this is entirely accurate. I have taken some liberties. The column for engine thrust e.g. mixes thrust in vaccuum and at sea level (1 athmosphere pressure). Engines typically used for the first stage on earth have their values given for sea level. While smaller engines used for second stage have thrust and specific impulse given for vacuum.

The Falcon 9 and Falcon 1 fuel tank numbers required a bit of guesswork, since SpaceX does not give us those numbers. So for e.g. Falcon 9, first stage I would take the dry weight (without fuel) assumption and substract the weight of 9 Merlin 1D engines. While for Falcon 1, I would substract just the weight of 1 engine.