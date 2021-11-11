%%Trajectory generation
function [joints_values] = Function_trajCircle(radius, x_c, y_c, mdl, step, singular_flag) 
%CIRCLE
% radius = 0.2;
gran = linspace(0,2*pi,step);
x = radius*cos(gran) + x_c; % +x is the center
y = radius*sin(gran) + y_c; % +y is the center


for i=1:1:step
    TTc(:,:,i) = transl([x(i) y(i) 0.25]);
end

joints_values = ikine6s(mdl,TTc);

joints_values(:,4) = 0; 
joints_values(:,6) = 0;

% Impose wrist joint variables fixed during the motion, with q5 at pi/4 to
% avoid singular configuration
if singular_flag == 1
    joints_values(:,5) = 0;
else
    joints_values(:,5) = pi/4;
end


