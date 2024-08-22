
function [t_switch,x_all,x_after,equili] = func_solve_Hills_GFB_step_6_2Node(...
    num_node,network,k_node,k_link,k_growth,J,...
    t_step,t_unit,a_rest,a_signal,std_relative_thres,std_abs_thres)
% equili
% 1: successful
% 0: old version
% -1: no equilibrium before the input signal
% -2: no equilibrium after the input signal

while_count_threshold = 20;



%% k_linkfull
k_linkfull = zeros(num_node+1,num_node+1,1+2); % [link_type, n, K^n]
% Here input is node 1, so everything is moved one after: (n_i+1,n_j+1)
% A to A
% B to A
% C to A
% A to B
% ...

k_linkfull(1,2,1) = 1;
k_linkfull(1,2,2:end) = k_link(1,:);
link_i = 2;
for n_j = 1:num_node
    for n_i = 1:num_node
        nl = num_node*(n_i-1) + n_j;
        if network(nl) ~= 0
            k_linkfull(n_i+1,n_j+1,1) = network(nl);
            k_linkfull(n_i+1,n_j+1,2:end) = k_link(link_i,:);
            link_i = link_i + 1;
        end
    end
end

%% before signal
x0 = [0.1*ones(1,num_node),-3];

[~,x] = ode4(@(t,x) eq_Hills_GFB_2Node_NoNoise(t,x,a_rest,k_node,k_linkfull,k_growth,J),0:t_step:t_unit,x0);
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
    [~,x] = ode4(@(t,x) eq_Hills_GFB_2Node_NoNoise(t,x,a_rest,k_node,k_linkfull,k_growth,J),0:t_step:t_unit,x0);
    x_all = [x_all; x(2:end,:)]; % updated
    while_count_1 = while_count_1 + 1;
    
    if ( std(x(:,1)/mean(x(:,1))) < std_relative_thres ...
        && std(x(:,2)/mean(x(:,2))) < std_relative_thres ) ...
        ||( std(x(:,1)) < std_abs_thres ...
        && std(x(:,2)) < std_abs_thres )
        flag_eq = flag_eq + 1;
    else
        flag_eq = 0;
    end
    
end

t_switch = while_count_1 * t_unit;

%% after signal
x0(:) = x_all(end,:);
[~,x] = ode4(@(t,x) eq_Hills_GFB_2Node_NoNoise(t,x,a_signal,k_node,k_linkfull,k_growth,J),0:t_step:t_unit,x0);
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
    [~,x] = ode4(@(t,x) eq_Hills_GFB_2Node_NoNoise(t,x,a_signal,k_node,k_linkfull,k_growth,J),0:t_step:t_unit,x0);
    x_after = [x_after; x(2:end,:)]; % updated
    while_count_2 = while_count_2 + 1;
    
    if ( std(x(:,1)/mean(x(:,1))) < std_relative_thres ...
        && std(x(:,2)/mean(x(:,2))) < std_relative_thres ) ...
        ||( std(x(:,1)) < std_abs_thres ...
        && std(x(:,2)) < std_abs_thres )
        flag_eq = flag_eq + 1;
    else
        flag_eq = 0;
    end
    
end

x_all = [x_all; x_after(2:end,:)]; % updated
equili = 1;

