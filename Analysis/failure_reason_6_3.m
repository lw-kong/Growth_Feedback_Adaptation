
%{
if ispc
    addpath('..\Data')
    addpath('..\ODE')
else
    addpath('../Data')
    addpath('../ODE')
    parpool('local',45)
end
%}

% load('save_simulations_all.mat')

t_step = 0.05; % 5th gen
t_unit = 200; % 5th gen
J = 1; % burden
a_rest = 0.06;
a_signal = 0.6;
std_relative_thres = 0.05; % 5th gen
std_abs_thres = 1e-4; % 5th gen

N = 3; % network size
network_set = [table2array(readtable('nfb.txt')); table2array(readtable('iffl.txt'))];
k_growth_set = [0, k_growth_set];
loss_type_num = 14;
%% loop
tic
for network_i = 1:size(network_set,1)
    rand_set = Q_structure_all(network_i).pararand;
    if isempty(rand_set)
        continue
    end
    perfor_set = Q_structure_all(network_i).perfor;
    cp_max_set = Q_structure_all(network_i).cp_set(:,2);
    cp_min_set = Q_structure_all(network_i).cp_set(:,1);
    
    network = network_set(network_i,2:end);
    L = sum(abs(network));
    dim = 2*N+2*(L+1);
    
    loss_type_set = zeros(size(rand_set,1),loss_type_num);
    parfor trial_i = 1:size(rand_set,1)
        perfor = perfor_set(trial_i,:);
        cp_max = cp_max_set(trial_i);
        cp_min = cp_min_set(trial_i);
              
        if min(perfor) == 1
            loss_type_set(trial_i,:) = zeros(1,loss_type_num); 
            continue
        end   
        
        rand_subset = rand_set(trial_i,:);
        % N * 2
        % growth rate, degradation
        k_node = [10.^( 2*rand_subset(1:N)'-1), 10.^( -2*rand_subset(N+1:2*N)')];
        % 10^(-1~1), 10^( -2~0 )
        % (L+1) * 2
        % n, K^n (np, kp in python codes)
        k_n = 1+3*rand_subset(2*N+1:2*N+L+1)'; % 1~3
        k_K = 10.^( 3*rand_subset(2*N+L+2:2*N+2*L+2)'-3 );  % 10^( -2~1 )
        k_link = [ k_n , k_K .^ k_n  ];
        %
        
        %% check
        
        k_growth = cp_max; % set k_growth to be right after critical point        
        [t_switch,x_all,x_after,equili] = func_solve_Hills_GFB_step_6(N,network,k_node,k_link,k_growth,J,...
            t_step,t_unit,a_rest,a_signal,std_relative_thres,std_abs_thres);

        k_growth_0 = cp_min; % set k_growth to be right before critical point        
        [t_switch_0,x_all_0,x_after_0,equili_0] = func_solve_Hills_GFB_step_6(N,network,k_node,k_link,k_growth_0,J,...
            t_step,t_unit,a_rest,a_signal,std_relative_thres,std_abs_thres);

        
        loss_type_set(trial_i,:) = loss_6_3_type(...
            x_all,x_after,t_switch,t_step,equili...
            ,x_all_0,x_after_0,t_switch_0,t_unit);       
        %fprintf('trial_i %d\n',trial_i)
    end
    
    Q_structure_all(network_i).loss_osc_type = loss_type_set;
    fprintf('network %d is done\n',network_i)
    toc
end

%save('save_simulations_all.mat')