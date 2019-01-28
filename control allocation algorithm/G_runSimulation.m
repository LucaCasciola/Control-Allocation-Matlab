clear all
clc

%define the matrices
B = [1 0.5 -0.5 -1 0 0.5 ; 0 0 0 0 2 0 ; -0.05 -0.02 0.02 0.05 0 2 ; -1 -1 -1 -1 -2 0];
A = [-1 0 0.1 0 ; 0 -1 0 -0.1 ; 0 0 -1 0 ; 0 -0.1 0 -1];
W1 = eye(6);
W2 = eye(6);
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
sim_time = 0.001;
signal_gain = 0.1;


t=0;
for i = -3:0.5:3
W2 = eye(6);
W2(2,2) = 10^i;
W2(3,3) = 10^i;
W2(6,6) = 10^i;
    
    errorB = 0;
    errorF = 0;
    errorS = 0;
    errorH = 0;
    errorHC = 0;
    for k = 1:10
        k
        seed_one = k;
        seed_two = k + 10;
        seed_three = k + 20;
        seed_four = k + 30;

        sim('G_actuatordynamics')

        errorB = errorB + sum(error_base);
        errorF = errorF + sum(error_fast);
        errorS = errorS + sum(error_slow);
        errorH = errorH + sum(error_half);
        errorHC = errorHC + sum(error_half_compensated);
    end
    
    t = t+1
    table(t,1)= i;
    table(t,2)= errorB;
    table(t,3)= errorF;
    table(t,4)= errorS;
    table(t,5)= errorH;
    table(t,6)= errorHC;
    
end

%plot 
figure()
scatter(table(:,1),(table(:,5)-table(:,3)),'blue')
hold on
scatter(table(:,1),(table(:,6)-table(:,3)),'red')
xlabel('log10 (compensation gain)')
ylabel('cumulative error')
legend('Ignored','Compensated')
ylim([0 1500])

1-((table(13,6)-table(13,3))/(table(13,5)-table(13,3)))