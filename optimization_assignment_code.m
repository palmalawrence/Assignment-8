%% THREE ENGINEERING OPTIMIZATION PROBLEMS
% Requires MATLAB Optimization Toolbox: fmincon and linprog.
clear; clc; close all;

%% PROBLEM 1: MINIMIZE MATERIAL FOR A CYLINDRICAL CONTAINER
% Minimize A = 2*pi*r^2 + 2*pi*r*h
% Subject to pi*r^2*h = 1000; r > 0; h > 0.
V = 1000;
objective1= @(z) 2*pi*z(1)^2 + 2*pi*z(1)*z(2);
nonlcon1 = @(z) deal([],pi*z(1)^2*z(2)-V);
z0 = [5;15];
lb1 = [0.01;0.01];
ub1 = [];
opts = optimoptions('fmincon','Display','off','Algorithm','sqp');
[z1,A_min] = fmincon(objective1,z0,[],[],[],[],lb1,ub1,nonlcon1,opts);
r_opt = z1(1); 
h_opt = z1(2);
fprintf('\nPROBLEM 1\n');
fprintf('Optimal radius = %.3f cm\n',r_opt);
fprintf('Optimal height = %.3f cm\n',h_opt);
fprintf('Minimum surface area = %.3f cm^2\n',A_min);

r = linspace(2.5,8.5,400);
h = V./(pi*r.^2);
A = 2*pi*r.^2 + 2*pi*r.*h;
figure; plot(r,A,'LineWidth',1.8); 
hold on;
plot(r_opt,A_min,'ro','MarkerFaceColor','r');
xlabel('Radius, r (cm)');
ylabel('Surface area, A (cm^2)');
title('Problem 1: Minimum material for a cylindrical container');
grid on; 
legend('Surface area','Optimum','Location','best');

%% PROBLEM 2: MAXIMIZE FACTORY PROFIT
% Maximize P = 500*x + 400*y
% Subject to 2*x + y <= 100; x + 2*y <= 80; x,y >= 0.
% linprog minimizes, so minimize negative profit.
f2 = [-500;-400]; A2 = [2 1;1 2]; b2 = [100;80]; lb2 = [0;0];
[x2,negProfit] = linprog(f2,A2,b2,[],[],lb2,[]);
maxProfit = -negProfit;
fprintf('\nPROBLEM 2\n');
fprintf('Product A = %.2f batches/day\n',x2(1));
fprintf('Product B = %.2f batches/day\n',x2(2));
fprintf('Maximum profit = %.2f currency units/day\n',maxProfit);

x = linspace(0,60,400);
y_machine = 100-2*x; 
y_labour = (80-x)/2;
figure;
plot(x,y_machine,'LineWidth',1.8); 
hold on;
plot(x,y_labour,'LineWidth',1.8);
y_feasible = min(y_machine,y_labour);
fill([x fliplr(x)],[zeros(size(x)) fliplr(y_feasible)], ...
 [0.85 0.90 1.00],'FaceAlpha',0.35,'EdgeColor','none');
plot(x2(1),x2(2),'ro','MarkerFaceColor','r','MarkerSize',8);
xlabel('Product A, x (batches/day)');
ylabel('Product B, y (batches/day)');
title('Problem 2: Feasible region and maximum-profit solution');
legend('2x + y = 100','x + 2y = 80','Feasible region','Optimum');
xlim([0 60]); 
ylim([0 90]);
grid on;

%% PROBLEM 3: MINIMIZE COST OF PROTEIN-RICH ANIMAL FEED
% Minimize C = 1200*x + 3000*y
% Subject to x + y = 100; 0.09*x + 0.40*y >= 18; x,y >= 0.
% linprog form of protein constraint: -0.09*x - 0.40*y <= -18.
f3 = [1200;3000]; 
A3 = [-0.09 -0.40]; 
b3 = -18;
Aeq3 = [1 1]; 
beq3 = 100; 
lb3 = [0;0];
[x3,minCost] = linprog(f3,A3,b3,Aeq3,beq3,lb3,[]);
fprintf('\nPROBLEM 3\n');
fprintf('Maize = %.2f kg\n',x3(1));
fprintf('Soybean meal = %.2f kg\n',x3(2));
fprintf('Minimum cost = %.2f currency units\n',minCost);
fprintf('Protein supplied = %.2f kg\n',0.09*x3(1)+0.40*x3(2));

soy = linspace(0,100,400); maize = 100-soy;
cost_curve = 1200*maize + 3000*soy;
figure; plot(soy,cost_curve,'LineWidth',1.8); hold on;
plot(x3(2),minCost,'ro','MarkerFaceColor','r','MarkerSize',8);
xline(x3(2),'--');
xlabel('Soybean meal, y (kg per 100 kg feed)');
ylabel('Total cost (currency units)');
title('Problem 3: Feed formulation cost and optimum');
legend('Total cost','Minimum-cost mixture','Location','best');
grid on;
