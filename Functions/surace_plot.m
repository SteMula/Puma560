function surace_plot
%clear all
close all
clc

mdl_puma560 
p60no_fric = p560.nofriction;

% figure
hold on 

v1 = [1 0.5 0.5 1];
v2 = 0.5*[1 1 -1 -1];
v3 = [0 -0.5 -0.5 0];
v4 = [0 0 0 0];

patch(v1, v2 , v3 , v4);





r = 0.5;
[X, Y, Z] = cylinder(r);

h = 0.5;

Z = Z*h;

Y = 1.25 + Y;

X2 = [];
Y2 = [];
Z2 = [];

for j = 1: size(Y,2)
    if Y(1,j) < 1.0
        X2 = [X2 X(:,j)];
        Y2 = [Y2 Y(:,j)];
        Z2 = [Z2 Z(:,j)];
    end
end



% t1 = Function_trajLine(v1, v2, p560, 5, 0);
% t2 = Function_trajLine(v2, v3, p560, 5, 0);
% t3 = Function_trajLine(v3, v4, p560, 5, 0);
% t4 = Function_trajLine(v4, v1, p560, 5, 0);
% 
% t = [t1 t2 t3 t4];
TTl = ctraj(t1, t2, step);
qq = ikine6s(p60no_fric, TTl);



plot(p560,qq);
title('puma560 Linear Trajectory');
surf(X2,Y2,Z2);
grid on
view(-30, 30);
end

