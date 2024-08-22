function f = func_Hills(a,k)
% ko k1 n s
if k(1) == 0
    f = 1;
elseif k(1) == 1 % activate
    f = a^k(2) / ( k(3) + a^k(2) );
elseif k(1) == -1 
    f = k(3)   / ( k(3) + a^k(2) );
end

end
