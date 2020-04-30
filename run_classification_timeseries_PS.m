function [PS_timeseries] = run_classification_timeseries_PS(tile_folder,files,edited_mask,image_meta_data,R_PS,info_PS)
cd(tile_folder);
cd('PlanetScope/raw');
output_folder = [tile_folder '/PlanetScope/classified'];
mkdir(output_folder);
count = 1; 
for j = 1: length(files)
    
     if image_meta_data(j).cloud_cover <= 0.2 && image_meta_data(j).illumination_elevation >= 20
    %Step 1: classify image
    [classified_image,ndwi,mean_values] = classify_image_PS(files(j).name,edited_mask,image_meta_data(j));
    
     filename_classified = [files(j).name(1:end-4) '_classified.tif'];
     filename_ndwi = [files(j).name(1:end-4) '_ndwi.tif'];
     
     %Step 2: write image
     cd(output_folder)
     geotiffwrite(filename_classified,classified_image,R_PS,'GeoKeyDirectoryTag',info_PS.GeoTIFFTags.GeoKeyDirectoryTag);
     geotiffwrite(filename_ndwi,ndwi,R_PS,'GeoKeyDirectoryTag',info_PS.GeoTIFFTags.GeoKeyDirectoryTag);
     cd(tile_folder)
     cd('PlanetScope/raw')
     
     %Step 3: calculate lake area
     
     PS_timeseries(count).doy = image_meta_data(j).doy;
     PS_timeseries(count).date = image_meta_data(j).date; 
     
     area = calculate_lake_area(edited_mask,classified_image); 
     PS_timeseries(count).area100 = 9.7656*area(:,1); %100% water 
     PS_timeseries(count).area75 = 9.7656*area(:,2);  %75% water threshold (this is what I actually use)
     PS_timeseries(count).area50 = 9.7656*area(:,3);  %fractional sum of > 50% water
     PS_timeseries(count).NoData_percent = area(:,4); 
     
     %Step 4: obtain error metrics for time series
     
     PS_timeseries(count).cloud_cover = image_meta_data(j).cloud_cover;
     PS_timeseries(count).flag = mean_values(:,7);
     PS_timeseries(count).mean_ndwi = mean_values(:,5);
     PS_timeseries(count).mean_nir = mean_values(:,4);
     PS_timeseries(count).mean_red = mean_values(:,1);
     PS_timeseries(count).mean_green = mean_values(:,2);
     PS_timeseries(count).mean_blue = mean_values(:,3);
     
     %Step 3: calculate perimeter
     
        ta = 4.42; %perimeter distance in m for planetscope
        classified_image(classified_image == 255) = 0; 
        classified_image(classified_image <=75) = 0;
        classified_image(classified_image >=75) = 1;
        cc = bwperim(classified_image);
        per = regionprops(edited_mask,cc,'PixelValues');
        
        for kk = 1:length(per)
            perim(kk,1) = sum(per(kk).PixelValues);
        end
        
        PS_timeseries(count).perim = ta*perim;
        clear perim
        
     
     count = count+1; 
     
     disp(['finished image ' files(j).name]); 
     
     end
end


     