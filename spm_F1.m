function dx = spm_F1(x, v, pE)
    Nsyl = (length(x) - 2)/ 2; % number of syllables

    t_delta = v(1, 1);
    ws = v(3 : end, 1);

    M = x(1, 1);
    t = x(2, 1);
    prv = x(3 : 2 + Nsyl, 1);
    nxt = x(3 + Nsyl : 2 + Nsyl * 2, 1);

    delta_trigger = generative_model.delta_trigger(t_delta);

    [dM, dt] = generative_model.dM_dt_theta(M, t, delta_trigger);

    c = generative_model.syllable_next_prev_clock(t);
    [dnxt, dprv] = generative_model.syllable_next_prev_grad(ws, pE{1}, nxt, prv, c, delta_trigger);

    %% output
    dx(1, 1) = dM;
    dx(2, 1) = dt;
    dx(3 : 2 + Nsyl, 1) = dprv;
    dx(3 + Nsyl : 2 + Nsyl * 2, 1) = dnxt;
end

