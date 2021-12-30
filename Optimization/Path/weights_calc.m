function [crv,w] = weights_calc(crv, accuracy, P, p)

% 'weights_calc' - Oversample the curve in input and assign to
% that the weights in output from 'curve_weights'

% INPUT
%   crv - Input nurbs
%   accuracy -  Regulable parameter which tell how strong should
%   the shaping action on the nurbs
%   P - Control points of the nurbs
%   p - Points of the nurbs

% OUTPUT
%   crv - Modified nurbs
%   w - Buffer of weights

%% Oversampling of the curve

multi = 10;
n = length(p);
neval = n*multi;
ut = linspace(0,1,neval);
nrb = nrbeval(crv,ut);

%% Computation of the angles between points 

for i = 1:3
    theta(:,i) = angle_calc(nrb(i,:)');
end

%% Computation and assignment of the weights

for i = 1:3
[Norm, Coord] = curve_rad(n,[linspace(0,nrb(i,end),length(nrb)); nrb(i,:); zeros(1,length(nrb))],multi);
w(:,i) = curve_weights(P(i,:),p(:,i),Norm,Coord,accuracy);
end
for i = 1:3
    if (max(theta(:,i)) > 160)
        crv.coefs(:,2:end-1) = w(:,i)'.*crv.coefs(:,2:end-1);
    end
end

