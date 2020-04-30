function [classified_image,ndwi,mean_values] = classify_image_PS(filename,lake_mask,image_meta_data)
%calculates the NDWI for each image and the classifies it using the
%non-binary histogram thresholding method
     image = imread(filename);
     image = double(image); 
     b2 = image_meta_data.b2_TOA*image(:,:,2);
     b4 = image_meta_data.b4_TOA*image(:,:,4); 
     b1 = image_meta_data.b1_TOA*image(:,:,1);
     b3 = image_meta_data.b3_TOA*image(:,:,3); 
     
     
     ndwi = mat2gray((b2 - b4)./(b2 + b4));
     
     %pixels = regionprops(lake_mask,NDWI,'PixelValues');
     
    
     ll = lake_mask; 
     lake_mask(ndwi == 1) = 0;
     
     
     ndwi_data = ndwi(lake_mask >=1);
     
     [WL,LL,flag] = new_inflection_points(ndwi_data);  

     classified_image = (LL - ndwi)*100./(LL-WL);
     classified_image(classified_image>100)=100;
     classified_image(classified_image<0)=0;
     classified_image = uint8(classified_image);
     classified_image(ndwi == 1) = 255; 
     
     ndwi = 254*ndwi;
     ndwi = uint8(ndwi);
     ndwi(classified_image == 255) = 255;
     
     
     mm = regionprops(ll,b1,'MeanIntensity');
     mean_values(:,1) = cat(1,mm.MeanIntensity);
     mm = regionprops(ll,b2,'MeanIntensity');
     mean_values(:,2) = cat(1,mm.MeanIntensity);
     mm = regionprops(ll,b3,'MeanIntensity');
     mean_values(:,3) = cat(1,mm.MeanIntensity);
     mm = regionprops(ll,b4,'MeanIntensity');
     mean_values(:,4) = cat(1,mm.MeanIntensity);
     mm = regionprops(ll,ndwi,'MeanIntensity');
     mean_values(:,5) = cat(1,mm.MeanIntensity);
     mm = regionprops(ll,classified_image,'MeanIntensity');
     mean_values(:,6) = cat(1,mm.MeanIntensity);
     mean_values(:,7) = flag*ones(length(mean_values(:,6)),1); 
     
     
end
