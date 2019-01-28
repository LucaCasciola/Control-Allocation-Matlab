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
reduction_type = 1; %1 truncate (nearest neighbor), 2 scaling (direction preserving)
    

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%A - montecarlo simulation
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
         sim('A_simple_vs_cascaded')

         t = t+1;
         %gather data
         tableSimple(t,1) = sum(saturatedtime_simple/200);
         tableSimple(t,2) = sum(error_simple);
         tableCascaded(t,1) = sum(saturatedtime_cascaded/200);
         tableCascaded(t,2) = sum(error_cascaded);
     end
    end  

    %plot 
    figure()
    scatter(tableSimple(:,1),tableSimple(:,2),'blue')
    hold on
    scatter(tableCascaded(:,1),tableCascaded(:,2),'red')
    xlabel('fraction of time in saturation')
    ylabel('cumulative error')
    xlim([0 0.5])
    ylim([0 2000])
    legend('simple','cascaded')


    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%A - flight envelope extension
    simulate_envelope = 1;
   
    notsaturated_simple = 0;
    notsaturated_cascaded = 0;
    
    for k = 1:50
    rng(k)
    gain_one = rand()*2;
    rng(k+20)
    gain_two = rand()*2;
    rng(k+30)
    gain_three = rand()*2;
    rng(k+40)
    gain_four = rand()*2;

     %actually execute the simulation
     sim('A_simple_vs_cascaded')

     %gather data
     error_simple(isnan(error_simple)) = [];
     error_simple = round(error_simple,6);
     notsaturated_simple = notsaturated_simple + sum(error_simple == 0);
     
     error_cascaded(isnan(error_cascaded)) = [];
     error_cascaded = round(error_cascaded,6);
     notsaturated_cascaded = notsaturated_cascaded + sum(error_cascaded == 0);
    end
    
    
    result = (notsaturated_cascaded - notsaturated_simple)/notsaturated_simple;
