function dxdt = eq_Hills_GFB_1NodeSA_NoNoise_NoJ(~,x,input,k_node,k_link,k_growth)
% for the univeral cases
% Noise is an Ornstein-Uhlenbeck process. Please refer to the Star*Methods in 2019 Cell System 9, 1-15, page e2
% output   x(end-1)
% ln(N)    x(end)

% k_link(:,3) not k^n, but k itself

sa = 1/(1+(k_link(1,3)/input)^k_link(1,2)); % activate
dxdt = k_node(1,1) *  1/( 1 +  (k_link(2,3)/x(1)/sa)^k_link(2,2) ) ...
    - (k_node(1,2)+k_growth) * x(1); % activate by itself


                
                
end

