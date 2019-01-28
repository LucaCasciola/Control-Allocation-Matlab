clear all
clc

%define the matrices
B = [1 0.5 -0.5 -1 0 0.5 ; 0 0 0 0 2 0 ; -0.05 -0.02 0.02 0.05 0 2 ; -1 -1 -1 -1 -2 0];
A = [-1 0 0.1 0 ; 0 -1 0 -0.1 ; 0 0 -1 0 ; 0 -0.1 0 -1] ;
W = eye(6);
u_lim = [[-0.5 -0.5 -0.5 -0.5 -0.5 -0.5]' [0.5 0.5 0.5 0.5 0.5 0.5]'];
udot_lim = [[2 2 2 2 2 2]'];
xdot_prev = [0 0 0 0]';
Ql = [0 -0.1 0 0 -0.05 0; -0.2 0 0 0 -0.1 0; 0 0 0 0.2 0.1 0; 0 0 0.1 0 0.05 0; 0 0 0 0 0 0; 0 0 0 0 0 0];
Qm = [0 0 0 0 -0.1 0; 0 0 0 0 -0.2 0; 0 0 0 0 -0.2 0; 0 0 0 0 -0.1 0; 0 0 0 0 0 0; 0 0 0 0 0 0];
Qn = [0 -0.025 0 0 0 0; -0.05 0 0 0 0 0; 0 0 0 0.05 0 0; 0 0 0 0.025 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];
Qz = [0 -0.2 0 0 -0.05 0; -0.2 0 0 0 -0.1 0; 0 0 0 -0.2 -0.1 0; 0 0 -0.2 0 -0.05 0; 0 0 0 0 0 0; 0 0 0 0 0 0];


%initialize variables so that we dont have an error
seed_one = 0;
seed_two = 0;
seed_three = 0;
seed_four = 0;
signal_gain = 0;
gain_one = 0;
gain_two = 0;
gain_three = 0;
gain_four = 0;

%define reduction type
reduction_type = 2; %1 truncate (nearest neighbor), 2 scaling (direction preserving
    
sim_time = 1;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%A - montecarlo simulation
    simulate_envelope = 0;
    
    signal_gain = 0.3;
    
    t = 0;    
    for j =0:1:10
    nl_gain = j

        cumIgnoring = 0;
        cumCompensated = 0;
        for k = 1:2
        seed_one = k;
        seed_two = k + 10;
        seed_three = k + 20;
        seed_four = k + 30;

            %actually execute the simulation
            sim('E_nonlinearB')

            t = t+1;
            %gather data
            cumIgnoring = cumIgnoring + sum(error_ignoring);
            cumCompensated = cumCompensated + sum(error_compensated);
        end
        
        %get tables
        tableIgnoring(t,1) = nl_gain;
        tableCompensated(t,1) = nl_gain;
        tableIgnoring(t,2) = sum(error_ignoring);
        tableCompensated(t,2) = sum(error_compensated);
    end  

    %plot 
    figure()
    scatter(tableIgnoring(:,1),tableIgnoring(:,2),'blue')
    hold on
    scatter(tableCompensated(:,1),tableCompensated(:,2),'red')
    xlabel('Non-Linearity gain')
    ylabel('cumulative error')
    legend('Ignoring NL','Compensate NL')
    xlim([0 10])


 
