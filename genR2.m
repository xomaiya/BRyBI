function R = genR2(ws, A_list)
    [Nwords, Nsyl, ~] = size(A_list);
    R = zeros(Nsyl, Nsyl);
    
    for i = 1 : Nwords
       A_w = ws(i) * squeeze(A_list(i, :, :));
       R = R + A_w;
    end
    
end
