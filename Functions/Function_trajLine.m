%%Trajectory generation
function [qq]=Function_trajLine(initpoint, finalpoint, mdl, step, singular_flag)
%% Computation of the 
T1 = transl(initpoint); % Start
T2 = transl(finalpoint);	% Destination

TTl = ctraj(T1, T2, step);
qq = ikine6s(mdl, TTl);

% Impose wrist joint variables fixed during the motion, with q5 at pi/4 to
% avoid singular configuration
qq(:,4)=0;
qq(:,6)=0;

if singular_flag == 1
    qq(:,5)=0;
else
    qq(:,5)=pi/4;
end
    
end


