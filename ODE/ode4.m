function [t,y] = ode4(f,t,y0)
%RK-4 solver for constant step length

y = zeros(length(y0),length(t));
y(:,1) = y0;

h = t(2) - t(1); % step length

for x_i = 1: length(t)-1
    k1 = f( t(x_i), y(:,x_i) );
    k2 = f( t(x_i) + h/2, y(:,x_i) + h/2 * k1 );
    k3 = f( t(x_i) + h/2, y(:,x_i) + h/2 * k2 );
    k4 = f( t(x_i) + h, y(:,x_i) + h * k3 );
    y(:,x_i + 1) = y(:,x_i) + h/6 * (k1 + 2*k2 + 2*k3 + k4);
end

y = y';

end

