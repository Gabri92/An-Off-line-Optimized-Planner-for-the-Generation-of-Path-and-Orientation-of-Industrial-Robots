function P = interpolation(q)

% 'interpolation' - Given the input points representing the 
%  desired curve it computes the control points computing the 
%  tridiagonal system : Ax = b

% INPUT
%   q - Input points

% OUTPUT
%   P - Control points

degree = 3;
n = length(q);

%% Tridiagonal matrix
A = zeros(n-2,n-2);
row = [1 4 1 zeros(1,n-5)];
for i = 1:n-3
   A(i+1,:) = row;
   row = circshift(row,1);
end
A(1,:) = [4 1 zeros(1,n-4)];
A(end,:) = [zeros(1,n-4) 1 4];


%% Computation of the control points
B = zeros(n-2,1);
B(1) = 6*q(2)-q(1);
for k = 2:length(B)-1
    B(k) = 6*q(k+1);
end
B(end) = 6*q(end-1)-q(end);

P(1:degree-1) = q(1);
P(degree:n) = A\B;
P(n+1:n+2) = q(end);