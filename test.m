%% BM FILTER

% In this Matlab code the use of the cascade of filters to selectively
% reduce the velocity in the re-orientation area and the filtering of 
% the overall trajectory to smoothen the transitions among different
% velocities

clc, clear all, close all

load points.mat
load Cntrl_Point.mat

%% Implementation of the filter 

[ num, den ] = get_IIR2( 5, 0.99 , 5, 1, 0.002 );
LP = tf( num, den, 0.002, 'variable', 'z^-1' );
my_bode( LP, 0.1, 1/0.002 ) 

%% Use of the moving average filters 

[arc, par] = ArcLength(points);
%BM FILTER
for i = 1:7
    F = 100;
    [T1,N1,pk1(:,i),spline1(:,i)] = B_M_Filter(P(:,i),F);
end
for i = 1:7
    F = 10;
    [T2,N2,pk2(:,i),spline2(:,i)] = B_M_Filter(P(786:856,i),F);
end
temp = spline1(1:3929,1:7);
temp1 = spline1(4269:end,1:7);
curve = [temp; spline2; temp1];
[arc, par] = ArcLength(curve);
clear spline;

%% Filtering of the scalar abscissa

n = 100;
par1 = filtfilt( num, den, [zeros(n,1); par; ones(n,1)]);
figure, plot(linspace(0,1,length(par1)),par1)
xlabel('Parametric vector'), ylabel('Scalar abscissa'), grid on
spline = interparc(par1,curve(:,1),curve(:,2),curve(:,3),'linear');
quat_in = curve(1,4:7);
quat_fin = curve(end,4:7);
spline(:,4:7) = [quat_in.*ones(n,1); curve(:,4:7); quat_fin.*ones(n,1)];


%% PLOT 

figure,
plot3(spline(:,1),spline(:,2),spline(:,3),'r'), grid on, axis equal
figure,
plot(par1,[spline(:,4) spline(:,5) spline(:,6) spline(:,7)]), grid on

Ts = 0.002;
t = [0:Ts:Ts*(length(spline)-1)];


% VELOCITY
dx = zeros(1,length(spline));
dy = zeros(1,length(spline));
dz = zeros(1,length(spline));
dx(1) = 0;
dy(1) = 0;
dz(1) = 0;
dx(2:end) = diff(spline(:,1))/Ts;
dy(2:end) = diff(spline(:,2))/Ts;
dz(2:end) = diff(spline(:,3))/Ts;
Vel = sqrt(dx.^2+dy.^2+dz.^2)';
figure, plot(t,Vel./1000), grid on, xlabel('Time - [s]'), ylabel('Velocity - [m/s]')
