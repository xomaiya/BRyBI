function y = spm_G1(x, v, pE)
    % syllable number - number of all hidden states minus
    % the number of hidden states that not correspond to syllable units
    % the number of those units is sentence-independent
    % the number of syllable units is variable
    % x(1) - time-modultation M_theta
    % x(2) - time tau_theta
    % x(3:end) - syllables s (prev, next)

    %% Inputs
    Nsyl = (length(x) - 2) / 2;

    M = x(1, 1);
    t = x(2, 1);
    prv = x(3 : 2 + Nsyl, 1);
    nxt = x(3 + Nsyl : 2 + Nsyl * 2, 1);

    M_delta = v(2, 1);

    %% Calculations
    gu = generative_model.gamma_units(t);
    c = generative_model.syllable_next_prev_clock(t);
    syls = generative_model.syllable_probabilities(c, nxt, prv);
    spectra = generative_model.generate_spectra(syls, gu, pE{2});

    %% Outputs
    y(1:6, 1) = spectra;
    y(7, 1) = M;
    y(8, 1) = M_delta;
end