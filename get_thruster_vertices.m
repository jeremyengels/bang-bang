% File: get_thruster_vertices.m
% Author: Jeremy Engels
% Date: 11 August 2021
% Description: calculate vertices for thrusters in satellite diagram

function [x1,y1,x2,y2] = get_thruster_vertices(u,theta,L1,L2,a,b)
    
    if u == 0
        Q1 = [0; 0];
        Q2 = [0; 0];
        
    elseif u > 0
        Q1 = [cos(theta) -sin(theta); sin(theta) cos(theta)] ...
            * ([-L1; L2] + [0 a -a; 0 b b]);
        Q2 = [cos(theta) sin(theta); -sin(theta) cos(theta)] ...
            * ([L1; -L2] + [0 a -a; 0 -b -b]);
    else
        Q1 = [cos(theta) -sin(theta); sin(theta) cos(theta)] ...
            * ([L1; L2] + [0 a -a; 0 b b]);
        Q2 = [cos(theta) sin(theta); -sin(theta) cos(theta)] ...
            * ([-L1; -L2] + [0 a -a; 0 -b -b]);
    end
    
    x1 = Q1(1,:);
    y1 = Q1(2,:);
    x2 = Q2(1,:);
    y2 = Q2(2,:);
end