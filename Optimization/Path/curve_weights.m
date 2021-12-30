function w = curve_weights(P, points, rad_norm, accuracy)

% 'curve_weigths' - Given the norm of the curvature's radius computes
%  the buffer of weights to be associated to the Nurbs 

% INPUT
%   P - Control points
%   points - Input points of the curve
%   rad_norm - Buffer of radius of curvature
%   accuracy - Regulable parameter which tell how strong should
%   the shaping action on the nurbs

% OUTPUT
%   w - Buffer of weights

%% Pre-elaboration of the datas

P = P(:,2:end-1)';
rad_norm = rad_norm*1/accuracy;
k = 1./rad_norm;

%% Weight's calculation

for i = 1 : length(points)
    if (rad_norm(i,1) < 1) 
        w(i,1) = 1;
    else
w(i,1) = k(i);
    end
end

w = ceil(w*1e1)/1e1;
w(1,1) = 1;
w(end,1) = 1;
