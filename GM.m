%% generative model. setting parameters for the generation part

clear M x p

ilevel = 0;

% using default values for correlation and time constant

M(1).E.s = 1;
M(1).E.K = exp(-3);
M(1).E.dt = 1;

%% level 1

ilevel = ilevel + 1;

x1(1, 1) = 0; % time-modulation unit M
x1(2, 1) = 0; % time unit

x1(3 : 2 + Nsyl, 1) = 0; % prev
x1(3 : 2 + Nsyl, 1) = generative_model.init_prv(Nsyl); % prev

x1(3 + Nsyl : 2 + Nsyl * 2, 1) = 0; % next
x1(3 + Nsyl : 2 + Nsyl * 2, 1) = generative_model.init_nxt(Nsyl); % next

M(ilevel).x = x1;
M(ilevel).f = 'spm_F1';
M(ilevel).g = 'spm_G1';

M(ilevel).V = Vh1;
M(ilevel).W = Wh1;
M(ilevel).pE = {A_list, I};

% M(ilevel).hE = log(Vh1);
% M(ilevel).hC = 5;
% M(ilevel).gE = log(Wh1);
% M(ilevel).gC = 5;

%% level 2
ilevel = ilevel + 1;

% delta units
x2(1, 1) = inv_softplus(333, 333); % M delta
x2(2, 1)= 0;  % t delta 10

% words units
x2(3 : 2 + Nwords, 1) = 0; 

M(ilevel).x = x2;
M(ilevel).f = 'spm_F2';
M(ilevel).g = 'spm_G2';

M(ilevel).V = Vh2;
M(ilevel).W = Wh2;
% M(ilevel).hE = log(Vh2);
% M(ilevel).hC = 5;
% M(ilevel).gE = log(Wh2);
% M(ilevel).gC = 5;