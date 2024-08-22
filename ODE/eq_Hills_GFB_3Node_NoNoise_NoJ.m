
function dxdt = eq_Hills_GFB_3Node_NoNoise_NoJ(~,x,input,k_node,k_linkfull,k_growth)
% for the univeral cases
% Noise is an Ornstein-Uhlenbeck process. Please refer to the Star*Methods in 2019 Cell System 9, 1-15, page e2
% output   x(end-1)
% ln(N)    x(end)

% k_node  N*2
% k_linkfull (N+1)*(N+1)
%            (n_i+1) --> (n_j+1),  n_i,n_j = 1,2,3...N, and 0 for input

dxdt = zeros(3+1,1);

dxdt(end) = k_growth ; % d( lnN )/dt

dxdt(1) = k_node(1,1) * func_Hills(input,k_linkfull(1,2,:)) * ...
                    func_Hills(x(1),k_linkfull(2,2,:)) * func_Hills(x(2),k_linkfull(3,2,:)) * func_Hills(x(3),k_linkfull(4,2,:)) - (k_node(1,2)+dxdt(end)) * x(1);
dxdt(2) = k_node(2,1) * ...
                    func_Hills(x(1),k_linkfull(2,3,:)) * func_Hills(x(2),k_linkfull(3,3,:)) * func_Hills(x(3),k_linkfull(4,3,:)) - (k_node(2,2)+dxdt(end)) * x(2);
dxdt(3) = k_node(3,1) * ...
                    func_Hills(x(1),k_linkfull(2,4,:)) * func_Hills(x(2),k_linkfull(3,4,:)) * func_Hills(x(3),k_linkfull(4,4,:)) - (k_node(3,2)+dxdt(end)) * x(3); % output

end

