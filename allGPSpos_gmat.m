function [gps_gmat_interp] = allGPSpos_gmat(ti, tf, dt)

% this function provides GPS orbits from GMAT.
% gps_gmat contains x,y,z for the 1° gps satellite, for the 2°, ...
% 24 gps satellites and 1 orbit (24 h) are considered

% gmat data are interpolated from 0 to tf.


%% import GPS data
fileID = fopen('ReportFileGPS_1_to_8.txt','r');
gps_gmat1 = fscanf(fileID,'%f', [25,126]);
fclose(fileID);
gps_gmat1=gps_gmat1';

fileID = fopen('ReportFileGPS_9_to_16.txt','r');
gps_gmat2 = fscanf(fileID,'%f', [25,126]);
fclose(fileID);
gps_gmat2=gps_gmat2';

fileID = fopen('ReportFileGPS_17_to_24.txt','r');
gps_gmat3 = fscanf(fileID,'%f', [25,126]);
fclose(fileID);
gps_gmat3=gps_gmat3';

gps_gmat=[gps_gmat1 gps_gmat2 gps_gmat3];
gps_gmat(:,26)=[]; % times
gps_gmat(:,50)=[]; % times
gps_gmat(13:1:end,:)=[]; % selection of simulation time

%% plot (check)
sat=1;

figure()
for i=2:3:71
sat
plot3(gps_gmat(:,i), gps_gmat(:,i+1), gps_gmat(:,i+2), 'b') % GPS orbits
hold on
plot3(gps_gmat(1,i), gps_gmat(1,i+1), gps_gmat(1,i+2),'b*','markersize',5 ) % GPS initial positions

grid on
xlabel('x [km]')
ylabel('y [km]')
zlabel('z [km]')
hold on

sat=sat+1;
end

hold on
plot3(0,0,0, 'k*', 'markersize', 5) % Earth centre

%% interpolate GPS data

simulation_time=(0:dt:tf-ti);

gps_gmat_interp=zeros(length(simulation_time),73);
gps_gmat_interp(:,1)=simulation_time;

for i=2:1:73
    gps_gmat_interp(:,i)=spline(gps_gmat(:,1),gps_gmat(:,i), simulation_time); % cubic spline
end

sat=1;


for i=2:3:71
sat
plot3(gps_gmat_interp(:,i), gps_gmat_interp(:,i+1), gps_gmat_interp(:,i+2), 'r') % GPS orbits
hold on
plot3(gps_gmat_interp(1,i), gps_gmat_interp(1,i+1), gps_gmat_interp(1,i+2),'r*','markersize',5 ) % GPS initial positions

grid on
xlabel('x [km]')
ylabel('y [km]')
zlabel('z [km]')
hold on
title('GPS constellation by GMAT and spline interpolation in the simulation time')
sat=sat+1;
end

hold on
plot3(0,0,0, 'k*', 'markersize', 5) % Earth centre


end