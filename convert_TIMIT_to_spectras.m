%% Util function from Hovsepyan, Sevada, Itsaso Olasagasti, and Anne-Lise Giraud. "Combining predictive coding and neural oscillations enables online syllable recognition in natural speech." Nature communications 11.1 (2020): 3117. 

function convert_TIMIT_to_spectras(TIMIT_path, output_path)
    if exist(output_path, 'dir') ~= 7
        mkdir(output_path);
    end
    
    for i = 1:8
        dr_name = sprintf('DR%d', i);
        dr_folder = fullfile(TIMIT_path, dr_name);

        speakers = dir(dr_folder);
        for speaker_i = 1:length(speakers)
            speaker_name = speakers(speaker_i).name;
            speaker_folder = fullfile(dr_folder, speaker_name);

            sentences = dir(fullfile(speaker_folder, '*.WAV'));
            for sentence_i = 1:length(sentences)
                sentence_name = sentences(sentence_i).name(1:end - 4);
                
                audio_path = fullfile(speaker_folder, sentences(sentence_i).name);
                aud_sptg = get_aud_spectrogram(audio_path);

                output_file_name = fullfile(output_path, sprintf("%s_%s_%s.mat", dr_name, speaker_name, sentence_name));
                disp(output_file_name);
                save(output_file_name, 'aud_sptg');
            end
        end
    end
end

%% st_filter_Hyafil:sent_ID, addr
function aud_sptg = get_aud_spectrogram(file_path)
    % in this case we have the output duration as ms, as well as timing

    %% load auditory toolbox - the address should be added to the path beforehand
    loadload;

    if ~exist('paras', 'var'), paras = [8 8 -2 -1]; end

    paras(1) = 1;
    paras(2) = 8;
    paras(3) = -2;
    paras(4) = 0;

    %% loading audio file and calculating the spectrogram
    [x_data, fs] = audioread(file_path);
    x1 = unitseq(x_data);
    y = wav2aud(x1, paras);

    tf_full = y';
    M = max(max(tf_full));
    m = min(min(tf_full));
    tf_full_norm = (tf_full - m)/(M-m);

    aud_sptg = tf_full_norm;
end
