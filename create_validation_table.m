function [validation_table,validation_matrix] = create_validation_table(complete_validation_dataset) 


for i = 1:length(complete_validation_dataset) 
        
        validation_data = complete_validation_dataset(i).validation_data;
        lake_id = complete_validation_dataset(i).lake_id; 
        validation_points = zeros(length(validation_data),19);
        validation_data(validation_data == -1) = 0;
        validation_data(validation_data > 1) = 1; 
        median_10 = [complete_validation_dataset(i).median_10day];
        validation_data_edited = validation_data;
        validation_data_edited(abs(median_10) < 3) = 1;
        
        if complete_validation_dataset(i).valid_mean_area > 10000 
        
        %create validation points 
        validation_points(:,1) = complete_validation_dataset(i).tile*ones(size(validation_data)); %tile name
        validation_points(:,2) = lake_id * ones(size(validation_data)); %lake id
        validation_points(:,3) = [complete_validation_dataset(i).doy]; %doy
        validation_points(:,4) = [complete_validation_dataset(i).area75]; %lake area
        validation_points(:,5) = [complete_validation_dataset(i).median_area]; %median lake area
        validation_points(:,6) = [complete_validation_dataset(i).cloud_cover]; %cloud cover
        validation_points(:,7) = [complete_validation_dataset(i).type]; %type
        validation_points(:,8) = [complete_validation_dataset(i).percent_median]; %percent change from the median
        validation_points(:,9) = [complete_validation_dataset(i).median_5day]; %percent change from 5day median
        validation_points(:,10) = [complete_validation_dataset(i).median_10day]; %percent change from 10day median
        validation_points(:,11) = [complete_validation_dataset(i).no_data]; %no data percent
        validation_points(:,12) = [complete_validation_dataset(i).max_area_percent]; %percent of max area
        validation_points(:,13) = [complete_validation_dataset(i).std]; %std
        validation_points(:,14) = [complete_validation_dataset(i).std_5day]; %std 5 day
        validation_points(:,15) = [complete_validation_dataset(i).std_10day]; %std 10 day
        validation_points(:,16) = [complete_validation_dataset(i).perim_5day]; %perim 5 day
        validation_points(:,17) = [complete_validation_dataset(i).perim_10day]; %perim 10 day
        validation_points(:,18) = validation_data;
        validation_points(:,19) = validation_data_edited;
        
        if i == 1 
        validation_matrix = validation_points;
        else
        validation_matrix = cat(1,validation_matrix,validation_points);
        end
        
        end
end


%remove immediately removable lakes
yf = validation_matrix; 
no_data = yf(:,11);
yf(no_data >= 10,:) = [];
pmax = yf(:,12);
yf(pmax >= 95,:) = [];

yf(isnan(yf) == 1) = -100;
yf(isinf(yf) == 1) = -100;

ov = yf;
        
validation_table = table(ov(:,1),ov(:,2),ov(:,3),ov(:,4),ov(:,5),ov(:,6),ov(:,7),...
    ov(:,8),ov(:,9),ov(:,10),ov(:,11),ov(:,12),ov(:,13),ov(:,14),ov(:,15),ov(:,16),ov(:,17),...
    ov(:,18),ov(:,19),'VariableNames',{'Tile','Lake_ID','DOY','Area','Med_Area',...
    'Cloud_Cover','Type','Per_Median','Per_5day','Per_10day','NoData','Per_Max','Std',...
    'Std_5day','Std_10day','Perim_5day','Perim_10day','Validation','Validation_Edited'});

end
