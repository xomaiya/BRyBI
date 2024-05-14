function res = inv_softplus(T_, T_new)
    
    res = log(exp(T_ / T_new) - 1);

end