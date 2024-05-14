function rDEM = DoInference(sent_data)
% number of frequency channels
N1 = 6;

I = sent_data.P_all; % load syllable parameters - stored spectrotemporal patterns
A_list = sent_data.word_matrix; 
Y0 = sent_data.aud_sptg; % load frequency channel dynamics
Y0(7, 1:end) = sent_data.slow_amod; % load M
Y0(8, 1:end) = sent_data.M_delta; % load M

Y = Y0;

clear Y0
Nsyl = length(I);
[Nwords, ~, ~] = size(A_list); 

%% setting precisions

%% level 1

% hidden states
Wh1(1, 1) = exp(7); % M
Wh1(2, 1) = exp(8); % time unit 
Wh1(3 : 2 + Nsyl,  1) = exp(8); % prev            % standard
Wh1(3 + Nsyl: 2 + Nsyl * 2,  1) = exp(8); % next  % standard
%Wh1(3 : 2 + Nsyl,  1) = exp(1);                  % for no-delta
%Wh1(3 + Nsyl: 2 + Nsyl * 2,  1) = exp(1);        % for no-delta

% causal states
Vh1(1: N1, 1) = exp(5);  % spectrogram 4
Vh1(N1 + 1, 1) = exp(10); % M
Vh1(N1 + 2, 1) = exp(8); % M_delta

%% level 2

% hidden states
Wh2(1, 1) = exp(10); % M_delta
Wh2(2, 1) = exp(15); % t_delta
Wh2(3: 2 + Nwords,  1) = exp(1); % words units 

% causal states
Vh2(1, 1) = exp(10); % t_delta
Vh2(2, 1) = exp(9); % M_delta 5
Vh2(3: 2 + Nwords, 1) = exp(3); % words 3
 
%% model choosing
GM;

%% run DEM

DEM.Y = Y;
DEM.M = M;

DEM = spm_DEM(DEM);
close all

%% getting the output
rDEM = DEM;

end
