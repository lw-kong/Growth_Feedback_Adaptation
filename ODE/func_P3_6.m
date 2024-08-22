function [adaptation_error, peak_height, relative_response] = ...
    func_P3_6(x_all,x_after,t_switch,t_step,t_unit,equili)

if equili <= 0
    fprintf('equili error') % supposed to if-out this possibility in the main program
else    
    o1 = mean( x_all( t_switch/t_step-t_unit/t_step: t_switch/t_step-1,end-1) );
    o2 = mean( x_all( end-t_unit/t_step:end,end-1) );
    peak_height = max(abs(x_after(:,end-1)-o1));    
    

    relative_response = peak_height/o1;
    adaptation_error = abs( (o2-o1)/o1 );
    
    
end
