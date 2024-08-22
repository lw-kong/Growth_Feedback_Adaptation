function dxdt = eq_Hills_GFB_2NodeTS_NoNoise(~,x,input,k_node,k_link,k_growth,J)
% for the univeral cases
% Noise is an Ornstein-Uhlenbeck process. Please refer to the Star*Methods in 2019 Cell System 9, 1-15, page e2
% output   x(end-1)
% ln(N)    x(end)

% k_node  N*2
% k_linkfull 3*3
%       input -> A
%       B -> A
%       A -> B

dxdt = zeros(2+1,1);

dxdt(end) = k_growth / ((x(1)+x(2))/J+1); % d( lnN )/dt

dxdt(1) = k_node(1,1) *  1/( 1 + ...
    ( x(2)/k_link(2,3) * (1+k_link(1,3)*input/x(2))^(-k_link(1,2)) )^k_link(2,2) ) ...
    - (k_node(1,2)+dxdt(end)) * x(1);
dxdt(2) = k_node(2,1) * 1/( 1 + (x(1)/k_link(3,3))^k_link(3,2) ) ...
    - (k_node(2,2)+dxdt(end)) * x(2); % output

                

                
end

