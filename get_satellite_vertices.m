% File: get_thruster_vertices.m
% Author: Jeremy Engels
% Date: 11 August 2021
% Description: calculate vertices for simple satellite diagram

function [x,y] = get_satellite_vertices(theta,L1,L2)

    Q = [cos(theta) -sin(theta); sin(theta) cos(theta)] ...
        * [L1 -L1 -L1 L1; L2 L2 -L2 -L2];
    x = Q(1,:);
    y = Q(2,:);
    
end