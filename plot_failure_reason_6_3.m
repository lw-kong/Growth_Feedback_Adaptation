%addpath('..\Data')
%addpath('..\ODE')


% load('save_simulations_all.mat')

tic
total_trial = 0;
total_verystable_count = 0;
total_failure_count = 0;

type_c1 = 0; % continuous
type_c2 = 0; % continuous
no_static_count = 0;
%total_diverged = 0;

osc_c_count = 0;
osc_b_count = 0;

type_other_bifur_init = 0;
type_other_bifur_final = 0;
type_other_bifur_peak = 0;

type_others = 0;

interested_set = [];

trial_by_net = zeros(size(network_set,1),2);
trial_by_net(:,1) = Q_set_all(:,1) - Q_set_all(:,end);

for network_i = 1:size(network_set,1)
%for network_i = 26
    perfor = Q_structure_all(network_i).perfor;
    loss_type = Q_structure_all(network_i).loss_osc_type;
    if isempty(perfor)
        continue
    end
    
    
    for trial_i = 1:size(loss_type,1)
        total_trial = total_trial + 1;
        if mean(perfor(trial_i,:)) == 1
            total_verystable_count = total_verystable_count + 1;
        else        
            total_failure_count = total_failure_count + 1;            


            if loss_type(trial_i,4) == 1
                % cannot reach relatively steady state
                no_static_count = no_static_count + 1;   
                %fprintf('oscilation net %d, trial %d\n', network_i,trial_i)   
                %interested_set = [interested_set; network_i, trial_i];
                %trial_by_net(network_i,2) = trial_by_net(network_i,2) + 1;
                
                if loss_type(trial_i,10) == 1
                    osc_c_count = osc_c_count + 1;                   
                    %fprintf('osc continuous %d, trial %d\n', network_i,trial_i)
                    %interested_set = [interested_set; network_i, trial_i];
                    %trial_by_net(network_i,2) = trial_by_net(network_i,2) + 1;
                elseif loss_type(trial_i,11) == 1
                    osc_b_count = osc_b_count + 1;                   
                    fprintf('Hopf net %d, trial %d\n', network_i,trial_i)
                    interested_set = [interested_set; network_i, trial_i];
                    trial_by_net(network_i,2) = trial_by_net(network_i,2) + 1;
                    
                    %
                    if loss_type(trial_i,12) == 1
                        % only 3 trials in total
                        % ignored
                        %fprintf('b1-type osc net %d, trial %d\n', network_i,trial_i)
                        %interested_set = [interested_set; network_i, trial_i];
                        
                    end
                    %
                    
                else
                    fprintf('osc type error')
                end
                
                
            elseif loss_type(trial_i,1) == 1 && sum(loss_type(trial_i,:)) == 1
                type_c1 = type_c1 + 1;
                %fprintf('c1 %d, trial %d\n', network_i,trial_i)
                %interested_set = [interested_set; network_i, trial_i];
                %trial_by_net(network_i,2) = trial_by_net(network_i,2) + 1;
            elseif sum( loss_type(trial_i,2:3) ) >= 1 ...
                    && sum(loss_type(trial_i,[1,4:end])) == 0
                type_c2 = type_c2 + 1;
                %fprintf('c2 %d, trial %d\n', network_i,trial_i)
                %interested_set = [interested_set; network_i, trial_i];
            elseif loss_type(trial_i,7) == 1 % other bifurcation of initial fixed point
                type_other_bifur_init = type_other_bifur_init + 1;
                %fprintf('b1 %d, trial %d\n', network_i,trial_i)
                %interested_set = [interested_set; network_i, trial_i]; 
                %trial_by_net(network_i,2) = trial_by_net(network_i,2) + 1;
            elseif loss_type(trial_i,8) == 1 % other bifurcation of final fixed point
                type_other_bifur_final = type_other_bifur_final + 1;
                %fprintf('bifur final net %d, trial %d\n', network_i,trial_i)
                %interested_set = [interested_set; network_i, trial_i];
                %trial_by_net(network_i,2) = trial_by_net(network_i,2) + 1;
            else
                type_others = type_others + 1;
                %fprintf('others %d, trial %d\n', network_i,trial_i)
                %interested_set = [interested_set; network_i, trial_i]; 
                %trial_by_net(network_i,2) = trial_by_net(network_i,2) + 1;
            end
            % end of loss type 5                    
        end        
    end
end

trial_by_net = [trial_by_net, trial_by_net(:,2)./trial_by_net(:,1)];

result_set = [type_c1, type_c2,...
 osc_c_count, osc_b_count, ...
 type_other_bifur_init,type_other_bifur_final,type_others]/total_failure_count;


name_set = {'continuous: precision',...
    'continuos: sensitivity',...
    'continuous: oscillation',...
    'bifurcation: oscillation',...
    'switching: initial state',...
    'switching: final state',...
    'others'};


newColors = jet( 11 );
color_rainbow0purple = [ newColors([2,4,6,8:10],:); 138/255,10/255,183/255];


figure()
plot_ax = gca();
plot_pie = pie(result_set);
plot_ax.Colormap = color_rainbow0purple;
legend(name_set)
set(gcf,'color','white')


%fprintf('sanity check %d\n',total_trial == total_verystable_count + total_failure_count )