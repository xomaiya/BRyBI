function retvalue = run_for_sentence(dataset_root, results_root, sentence_name)
    try
        dataset_root = get_absolute_path(dataset_root);

        sentence_glob = sprintf('**/%s', sentence_name);
        sentences = dir(fullfile(dataset_root, sentence_glob));
        fprintf('Found %d sentences to process\n', size(sentences, 1));

        rng('shuffle');
        order = randperm(length(sentences));

        for i = 1:length(order)
            input_file_name = fullfile(sentences(order(i)).folder, sentences(order(i)).name);
            assert(startsWith(input_file_name, dataset_root));
            relativePath = input_file_name(length(dataset_root) + 2:end);
            output_file_name = fullfile(results_root, relativePath);

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
        return;
    catch exception
        % If an error occurs, display the error message
        disp(['Error: ' exception.message])
        retvalue = 1;
        return;
    end
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
