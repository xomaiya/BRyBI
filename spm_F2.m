function dx = spm_F2(x, v, pE)
    %% Inputs
    Nword = length(x) - 2; % number of words

    M_delta = x(1, 1);
	t_delta = x(2, 1);
	ws = x(3 : 2 + Nword, 1);

    %% Calculations
    trg_delta = generative_model.delta_trigger(t_delta);
    [dM_delta, dt_delta] = generative_model.dM_dt_delta(M_delta, t_delta);
	dw = -10 * trg_delta * ws;

	%% Outputs
	dx(1, 1) = dM_delta;
	dx(2, 1) = dt_delta;
	dx(3:2 + Nword, 1) = dw;
end