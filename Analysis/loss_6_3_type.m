function loss_type = loss_6_3_type(x_all,x_after,t_switch,t_step,equili...
    ,x_all_0,x_after_0,t_switch_0,t_unit)
% modified abrupt change criterion

loss_type = zeros(14,1);



if equili <= 0
    loss_type(4) = 1; % no stable final states
    % the bounded condition was ignored
    
    if equili == -1 % before the input
        std_all = std( x_all( (t_switch-t_unit)/t_step : t_switch/t_step-1,1:end-1) );
        std_0_all = std( x_all_0( (t_switch_0-t_unit)/t_step : t_switch_0/t_step-1,1:end-1) );
        loss_type(13) = 1;
    elseif equili == -2 % after the input
        std_all = std( x_all( end-t_unit/t_step : end,1:end-1) ); 
        std_0_all = std( x_all_0( end-t_unit/t_step : end,1:end-1) );
        loss_type(14) = 1;
    else
        fprintf('unknown equili type\n')
    end
        
    % abrupt changes
    % relative change of std could be large even if the changing is
    % continuous. As the simulation temporal length could be large,
    % a small deviation in the oscialltion amplititude decay rate can
    % result in very different std in the final t_unit.
    
    if max(abs(log10(std_all) - log10(std_0_all))) <= 1
        loss_type(10) = 1; % continuous
    else   
        loss_type(11) = 1; % abrupt
    end
    
    % check if there is bifurcation in the initial state, and then an osc
    % in the final state
     if equili == -2
        o1_all = mean( x_all( t_switch/t_step-t_unit/t_step: t_switch/t_step-1,1:end-1) );
        o1_0_all = mean( x_all_0( t_switch_0/t_step-t_unit/t_step: t_switch_0/t_step-1,1:end-1) );
        if norm( o1_all-o1_0_all ) / norm(o1_0_all) >= 0.05 ...
            || (o1_0_all(1)>1e-3 && abs(o1_all(1)-o1_0_all(1)) / o1_0_all(1) >= 0.05 ) ...
            || (o1_0_all(2)>1e-3 && abs(o1_all(2)-o1_0_all(2)) / o1_0_all(2) >= 0.05 ) ...
            || (o1_0_all(3)>1e-3 && abs(o1_all(3)-o1_0_all(3)) / o1_0_all(3) >= 0.05 ) ...
            || (o1_0_all(1)<1e-3 && abs(o1_all(1)-o1_0_all(1)) >= 1e-2 ) ...
            || (o1_0_all(2)<1e-3 && abs(o1_all(2)-o1_0_all(2)) >= 1e-2 ) ...
            || (o1_0_all(3)<1e-3 && abs(o1_all(3)-o1_0_all(3)) >= 1e-2 )
        
            loss_type(12) = 1;
        end
     end
    
    
    
else
    o1 = mean( x_all( t_switch/t_step-t_unit/t_step: t_switch/t_step-1,end-1) );
    o2 = mean( x_all( end-t_unit/t_step:end,end-1) );
    o1_all = mean( x_all( t_switch/t_step-t_unit/t_step: t_switch/t_step-1,1:end-1) );
    o2_all = mean( x_all( end-t_unit/t_step:end,1:end-1) );
    [peak_height,peak_position] = max(abs(x_after(:,end-1)-o1));
    
    relative_response = peak_height/o1;
    adaptation_error = abs( (o2-o1)/o1 );
    
    o1_0 = mean( x_all_0( t_switch_0/t_step-t_unit/t_step: t_switch_0/t_step-1,end-1) );
    o1_0_all = mean( x_all_0( t_switch_0/t_step-t_unit/t_step: t_switch_0/t_step-1,1:end-1) );
    o2_0_all = mean( x_all_0( end-t_unit/t_step:end,1:end-1) );
    [~,peak_position_0] = max(abs(x_after_0(:,end-1)-o1_0));
    
    if adaptation_error >= 0.1 % adaptation error too big
        loss_type(1) = 1;
    end
    if peak_height <= 0.1 % peak height too low
        loss_type(2) = 1;
    end
    if relative_response <= 0.5 % relative response too small
        loss_type(3) = 1;
    end
    
    if x_after(peak_position,end-1) == o2 % peak height == final
        loss_type(5) = 1;
    end
    if max(x_after(:,end-1)) - min(x_after(:,end-1)) <= 1e-2 % no response at all
        loss_type(6) = 1;
    end
    
    % abrupt changes
    if norm( o1_all-o1_0_all ) / norm(o1_0_all) >= 0.05 ...
            || (o1_0_all(1)>1e-3 && abs(o1_all(1)-o1_0_all(1)) / o1_0_all(1) >= 0.05 ) ...
            || (o1_0_all(2)>1e-3 && abs(o1_all(2)-o1_0_all(2)) / o1_0_all(2) >= 0.05 ) ...
            || (o1_0_all(3)>1e-3 && abs(o1_all(3)-o1_0_all(3)) / o1_0_all(3) >= 0.05 ) ...
            || (o1_0_all(1)<1e-3 && abs(o1_all(1)-o1_0_all(1)) >= 1e-2 ) ...
            || (o1_0_all(2)<1e-3 && abs(o1_all(2)-o1_0_all(2)) >= 1e-2 ) ...
            || (o1_0_all(3)<1e-3 && abs(o1_all(3)-o1_0_all(3)) >= 1e-2 )
            
        loss_type(7) = 1;
    end
    if norm( o2_all-o2_0_all ) / norm(o2_0_all) >= 0.05
        loss_type(8) = 1;
    end
    if norm(  x_after(peak_position,1:end-1) - x_after_0(peak_position_0,1:end-1)  )...
        / norm( x_after_0(peak_position_0,1:end-1) ) >= 0.05
        loss_type(9) = 1;
    end
    
end
