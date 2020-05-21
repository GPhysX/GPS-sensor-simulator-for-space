clear
close all
clc

%% MAIN SCRIPT

% matlab code: to import data from gmat, to initialize variable, to check true trajectory data(plots)
% simulink model: to simulate gps sensor (with noise)

ti=1; % initial time [s]
tf=ti+5600; % final time [s]
dt=1; % simulation time step [s]
simulation_time=(ti:dt:tf)';

%% GPS CONSTELLATION IN ECI BY GMAT SIMULATION
% GPS data do not depend on intial and final time, but only on the length of the simulation time

totsat=24; % number of satellites in the gps constellation
gps_gmat_interp=allGPSpos_gmat(ti,tf,dt); % gps_gmat_interp: first column for times, other columns for position in ECI (t, x1,y1,z1, x2, y2, z2, ...)


%% SATELLITE TRAJECTORY IN ECI FROM TXT FILE

[mysat_gmat_interp, mysat_gmat_interp_v]=allMysatState_gmat(ti,tf,dt); % [time, x, y, z]=[ km km km]

%% SIMULATION OF GPS ALGORITHM WITH NOISE
sim('gps_model')



%% VISUALIZE RESULTS

% position estimate using GPS in the simulation time (ECI)
figure() 
subplot(2,2,1)
plot3(PosEst_mysat.Data(:,1),PosEst_mysat.Data(:,2),PosEst_mysat.Data(:,3))
xlabel('x [km]')
ylabel('y [km]')
zlabel('z [km]')
grid on
title('orbit estimate')
hold on
plot3(0,0,0,'*k')

subplot(2,2,2)
plot(simulation_time-ti, PosEst_mysat.Data(:,1))
xlabel('relative time [s]')
ylabel('x [km]')
grid on
title('x ECI estimate')

subplot(2,2,3)
plot(simulation_time-ti, PosEst_mysat.Data(:,2))
xlabel('relative time [s]')
ylabel('y [km]')
grid on
title('y ECI estimate')

subplot(2,2,4)
plot(simulation_time-ti, PosEst_mysat.Data(:,3))
xlabel('relative time [s]')
ylabel('z [km]')
grid on
title('z ECI estimate')

% absolute error
modPosEst=sqrt(PosEst_mysat.data(:,1).^2+PosEst_mysat.data(:,2).^2+PosEst_mysat.data(:,3).^2);
modPosTrue=sqrt(mysat_gmat_interp(:,2).^2+mysat_gmat_interp(:,3).^2+mysat_gmat_interp(:,4).^2);

abserrx=abs(PosEst_mysat.Data(:,1)-mysat_gmat_interp(:,2));
abserry=abs(PosEst_mysat.Data(:,2)-mysat_gmat_interp(:,3));
abserrz=abs(PosEst_mysat.Data(:,3)-mysat_gmat_interp(:,4));

figure() 
subplot(2,2,1)
plot(simulation_time-ti,modPosEst-modPosTrue)
xlabel('x [km]')
ylabel('y [km]')
zlabel('z [km]')
grid on
title('abs error on module of position')

subplot(2,2,2)
plot(simulation_time-ti,abserrx)
xlabel('relative time [s]')
ylabel('x [km]')
grid on
title('abs error on x ECI')

subplot(2,2,3)
plot(simulation_time-ti, abserry)
xlabel('relative time [s]')
ylabel('y [km]')
grid on
title('abs error on y ECI')

subplot(2,2,4)
plot(simulation_time-ti, abserrz)
xlabel('relative time [s]')
ylabel('z [km]')
grid on
title('abs error on z ECI')


% relative error
figure() 
subplot(2,2,1)
plot(simulation_time-ti,(modPosEst-modPosTrue)/modPosTrue)
xlabel('x [km]')
ylabel('y [km]')
zlabel('z [km]')
grid on
title('rel error on module of position')

subplot(2,2,2)
plot(simulation_time-ti, abserrx/abs(mysat_gmat_interp(:,2)))
xlabel('relative time [s]')
ylabel('x [km]')
grid on
title('rel error on x ECI')

subplot(2,2,3)
plot(simulation_time-ti, abserry/abs(mysat_gmat_interp(:,3)))
xlabel('relative time [s]')
ylabel('y [km]')
grid on
title('rel error on y ECI')

subplot(2,2,4)
plot(simulation_time-ti, abserrz/abs(mysat_gmat_interp(:,4)))
xlabel('relative time [s]')
ylabel('z [km]')
grid on
title('rel error on z ECI')





