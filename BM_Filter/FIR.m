function curve = FIR(N ,pk, initStates, degree)

% 'FIR' - Build the moving average filters and filter three times 
%  the piecewise constant function through them

% INPUT
%   N - Number of samples
%   pk - Piecewise constant function
%   initStates - 
%   degree - Desired degree of the spline

% OUTPUT
%   curve - Output curve

% Building of the filter
b = (1/(N))*ones(1,N);
a = 1;
initStates = initStates*ones(1,N-1);

% Implementation of the cascade of filters
curve(1,:) = filter(b,a,pk,initStates);
for k=2:degree
    curve(k,:) = filter(b,a,curve(k-1,:),initStates);
end

curve = curve(3,:);