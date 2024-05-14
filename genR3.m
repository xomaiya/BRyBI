function R = genR3(ws, A_list)
    [~, Nsyl, ~] = size(A_list);
    R = eye(Nsyl, Nsyl);
    
    
    [max_val, max_ind] = max(ws);

    if max_val > 0.86
        R = squeeze(A_list(max_ind, :, :));
    end
end
