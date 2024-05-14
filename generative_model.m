classdef generative_model
    properties (Constant)
        BEST_T_ = 175
        BEST_T_DELTA = 600

        VEL_DELTA = 2 * pi / generative_model.BEST_T_DELTA;
        T_SPEED = 1 / generative_model.BEST_T_;
        LAMBDA = 0;
        KAPPA_S = 0.15;

        K_DELTA = 0.2;  % standard
%        K_DELTA = 0;   % free-delta
        K_THETA = 1;
    end

    methods (Static)
        function [dM, dt] = dM_dt_theta(M_theta, t_theta, delta_trigger)
            dM = 0;  %  - delta_trigger * M;  % standard
%            dM = -generative_model.K_THETA * (M_theta - inv_softplus(500, 500))^3;  % no-delta

            dt = log(1 + exp(M_theta)) - 10 * delta_trigger * t_theta;
        end

        function [dM, dt] = dM_dt_delta(M_delta, t_delta)
            M_diff = M_delta - inv_softplus(500, 500);
            dM = -generative_model.K_DELTA * M_diff ^ 3;
            dt = softplus(M_delta);
        end

        function trigger = delta_trigger(t_delta)
            A = 0.03;
            B = 100;
        %    trigger = 2 * min(exp(B * (mod(t_delta / generative_model.BEST_T_DELTA, 1) - (1 - A))), 1);

            delta_waves = zeros(100, 1);
            for i = 1 : 100
                delta_waves(i, 1) = cos(generative_model.VEL_DELTA * t_delta - (i - 1) * 2 * pi / 100); %  + pi / 16);
            end
            trigger = softmax(100 * delta_waves);
            trigger = trigger(1);
        end


        function clock = syllable_next_prev_clock(t)
%            if sin(t * generative_model.T_SPEED * 2 * pi / 4 - pi / 4) ^ 2 > cos(t * generative_model.T_SPEED * 2 * pi / 4 - pi / 4) ^ 2
%                clock = 1.;
%            else
%                clock = 0.;
%            end

            s_ = 30 * sin(t * generative_model.T_SPEED * 2 * pi / 4 - pi / 4 + pi / 64) ^ 2;
            c_ = 30 * cos(t * generative_model.T_SPEED * 2 * pi / 4 - pi / 4 + pi / 64) ^ 2;
            clock = exp(s_) / (exp(s_) + exp(c_));
        end

        function nxt = init_nxt(n_syls)
%            nxt = zeros(n_syls, 1);  % no-delta
            nxt = eye(n_syls);      % standard
            nxt = nxt(:, end);      % standard
        end

        function prv = init_prv(n_syls)
%            prv = zeros(n_syls, 1);  % no-delta
            prv = eye(n_syls);      % standard
            prv = prv(:, end);      % standard
        end

        function grad = dsyl(clock, our, opposite, our0, delta_trigger, A, A_lambda)
            grad = generative_model.KAPPA_S * (A' * opposite / vecnorm(opposite) - our) * (1 - clock) - 4 * delta_trigger * (our - our0);
            grad = grad + generative_model.LAMBDA * (-our + our .* (A_lambda' * ones(size(our))));
%            grad = grad - 10 * delta_trigger * (our - our0);
        end

        function [dnxt, dprv] = syllable_next_prev_grad(word_probs, word_matrices, nxt, prv, clock, delta_trigger)
%            dnxt = -clock * nxt;       % no-delta
%            dprv = -(1 - clock) * prv; % no-delta
%            return                     % no-delta

            A = genR2(word_probs, word_matrices);
            A_lambda = genR3(word_probs, word_matrices);

            nxt0 = generative_model.init_nxt(length(nxt));
            prv0 = generative_model.init_prv(length(prv));

            dnxt = generative_model.dsyl(clock, nxt, prv, nxt0, delta_trigger, A, A_lambda);
            dprv = generative_model.dsyl(1 - clock, prv, nxt, prv0, delta_trigger, A, A_lambda);
        end

        function gu = gamma_units(t)
            gu = zeros(8, 1);
            for i = 1 : 8
                gu(i, 1) = cos(2 * pi * (generative_model.T_SPEED * t - (i - 1) / 8) - 0.3);
            end
            gu = softmax(30 * gu);
        end

        function syl_probs = syllable_probabilities(clock, nxt, prv)
            syls = (1 - clock) * nxt + clock * prv;
            syl_probs = softmax(10 * syls);
        end

        function spectra = generate_spectra(syl_probabilities, gamma_units, I)
            pp = 0;

            for i = 1 : 1 : length(syl_probabilities)
                pp = pp + syl_probabilities(i) * I{i};
            end

            spectra = pp * gamma_units;
        end
    end
end
