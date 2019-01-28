clear all
clc

%define the matrices
B = [1 0.5 -0.5 -1 0 0.5 ; 0 0 0 0 2 0 ; -0.05 -0.02 0.02 0.05 0 2 ; -1 -1 -1 -1 -2 0];
A = [-1 0 0.1 0 ; 0 -1 0 -0.1 ; 0 0 -1 0 ; 0 -0.1 0 -1] ;
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

%define reduction type
reduction_type = 2; %1 truncate (nearest neighbor), 2 scaling (direction preserving)
    

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%C - montecarlo simulation
    simulate_envelope = 0;
    
    t = 0;    
    for j = 1:0.1:2
    signal_gain = j;

     for k = 1:10
     seed_one = k;
     seed_two = k + 10;
     seed_three = k + 20;
     seed_four = k + 30;

         %actually execute the simulation
         sim('C_framewiseincremental_vs_framewiseglobal')

         t = t+1;
         %gather data
         tableLocal(t,1) = sum(saturatedtime_local/200);
         tableLocal(t,2) = sum(error_local);
         tableLocal(t,3) = sum(norm_local);
         tableGlobal(t,1) = sum(saturatedtime_global/200);
         tableGlobal(t,2) = sum(error_global);
         tableGlobal(t,3) = sum(norm_global);
     end
    end  

    %plot error
    figure()
    scatter(tableLocal(:,2),tableLocal(:,3),'blue')
    hold on
    scatter(tableGlobal(:,2),tableGlobal(:,3),'red')
    xlabel('cumulative error')
    ylabel('cumulative norm')
    ylim([0 2000])
    legend('local','global')


 
    
    
    result = (sum(tableGlobal(:,3)) - sum(tableLocal(:,3)))/sum(tableLocal(:,3));
