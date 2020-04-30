%Compile Validation Data to use for Machine Learning
count = 1; 

for i = 1:length(tiles)
    
    tile_str = num2str(tiles(p));
    tile_folder = ['\\files.brown.edu\Research\IBES_SmithLab\Shared\AKGRDs\' tile_str '\2017\'];
    cd(tile_folder);
    load complete_time_series_jun18
    validation_filenames = dir('*validation_*.mat');
    
    %Step 1: Load Validation Data
    
    for p = 1:length(validation_filenames)
        
        complete_validation_dataset(count).validation_id = count; %validation ID number
        complete_validation_dataset(count).tile = tiles(i);
        
        %get lake_id
        tl = length(validation_filenames(p).name);
        
        if tl == 16
            lake_id = str2num(validation_filenames(p).name(end-4));
        end
        if tl == 17
            lake_id = str2num(validation_filenames(p).name(end-5:end-4));
        end
        if tl == 18
            lake_id = str2num(validation_filenames(p).name(end-6:end-4));
        end
        if tl == 19
            lake_id = str2num(validation_filenames(p).name(end-7:end-4));
        end
        
        complete_validation_dataset(count).lake_id = lake_id;
        
        %load time series
        load(validation_filenames(p).name);
        complete_validation_dataset(count).validation_data = validation;
        
    %Step 2: calculate validation data
        
        complete_time_series = calculate_validation_metrics(complete_time_series);
        save('complete_time_series_jun18.mat','complete_time_series');
        
    %Step 3: Organize validation data
    
        complete_validation_dataset(count).doy = complete_time_series(lake_id).doy;
        complete_validation_dataset(count).area75 = complete_time_series(lake_id).area75;
        complete_validation_dataset(count).type = complete_time_series(lake_id).type;
        complete_validation_dataset(count).no_data = complete_time_series(lake_id).NoData;
        complete_validation_dataset(count).cloud_cover = complete_time_series(lake_id).cloud_cover;
        complete_validation_dataset(count).flag = complete_time_series(lake_id).flag;
        complete_validation_dataset(count).max_area = complete_time_series(lake_id).max_area;
        complete_validation_dataset(count).median_area = complete_time_series(lake_id).median_area;
        complete_validation_dataset(count).percent_median = complete_time_series(lake_id).percent_median; %percent of overall median area
        complete_validation_dataset(count).median_5day = complete_time_series(lake_id).median_5day; %percent of 5 day median
        complete_validation_dataset(count).median_10day = complete_time_series(lake_id).median_10day; %percent of 10 day median
        complete_validation_dataset(count).std = complete_time_series(lake_id).std; %standard deviation
        complete_validation_dataset(count).std_5day = complete_time_series(lake_id).std_5day; %standard deviation
        complete_validation_dataset(count).std_10day = complete_time_series(lake_id).std_10day; %10 day standard deviation
        complete_validation_dataset(count).perim_5day = complete_time_series(lake_id).perim_5day; %perimeter percent of 5-day median
        complete_validation_dataset(count).perim_10day = complete_time_series(lake_id).perim_10day; %perimeter percent of 10 day median
        complete_validation_dataset(count).max_area_percent = complete_time_series(lake_id).max_area_percent; %perimeter percent of 10 day median
        
    %Step 4: Specific metrics for validation
    
        area = complete_time_series(lake_id).area75;
        doy = complete_time_series(lake_id).doy;
        area = area(validation >=1);
        doy = doy(validation >=1);
    
        
        complete_validation_dataset(count).valid_mean_area = mean(area); %mean area of valid lakes
        complete_validation_dataset(count).valid_range = max(area) - min(area); %mean area of valid lakes
        complete_validation_dataset(count).valid_percent_range = (max(area) - min(area))./mean(area); %mean area of valid lakes
        
        count = count + 1;
    end
    
    
end

save('complete_validation_dataset.mat','complete_validation_dataset');


        
        
        
        
        
        
        