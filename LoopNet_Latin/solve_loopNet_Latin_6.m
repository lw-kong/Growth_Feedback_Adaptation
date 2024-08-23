rng((now*1000-floor(now*1000))*100000)
filename = ['loop_Latin_6_' datestr(now,30) '_' num2str(randi(999)) '.mat'];

if ispc
    addpath('..\ODE')
    addpath('..\Data')
else
    addpath('../ODE')
    addpath('../Data')
    parpool('local',15)
end

M = 1e4; % repeat number
N = 3; % network size
network_set = [table2array(readtable('nfb.txt')); table2array(readtable('iffl.txt'))];
k_growth_set = [0.2,0.4,0.6,0.8,1];


t_step = 0.05; % 5th gen
t_unit = 200; % 5th gen
a_rest = 0.06;
a_signal = 0.6;
J = 1; % burden
std_relative_thres = 0.05; % 5th gen
std_abs_thres = 1e-4; % 5th gen

trial_num = 1+length(k_growth_set);

%% main
tic
Q_set_all = zeros(size(network_set,1),trial_num);

for network_i = 1:size(network_set,1)
    network = network_set(network_i,2:end);
    L = sum(abs(network));
    dim = 2*N+2*(L+1);
    
    Q_set = zeros(M,trial_num);
    rand_set = lhsdesign(M,dim);
    parfor m_i = 1:M
        rng(m_i*2000 + (now*1000-floor(now*1000))*100000)
        rand_subset = rand_set(m_i,:);
        
        % N * 2
        % growth rate, degradation
        k_node = [10.^( 2*rand_subset(1:N)'-1), 10.^( -2*rand_subset(N+1:2*N)')]; 
        % 10^( -1~1 ), 10^( -2~0 )
        
        % (L+1) * 2
        % n, K^n (np, kp in python codes)
        k_n = 1+3*rand_subset(2*N+1:2*N+L+1)'; % 1~4
        k_K = 10.^( 3*rand_subset(2*N+L+2:2*N+2*L+2)'-3 );  % 10^( -3~0 )
        k_link = [ k_n , k_K .^ k_n  ];
        
        Q_temp = zeros(trial_num,1);
        % no GF
        k_growth = 0;
        [t_switch,x_all,x_after,equili] = func_solve_Hills_GFB_step_6(...
            N,network,k_node,k_link,k_growth,J,...
            t_step,t_unit,a_rest,a_signal,std_relative_thres,std_abs_thres);
        Q_temp(1) = loss_6(x_all,x_after,t_switch,t_step,t_unit,equili);
        % GF
        if Q_temp(1) == 1
            for k_i = 1:length(k_growth_set)
                k_growth = k_growth_set(k_i);

                [t_switch,x_all,x_after,equili] = func_solve_Hills_GFB_step_6(...
                    N,network,k_node,k_link,k_growth,J,...
                    t_step,t_unit,a_rest,a_signal,std_relative_thres,std_abs_thres);
                Q_temp(1+k_i) = loss_6(x_all,x_after,t_switch,t_step,t_unit,equili);
            end
        end
        Q_set(m_i,:) = Q_temp;
        
        if mod(m_i,2500) == 0
            fprintf('%d is done\n',m_i)
        end
    end
    
    Q_set_all(network_i,:,:) = sum(Q_set);
    perfor_temp = [];
    pararand_temp = [];
    for m_i = 1:M
        if sum(Q_set(m_i,:)) ~= 0
            perfor_temp = [perfor_temp; Q_set(m_i,:)];
            pararand_temp = [pararand_temp; rand_set(m_i,:)];
        end
    end
    Q_structure_all(network_i).perfor = perfor_temp;
    Q_structure_all(network_i).pararand = pararand_temp;
    
    clear rand_set Q_set perfor_temp pararand_temp
    save(filename)
    fprintf('Network %d\n',network_i)
    fprintf('Q1_0 = %d\n', Q_set_all(network_i,1))
    toc
end

time_consumed = toc;
save(filename)
if ~ispc
    exit
end