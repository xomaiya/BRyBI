function y = spm_G2(x, v, pE)
    % x(1) - time in delta-oscillations
    % x(2:) - words

    %% Inputs
    Nword = length(x) - 2; % number of words

    M_delta = x(1, 1);
	t_delta = x(2, 1);
	ws = x(3 : 2 + Nword, 1);
    
    % Calculations
    ws_prob = softmax(15 * ws); 
    
    %% output
    y(1, 1) = t_delta;
    y(2, 1) = M_delta;
    y(3 : 2 + Nword, 1) = ws_prob;
end