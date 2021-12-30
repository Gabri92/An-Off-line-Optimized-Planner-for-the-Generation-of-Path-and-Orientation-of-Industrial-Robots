function pk = sequencer(P,N,n)

% 'sequencer' - Given the control points 'P' computes the 
%  piecewise constant function associated to them, keeping
%  constant each control point for N samples

% INPUT
%   P - Control points
%   N - Number of samples
%   n - length of input point buffer

% OUTPUT
%   pk - piecewise constant function

pk = zeros(1,n*N);
for i = 1:n
    for k = 1:N
        pk(1,(i-1)*N+k) = P(i);
    end
end