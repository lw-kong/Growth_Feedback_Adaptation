
function [t_switch,x_all,x_after,equili] = func_solve_Hills_GFB_step_61_1NodeSA_NoJ(...
    num_node,k_node,k_link,k_growth,...
    t_step,t_unit,a_rest,a_signal,std_abs_thres)
% equili
% 1: successful
% 0: old version
% -1: no equilibrium before the input signal
% -2: no equilibrium after the input signal

% changes from func_solve_Hills_GFB_step_6:
%    remove k_linkfull
%    remove network

while_count_threshold = 20;


%% before signal
x0 = [0.1*ones(1,num_node),-3];

[~,x] = ode4(@(t,x) eq_Hills_GFB_1NodeSA_NoNoise_NoJ(t,x,a_rest,k_node,k_link,k_growth),0:t_step:t_unit,x0);
x_all = x;

while_count_1 = 1;
flag_eq = 0;
while flag_eq ~= 2
    if while_count_1 > while_count_threshold
        %disp('Unable to reach equilibium before signal.')
        t_switch = while_count_1 * t_unit;
        x_after = zeros(1,num_node+1);
        equili = -1;
        return
    end
 
    x0(:) = x_all(end,:);
    [~,x] = ode4(@(t,x) eq_Hills_GFB_1NodeSA_NoNoise_NoJ(t,x,a_rest,k_node,k_link,k_growth),0:t_step:t_unit,x0);
    x_all = [x_all; x(2:end,:)]; % updated
    while_count_1 = while_count_1 + 1;
    
    % num_node sensitive
    if std(x(:,1)) < std_abs_thres
        flag_eq = flag_eq + 1;
    else
        flag_eq = 0;
    end
    
end

t_switch = while_count_1 * t_unit;

%% after signal
x0(:) = x_all(end,:);
[~,x] = ode4(@(t,x) eq_Hills_GFB_1NodeSA_NoNoise_NoJ(t,x,a_signal,k_node,k_link,k_growth),0:t_step:t_unit,x0);
x_after = x;

while_count_2 = 1;
flag_eq = 0;
while flag_eq ~= 2
    if while_count_2 > while_count_threshold
        %disp('Unable to reach equilibium after signal.')
        x_all = [x_all; x_after(2:end,:)]; % updated
        equili = -2;
        return
    end
    
    x0(:) = x_after(end,:);
    [~,x] = ode4(@(t,x) eq_Hills_GFB_1NodeSA_NoNoise_NoJ(t,x,a_signal,k_node,k_link,k_growth),0:t_step:t_unit,x0);
    x_after = [x_after; x(2:end,:)]; % updated
    while_count_2 = while_count_2 + 1;
    
    % num_node sensitive
    if std(x(:,1)) < std_abs_thres
        flag_eq = flag_eq + 1;
    else
        flag_eq = 0;
    end
    
end

x_all = [x_all; x_after(2:end,:)]; % updated
equili = 1;

