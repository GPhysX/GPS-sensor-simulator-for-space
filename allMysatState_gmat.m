function [mysat_gmat_interp, mysat_gmat_interp_v] = allMysatState_gmat(ti,tf,dt)
% this function provides mysat position in ECI by txt file.

% IMPORT MYSAT DATA
fileID = fopen('ECI_state_mysat.txt','r');
mysat_gmat = fscanf(fileID,'%f', [7,15787]); % rows after 15787 do not concern simulation
fclose(fileID);
mysat_gmat=mysat_gmat';

% SELECT DATA IN THE TIME INTERVAL OF INTEREST
simulation_time=(ti:dt:tf);

i=1;
while i<=size(mysat_gmat,1)
    if mysat_gmat(i,1)<ti || mysat_gmat(i,1)>tf
        mysat_gmat(i,:)=[];
        i=i-1;
    end
    i=i+1;
end

figure()
subplot(2,2,1)
plot3(mysat_gmat(:,2),mysat_gmat(:,3),mysat_gmat(:,4))
xlabel('x [km]')
ylabel('y [km]')
zlabel('z [km]')
grid on
hold on
plot3(0,0,0, 'k*','markersize',3)
title('true mysat orbit')

subplot(2,2,2)
plot(mysat_gmat(:,1)-ti,mysat_gmat(:,2))
xlabel('relative time [s]')
ylabel('x [km]')
grid on
title('true x ECI ')

subplot(2,2,3)
plot(mysat_gmat(:,1)-ti,mysat_gmat(:,3))
xlabel('relative time [s]')
ylabel('y [km]')
grid on
title('true y ECI')

subplot(2,2,4)
plot(mysat_gmat(:,1)-ti,mysat_gmat(:,4))
xlabel('relative time [s]')
ylabel('z [km]')
grid on
title('true z ECI')

%% INTERPOLATE MYSAT DATA IN THE SIMULATION TIME
mysat_gmat_interp=zeros(length(simulation_time),4);
mysat_gmat_interp(:,1)=simulation_time-ti;

mysat_gmat_interp_v=zeros(length(simulation_time),4);
mysat_gmat_interp_v(:,1)=simulation_time;

for i=2:1:4
    mysat_gmat_interp(:,i)=spline(mysat_gmat(:,1),mysat_gmat(:,i), simulation_time); % cubic spline
end

for i=5:1:7
    mysat_gmat_interp_v(:,i-3)=spline(mysat_gmat(:,1),mysat_gmat(:,i), simulation_time); % cubic spline
end


end