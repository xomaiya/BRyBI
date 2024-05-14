function retvalue = run_for_dataset(dataset_path, output_path)
    dataset_path = get_absolute_path(dataset_path);

%    if exist(output_path, 'dir') ~= 7
%        mkdir(output_path);
%    else
%        fprintf('Output foulder "%s" already exists.\n', output_path)
%        retvalue = 1;
%        return;
%    end

    sentences = dir(fullfile(dataset_path, '**/*.mat'));
    fprintf('Found %d sentences to process\n', size(sentences, 1));
    order = randperm(length(sentences));

    initialize_parpool();

    parfor i = 1:length(order)
%    for i = 1:length(order)
        input_file_name = fullfile(sentences(order(i)).folder, sentences(order(i)).name);
        assert(startsWith(input_file_name, dataset_path));
        relativePath = input_file_name(length(dataset_path) + 2:end);
        output_file_name = fullfile(output_path, relativePath);

        if exist(output_file_name, 'file') == 2
            fprintf('Output file "%s" already exists. Skipping\n', output_file_name);
            continue
        end

        fprintf('Processing "%s"\n', input_file_name);

        sentence_data = importdata(input_file_name);
        DEM = DoInference(sentence_data);

        fprintf('Finished DEM. Saving results for "%s" to "%s"\n', input_file_name, output_file_name);
        save_DEM_result(DEM, output_file_name);
    end

    retvalue = 0;
end


function initialize_parpool()
    rng('shuffle');
    random_folder_name = char(randi([65 65 + 25], 1, 32));
    parpool_folder_path = sprintf("%s/matlab_sucks/%s", getenv('HOME'), random_folder_name);
    disp(sprintf('Folder for parpool: "%s"', parpool_folder_path));
    mkdir(parpool_folder_path);

    cluster = parcluster('Processes');
    cluster.JobStorageLocation = parpool_folder_path;

    numcores = feature('numcores');
    parpool(cluster, numcores / 1);
    pctRunOnAll maxNumCompThreads(1);
end


function save_DEM_result(dem_result, path)
    [folder, name] = fileparts(path);
    if exist(folder, 'dir') ~= 7
        mkdir(folder);
    end
    parsave(path, dem_result);
end


function abs_path = get_absolute_path(path)
    ret = dir(path);
    abs_path = ret(1).folder;
end
