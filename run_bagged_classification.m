function [complete_time_series_validated] = run_bagged_classification(complete_time_series,model)

for j = 1:length(complete_time_series)
       
        lake_id = j;
        scores = zeros(size(complete_time_series(lake_id).doy));
        stdevs = zeros(size(complete_time_series(lake_id).doy));
        %STEP 1: Create dataset to be validated
        
     
        validation_points(:,1) = [complete_time_series(lake_id).doy]; %doy
        validation_points(:,2) = [complete_time_series(lake_id).median_area]; %median lake area
        validation_points(:,3) = [complete_time_series(lake_id).cloud_cover]; %cloud cover
        validation_points(:,4) = [complete_time_series(lake_id).type]; %type
        validation_points(:,5) = [complete_time_series(lake_id).percent_median]; %percent change from the median
        validation_points(:,6) = [complete_time_series(lake_id).median_5day]; %percent change from 5day median
        validation_points(:,7) = [complete_time_series(lake_id).median_10day]; %percent change from 10day median
        validation_points(:,8) = [complete_time_series(lake_id).NoData]; %no data percent
        validation_points(:,9) = [complete_time_series(lake_id).max_area_percent]; %percent of max area
        validation_points(:,10) = [complete_time_series(lake_id).std]; %std
        validation_points(:,11) = [complete_time_series(lake_id).std_5day]; %std 5 day
        validation_points(:,12) = [complete_time_series(lake_id).std_10day]; %std 10 day
        validation_points(:,13) = [complete_time_series(lake_id).perim_5day]; %perim 5 day
        validation_points(:,14) = [complete_time_series(lake_id).perim_10day]; %perim 10 day
        
        %STEP 2: remove bad points
        
        ind_bad1 = (validation_points(:,8)) > 10;
        ind_bad2 = (validation_points(:,9)) > 95;
        ind_bad = ind_bad1 + ind_bad2;
        
        validation_points(ind_bad == 1,:) = [];
        
        %STEP 3: Machine Learn ! ! !
        if isempty(validation_points) == 0
        [validation_data,scores,stdevs] = predict(model,validation_points);
        validation_data = str2num(cell2mat(validation_data));
        else
            validation_data = 0;
        end
            
        %STEP 4: Add data points, convert
        
        
        output_validation = zeros(size(ind_bad));
        if sum(ind_bad == 0) == length(validation_data) 
            output_validation(ind_bad == 0) = validation_data;
        end
        complete_time_series(j).valid = output_validation;
        complete_time_series(j).valid_scores = scores;
        complete_time_series(j).valid_stdevs = stdevs; 
        clear validation_points 
end

complete_time_series_validated = complete_time_series;
end

    