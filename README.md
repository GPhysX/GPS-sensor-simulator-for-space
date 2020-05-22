# GPS-sensor-simulator-for-space
simulation of satellite position estimate via GPS sensor in Matlab/Simulink.

This simulator aims to evaluate the capabilities of a GPS sensor to estimate position of a satellite on orbit. You have to provide your satellite trajectories in ECI as input (in my case, I got it from GMAT simulations) and estimate the noise in your GPS sensor.
For the whole simulation time, this simulator provides position estimate by solving GPS nonlinear system using Multivariate Newton’s method. It also provides absolute and relative errors with reference to the true input trajectories. See “details.pdf” for details.

It may seem a bit confusing to do some work to generate an output giving the exact information you have to provide as input… but it’s all ok. This script is the first step to build more complex simulators dealing with sensor fusion or noise correction. For example, you can add a Kalman filter to the current output values to estimate its capabilities to improve position estimates. You can also use Kalman filter for sensor fusion to merge position estimate from different navigation sensor.


•	Provide trajectory data in “ECI_state_mysat.txt” (data format is suggested in the first rows of the file),

•	Set GPS noise in the Simulink model “gps_model.slx”,

•	Launch “gps_initialization.m”,

•	Get results.
