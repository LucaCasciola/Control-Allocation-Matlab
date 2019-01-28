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

%variables of interest
sim_time = 0.1;
signal_gain = 0.1;


t=0;
for j=0:0.05:1
gain_compensation = j;

    errorHC = 0;
    errorB = 0;
    timeHC = 0;
    timeB = 0;
    
    for k=1:7
    seed_one = k;
    seed_two = k + 10;
    seed_three = k + 20;
    seed_four = k + 30;

        %actually execute the simulation
        sim('F_aircraftdynamics')

        errorHC = errorHC + sum(error_halfcompensated);
        errorB = errorB + sum(error_base);
        timeHC = timeHC + sum(time_halfcompensated);
        timeB = timeB + sum(time_base);
    end
    t = t+1;
    table(t,1) = gain_compensation;
    table(t,2) = errorB;
    table(t,3) = errorHC;
    table(t,4) = timeB;
    table(t,5) = timeHC;
end


%plot 
figure()
scatter(table(:,1),table(:,2),'blue')
hold on
scatter(table(:,1),table(:,3),'red')
xlabel('compensation gain')
ylabel('cumulative error')
legend('Ignored','Compensated')
ylim([0 800])

%plot 
figure()
scatter(table(:,2),table(:,4)/28,'blue')
hold on
scatter(table(:,2),table(:,4)/28,'red')
xlabel('compensation gain')
ylabel('characteristic time')
legend('Ignored','Compensated')
ylim([0 2000])


save('results')

