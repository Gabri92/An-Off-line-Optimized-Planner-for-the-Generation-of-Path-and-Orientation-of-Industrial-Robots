function [arc, sc_abs] = arc_length(curve)

% 'arc_length' - Given the curve, it compute its arc length 
%  through the polygonal

% INPUT
%   curve - Input curve

% OUTPUT
%   arc - arc length
%   sc_abs - scalar abscissa


% spline = spline;
s = 0;
arc = zeros(length(curve),1);
for i = 2:length(curve)
    temp = sqrt((curve(i,1)-curve(i-1,1))^2+(curve(i,2)-curve(i-1,2))^2+...
        (curve(i,3)-curve(i-1,3))^2); % Poligonale
    s = s + temp;
    arc(i) = s;
end
sc_abs = arc/max(arc);