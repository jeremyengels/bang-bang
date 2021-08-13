% File: get_thruster_vertices.m
% Author: Jeremy Engels
% Date: 9 August 2021
% Description: calculate PWM duty cycle with deadband and saturation

function y = select_duty_cycle(u,d1,d2)
    
    if u < -d2
        y = -d2;
    elseif u < -d1
        y = u;
    elseif u < d1
        y = 0;
    elseif u < d2
        y = u;
    else
        y = d2;
    end

end

