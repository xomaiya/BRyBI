%% main file

currentFold = pwd;

input = fullfile(currentFold, '../data/dataset.0/cs_speed/2.0/DR3_FLAC0_SX271.mat')
output = fullfile(currentFold, '../data/DR3_FLAC0_SX271.mat')

[parent_dir, ~, ~] = fileparts(output);
mkdir(parent_dir);

sent_data = importdata(input);
DEM = DoInference(sent_data);
parsave(output, DEM);
