function [RE_timeseries] = run_classification_timeseries_RE(tile_folder,files,edited_mask,image_meta_data,R_RE,info_RE)
cd(tile_folder);
cd('RapidEye/raw');
output_folder = [tile_folder '/RapidEye/classified'];
mkdir(output_folder);
count = 1; 
for j = 1:length(files)
    
    if image_meta_data(j).cloud_cover <= 20 && image_meta_data(j).illumination_elevation > 20
    %Step 1: classify image
    [classified_image,ndwi,mean_values] = classify_image_RE(files(j).name,edited_mask,image_meta_data(j));
    
     filename_classified = [files(j).name(1:end-4) '_classified.tif'];
     filename_ndwi = [files(j).name(1:end-4) '_ndwi.tif'];
     
     %Step 2: write image
     cd(output_folder)
     geotiffwrite(filename_classified,classified_image,R_RE,'GeoKeyDirectoryTag',info_RE.GeoTIFFTags.GeoKeyDirectoryTag);
     geotiffwrite(filename_ndwi,ndwi,R_RE,'GeoKeyDirectoryTag',info_RE.GeoTIFFTags.GeoKeyDirectoryTag);
     cd(tile_folder)
     cd('RapidEye/raw');
     
     %Step 3: calculate lake area
     
     RE_timeseries(count).doy = image_meta_data(j).doy;
     RE_timeseries(count).date = image_meta_data(j).date; 
     
     area = calculate_lake_area(edited_mask,classified_image); 
     RE_timeseries(count).area100 = 25*area(:,1);
     RE_timeseries(count).area75 = 25*area(:,2);
     RE_timeseries(count).area50 = 25*area(:,3);
     RE_timeseries(count).NoData_percent = area(:,4); 
     
     %Step 4: obtain error metrics for time series
     
     RE_timeseries(count).cloud_cover = image_meta_data(j).cloud_cover;
     RE_timeseries(count).flag = mean_values(:,7);
     RE_timeseries(count).mean_ndwi = mean_values(:,5);
     RE_timeseries(count).mean_nir = mean_values(:,4);
     RE_timeseries(count).mean_red = mean_values(:,1);
     RE_timeseries(count).mean_green = mean_values(:,2);
     RE_timeseries(count).mean_blue = mean_values(:,3);
     
      %Step 5: calculate perimeter
        ta = 7.07;
        classified_image(classified_image == 255) = 0; 
        classified_image(classified_image <=75) = 0;
        classified_image(classified_image >=75) = 1;
        cc = bwperim(classified_image);
        per = regionprops(edited_mask,cc,'PixelValues');
        
        for kk = 1:length(per)
            perim(kk,1) = sum(per(kk).PixelValues);
        end
        
        RE_timeseries(count).perim = ta*perim;
        clear perim
     
     count = count+1; 
     
     disp(['finished image ' files(j).name]); 
    end
end
