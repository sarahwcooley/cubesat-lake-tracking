%Classification and lake metric processing

%load the random forest classification model created from the manually
%validated time series
cd('\\files.brown.edu\Research\IBES_SmithLab\scooley1\Planet\Bering_Peninsula\');
%load complete_validation_dataset_jun18
load model_jun18


 for i = 1:length(tiles)
    tic
    
    tile_str = num2str(tiles(i));
    grid_str = grids{i};
    tile_folder = ['\\files.brown.edu\Research\IBES_SmithLab\Shared\AKGRDs\' grid_str '\' tile_str '\2017\'];
    cd(tile_folder);
    load complete_time_series_Jun18
    
    %STEP 1: Calculate Validation Metrics
    
    [complete_time_series] = calculate_validation_metrics(complete_time_series);
    
    %STEP 2: Run Validation 
   
    [complete_time_series_validated] = run_bagged_classification(complete_time_series,model);
        save('complete_time_series_Jun18.mat','complete_time_series','complete_time_series_validated');

    %STEP 3: Filter Validated Time Series
    
    [final_time_series] = filter_validated_time_series(complete_time_series_validated);
    
    
    %STEP 4: Calculate Metrics 
    
    [lake_metrics] = calculate_lake_metrics(final_time_series);
    
    %STEP 5: Save
    
    save('processed_time_series_jun18.mat','complete_time_series','final_time_series','lake_metrics');
    
    disp(['Finished Tile ' tile_str]);
    
    toc
    

 end
 




 