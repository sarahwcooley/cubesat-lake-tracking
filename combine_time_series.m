function [complete_time_series] = combine_time_series(doy,lake_mask,RE_timeseries,PS_timeseries);

%determine max area for each buffered region
    max_area = regionprops(lake_mask,'Area');
    max_area = 25*cat(1,max_area.Area); 
    
    
%obtain days of images
    
re_days = [RE_timeseries.doy];
ps_days = [PS_timeseries.doy];

for p = 1:length(RE_timeseries(1).area100)
    count = 1;
    
     for j = 1:length(doy)
     day = doy(j);
     inds_re = find(re_days == day);
     inds_ps = find(ps_days == day);
     
     for k = 1:length(inds_ps)
        area_output(count,1) = day;
        area_output(count,2) = PS_timeseries(inds_ps(k)).area100(p);
        area_output(count,3) = PS_timeseries(inds_ps(k)).area75(p);
        area_output(count,4) = PS_timeseries(inds_ps(k)).area50(p);
        area_output(count,5) = 1;
        area_output(count,6) = PS_timeseries(inds_ps(k)).NoData_percent(p);
        area_output(count,7) = PS_timeseries(inds_ps(k)).cloud_cover;
        area_output(count,8) = PS_timeseries(inds_ps(k)).perim(p);
        area_output(count,9) = PS_timeseries(inds_ps(k)).flag(p);
        area_output(count,10) = PS_timeseries(inds_ps(k)).mean_ndwi(p); 
        area_output(count,11) = PS_timeseries(inds_ps(k)).mean_nir(p); 
        area_output(count,12) = PS_timeseries(inds_ps(k)).mean_red(p); 
        area_output(count,13) = PS_timeseries(inds_ps(k)).mean_green(p); 
        area_output(count,14) = PS_timeseries(inds_ps(k)).mean_blue(p); 
        area_output(count,15) = max_area(p); 
        
        count = count+1; 
     end
     
       for k = 1:length(inds_re)
        area_output(count,1) = day;
        area_output(count,2) = RE_timeseries(inds_re(k)).area100(p);
        area_output(count,3) = RE_timeseries(inds_re(k)).area75(p);
        area_output(count,4) = RE_timeseries(inds_re(k)).area50(p);
        area_output(count,5) = 2;
        area_output(count,6) = RE_timeseries(inds_re(k)).NoData_percent(p);
        area_output(count,7) = RE_timeseries(inds_re(k)).cloud_cover;
        area_output(count,8) = RE_timeseries(inds_re(k)).perim(p);
        area_output(count,9) = RE_timeseries(inds_re(k)).flag(p);
        area_output(count,10) = RE_timeseries(inds_re(k)).mean_ndwi(p); 
        area_output(count,11) = RE_timeseries(inds_re(k)).mean_nir(p); 
        area_output(count,12) = RE_timeseries(inds_re(k)).mean_red(p); 
        area_output(count,13) = RE_timeseries(inds_re(k)).mean_green(p); 
        area_output(count,14) = RE_timeseries(inds_re(k)).mean_blue(p); 
        area_output(count,15) = max_area(p); 
       
        count = count+1; 
       end
     end
     
     complete_time_series(p).doy = area_output(:,1);
     complete_time_series(p).area100 = area_output(:,2);
     complete_time_series(p).area75 = area_output(:,3);
     complete_time_series(p).area50 = area_output(:,4);
     complete_time_series(p).type = area_output(:,5);
     complete_time_series(p).NoData = area_output(:,6);
     complete_time_series(p).cloud_cover = area_output(:,7);
     complete_time_series(p).perimeter = area_output(:,8);
     complete_time_series(p).flag = area_output(:,9);
     complete_time_series(p).mean_ndwi = area_output(:,10);
     complete_time_series(p).mean_nir = area_output(:,11);
     complete_time_series(p).mean_red = area_output(:,12);
     complete_time_series(p).mean_green = area_output(:,13);
     complete_time_series(p).mean_blue = area_output(:,14);
     complete_time_series(p).max_area = area_output(:,15);
     
    
     
     
     clear area_output 
       
end