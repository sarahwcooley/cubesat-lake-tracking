function [file_names] = combine_file_names(doy,RE_timeseries,PS_timeseries,files_PS_classified,files_PS_ndwi,files_RE_classified,files_RE_ndwi)

re_days = [RE_timeseries.doy];
ps_days = [PS_timeseries.doy];

count = 1; 
for j = 1:length(doy)
    
    day = doy(j);
    inds_re = find(re_days == day);
    inds_ps = find(ps_days == day); 
  
    for k = 1:length(inds_ps) 
        file_output(count).c_name = files_PS_classified(inds_ps(k)).name;
        file_output(count).n_name = files_PS_ndwi(inds_ps(k)).name;
        count = count +1; 
    end
    
    for k = 1:length(inds_re)
        file_output(count).c_name = files_RE_classified(inds_re(k)).name;
        file_output(count).n_name = files_RE_ndwi(inds_re(k)).name;
        count = count+1;
    end
end
    
    file_names = file_output; 
end