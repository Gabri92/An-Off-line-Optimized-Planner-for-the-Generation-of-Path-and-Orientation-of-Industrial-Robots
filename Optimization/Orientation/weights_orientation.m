function[q] = weights_orientation(points, accuracy_or)

% 'weights_orientation' - It compute the angle between the two segments
% connecting three consecutive points and, depending on this, assign
% the weights to the nurbs

% INPUT
%   points - Points of the nurbs
%   accuracy_or - 

% OUTPUT
%   q - Points of the modified nurbs

%% Computation of the angle between the segment connecting the points

for j = 1:4
P = interpolation(points(:,j));
for i = 1:length(P)
    p(i,:) = [ut(1,i), P(1,i)];
end
distance(1) = 0;
theta(1) = 1;
for i = 2 : length(P)-1
    tg1 = (p(i,:)-p(i-1,:))/norm(p(i,:)-p(i-1,:));
    tg2 = (p(i+1,:)-p(i,:))/norm(p(i+1,:)-p(i,:));
    tg1 = [tg1 0];
    tg2 = [tg2 0];
    theta(i) = atan2d(norm(cross(tg1,tg2)),dot(tg1,tg2))
    distance(i,1) = norm(crv.coefs(1,i)-points(i-1));
end
theta(end+1) = 1;
distance(end+1) = 0;

%% Assignment of the weights

if (accuracy_or == 1)
    v=1;
    w=1;
else
    v = 2 - accuracy_or;
    w = accuracy_or;
end
for i = 2:length(P)-1
    if (theta(i) > 0 && theta(i)<120 && distance(i)<0.003)
        crv.coefs(:,i) = v.*crv.coefs(:,i);
    end
    if (theta(i) > 120 && distance(i) > 0.003)
        crv.coefs(:,i) = w.*crv.coefs(:,i);
    end
end
    nrb1 = nrbeval(crv,linspace(0,1,length(points))) ;   
    q(:,j) = nrb1(1,:);
end