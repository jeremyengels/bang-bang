% File: bang-bang-control.m
% Author: Jeremy Engels
% Date: 8 August 2021
% Description: simulate a PID bang-bang controller on a simple satellite

clc; clear; close all;
plotdefaults(20,6,2,'northeast')


f_dyn = 100;    % [Hz] dynamics update frequency
f_pwm = 5;      % [Hz] bang-bang pwm frequency 

T_end = 10;    % [s]


% define plant
A = [0 1; 0 0];
B = [0; 1];

% define controller
Kp = 1;
Kd = 1;
Ki = 1e-6;
pos_ref = 0;
rate_ref = 0;
pos_error_sum = 0;


% define bang-bang parameters
pulse_height = 1;
initial_duty_cycle = 0;
duty_cycle = 0;

i = 1;
t = 0:(1/f_dyn):T_end;
x = [-1; 0];

while t(i) < T_end
    
    if mod(t(i),1/f_pwm) < 1e-5 
        pwm_reset_time = t(i);
        
        % continuous control law
        pos_error = pos_ref - x(1,i);
        rate_error = rate_ref - x(2,i);
        continuous_control_input = Kp*pos_error + Kd*rate_error + Ki*pos_error_sum*f_dyn;
        
        % bang-bang implementation
        initial_duty_cycle = (continuous_control_input + initial_duty_cycle - duty_cycle)/pulse_height;
        duty_cycle = select_duty_cycle(initial_duty_cycle,0.1,0.5);
        
    end
    
    if t(i) - pwm_reset_time < abs(duty_cycle)/f_pwm
        u(i) = pulse_height*sign(duty_cycle);
    else
        u(i) = 0;
    end
    
    
    %% ANIMATION
    
    if mod(t(i),3/f_dyn) < 1e-5
        [x_sat, y_sat] = get_satellite_vertices(x(1,i),2,1);
        [x1_th,y1_th,x2_th,y2_th] = get_thruster_vertices(u(i),x(1,i),2,1,.25,1);
        figure(1)
        fill(x_sat,y_sat,'k');
        hold on
        fill(x1_th,y1_th,'r');
        fill(x2_th,y2_th,'r');
        hold off
        pbaspect([1 1 1])
        axis([-3 3 -3 3])
        
        
        figure(2)
        subplot(211)
        plot(t(1:i),x(:,1:i))
        title('State')
        legend('Angle','Angular Rate')
        xlim([0 T_end])
        ylim([-1.1 1.1])
        
        subplot(212)
        plot(t(1:i),u(1:i))
        title('Control Input')
        xlim([0 T_end])
        ylim([-1.1 1.1])
        xlabel('time')
        
    end
    
    % integral accumulation
    pos_error_sum = pos_error_sum + pos_ref - x(1,i);
    
    % propogate state
    x(:,i+1) = x(:,i) + (A*x(:,i) + B*u(i))/f_dyn;
    i = i + 1;
     
    
end
