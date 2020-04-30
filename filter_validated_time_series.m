function [final_time_series] = filter_validated_time_series(complete_time_series_validated)

for i = 1:length(complete_time_series_validated)
    
    lake_area = complete_time_series_validated(i).area75;
    doy = complete_time_series_validated(i).doy;
    validation = complete_time_series_validated(i).valid;
    
    %remove invalid days
    
    lake_area(validation ~= 1) = [];
    doy(validation ~= 1) = [];
    
    %select best data point per day based on 5 day median
    
    uni_doy = unique(doy);
    uni_lake_area = zeros(size(uni_doy));
    area_flt = medfilt1(lake_area,5,'truncate');
    
    for jj = 1:length(uni_doy)
        ind = find(doy == uni_doy(jj));
        if length(ind) > 1
            la = lake_area(ind);
           difference = la - area_flt(ind);
           [~,ind1] = min(abs(difference));
           uni_lake_area(jj) = la(ind1);
        else
            uni_lake_area(jj) = lake_area(ind);
        end
    end
    
    %run 5 day median filter
    uni_lake_area_filtered = medfilt1(uni_lake_area,5,'truncate');
    
    
    final_time_series(i).lake_id = i;
    final_time_series(i).doy = uni_doy;
    final_time_series(i).lake_area_unfilt = uni_lake_area;
    final_time_series(i).lake_area_filt = uni_lake_area_filtered; 
end


    
    
    
    