%%% Initialize PUMA560


clear all
close all
clc
addpath .\Functions;
mdl_puma560 
NFp560 = p560.nofriction;

%% TASK
width = 0.6;
height = 0.8;
center = [0, 0 , 0];
distance = 0.2;
theta = pi/6;

points = [ -width/2, -height/2, 0;
           -width/2,  height/2, 0; 
            width/2,  height/2, 0;
            width/2, -height/2, 0;
                                  ];

proj_points = [ -width/2 + distance*tan(theta), -height/2 + distance*tan(theta), 0;
                -width/2 + distance*tan(theta),  height/2 - distance*tan(theta), 0; 
                 width/2 - distance*tan(theta),  height/2 - distance*tan(theta), 0;
                 width/2 - distance*tan(theta), -height/2 + distance*tan(theta), 0;
                                                                                    ];

T_plane = transl(0.4, -0.4, -0.3)*trotz(pi/2)*troty(pi/4)*trotz(pi/3);

vertices = points;
for i=1:size(points,1)
    vertices(i, :) = h2e( T_plane * e2h( points(i, :)' ) )';
end

% Plane coefficients a,b,c,d (ax + by + cz = d)
coefficients = inv(vertices(1:3, :))*[1;1;1];

% Rotation matrix
column_z = coefficients/norm(coefficients);

column_y = [-column_z(2); column_z(1); 0];
column_y = column_y/norm(column_y);

column_x = cross(column_y, column_z);

rotation = [column_x, column_y, column_z];
if det(rotation) == -1
    temp = rotation(:, 1);
    rotation(:, 1) = rotation(:, 2);
    rotation(:, 2) = temp;
end

% Trajectory planning
extremities = vertices;
for i=1:size(vertices,1)
    extremities(i,:) = h2e( T_plane * e2h( proj_points(i, :)' ) )' - distance*column_z';
end

offset = 0;
reverse = true;
offset_dir = extremities(3,:) - extremities(2,:);
offset_dir = offset_dir/norm(offset_dir);
q = [];
Told = 0;
while offset < width - distance*tan(theta)
    if offset > width - 2*distance*tan(theta)
        Ta = rt2tr(rotation, extremities(4,:)' );
        Tb = rt2tr(rotation, extremities(3,:)' );
    else
        Ta = rt2tr(rotation, (extremities(1,:) + offset*offset_dir)' );
        Tb = rt2tr(rotation, (extremities(2,:) + offset*offset_dir)' );
    end
    if reverse
        temp = Ta;
        Ta = Tb;
        Tb = temp;
    end
    if offset > 0
        T = ctraj(Told, Ta, 20);
        q_temp = p560.ikine6s(T);
        q = [q ; q_temp]; 
    end
    T = ctraj(Ta, Tb, 100);
    q_temp = p560.ikine6s(T);
    q = [q ; q_temp]; 
    reverse = ~reverse;
    offset = offset + 2*distance*tan(theta);
    Told = Tb;
end

% Plot

 figure(2)
 %patch(extremities(:, 1), extremities(:, 2), extremities(:, 3), [0.05 0.4 0.05])
 patch(vertices(:, 1), vertices(:, 2), vertices(:, 3), [0.4 0.05 0.05])
 p560.plot(q)