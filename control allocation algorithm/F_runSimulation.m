clear all
clc

%define the matrices
B = [1 0.5 -0.5 -1 0 0.5 ; 0 0 0 0 2 0 ; -0.05 -0.02 0.02 0.05 0 2 ; -1 -1 -1 -1 -2 0];
A = [-1 0 0.1 0 ; 0 -1 0 -0.1 ; 0 0 -1 0 ; 0 -0.1 0 -1];
W = eye(6);
u_lim = [[-0.5 -0.5 -0.5 -0.5 -0.5 -0.5]' [0.5 0.5 0.5 0.5 0.5 0.5]'];
udot_lim = [[2 2 2 2 2 2]'];
xdot_prev = [0 0 0 0]';


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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%A - montecarlo simulation
    sim_time = 0.1;
    
    signal_gain = 0.1;
    
    t = 0;    
    for j =0:0.1:2
    signal_gain = j;

        for k = 1:5
        seed_one = k;
        seed_two = k + 10;
        seed_three = k + 20;
        seed_four = k + 30;

            %actually execute the simulation
            sim('G_actuatordynamics')

            t = t+1;
            %gather data
            nsIgnored(t,1) = 200 - sum(saturatedtime_ignored);
            nsIgnored(t,2) = sum(error_ignored(saturatedtime_ignored == 0));
            
            nsCompensated(t,1) = 200 - sum(saturatedtime_compensated);
            nsCompensated(t,2) = sum(error_compensated(saturatedtime_compensated == 0));
            
            sIgnored(t,1) = sum(saturatedtime_ignored);
            sIgnored(t,2) = sum(error_ignored(saturatedtime_ignored ~= 0));
            
            sCompensated(t,1) = sum(saturatedtime_compensated);
            sCompensated(t,2) = sum(error_compensated(saturatedtime_compensated ~= 0));
            
            Ignored(t,1) = signal_gain;
            Ignored(t,2) = sum(error_ignored);
            
            Compensated(t,1) = signal_gain;
            Compensated(t,2) = sum(error_compensated);  
        end
    end  

    %plot 
    figure()
    scatter(sIgnored(:,1),sIgnored(:,2),'blue')
    hold on
    scatter(sCompensated(:,1),sCompensated(:,2),'red')
    xlabel('saturation time')
    ylabel('cumulative error')
    legend('Ignored','Compensated')
    ylim([0 6000])


 
