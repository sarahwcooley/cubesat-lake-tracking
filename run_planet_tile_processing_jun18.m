%Planet imagery lake time series detection workflow
%Script written by S. Cooley
%requires reference matrix and initial mask for each tile to already be created
ind = 1; 

for i = 1:length(pl_tiles) %loops through tiles
   tic 
   if re_exist(i) == 1
   tile_str = num2str(pl_tiles(i));
   tile_folder = ['\\files.brown.edu\Research\IBES_SmithLab\scooley1\Planet\Bering_Peninsula\' tile_str ];
   cd(tile_folder);
   cd('PlanetScope/');
   load georeference
   cd(tile_folder);
   cd('RapidEye/');
   load georeference
   
   %STEP 1: GET FILE LIST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   %planetscope
   input_folder = ['\\files.brown.edu\Research\IBES_SmithLab\scooley1\Planet\Bering_Peninsula\' tile_str '/PlanetScope/raw'];
   [files_PS,files_xml_PS] = get_file_list_PS(input_folder);
   
    %rapideye
   input_folder = ['\\files.brown.edu\Research\IBES_SmithLab\scooley1\Planet\Bering_Peninsula\' tile_str '/RapidEye/raw'];
   [files_RE,files_xml_RE] = get_file_list_RE(input_folder);
   
   disp(['finished file list ' num2str(pl_tiles(i))]); 
   
   
   %STEP 2: GET IMAGE METADATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   %planetscope
   cd(tile_folder); 
   cd('PlanetScope/raw');
   [image_meta_data_PS] = get_image_meta_data_PS(files_xml_PS);
   save('image_meta_data.mat','image_meta_data_PS');
   
   
   %rapideye
   cd(tile_folder); 
   cd('RapidEye/raw');
   [image_meta_data_RE] = get_image_meta_data_RE(files_xml_RE);
   save('image_meta_data.mat','image_meta_data_RE');
    
   disp(['finished meta data ' num2str(pl_tiles(i))]); 
   
   
   %STEP 3: LOAD BUFFERED WATER MASK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   cd(tile_folder);
   cd('PlanetScope');
   edited_mask_PS = imread('edited_mask_jun19.tif');
   
   cd(tile_folder);
   cd('RapidEye');
   edited_mask_RE = imread('edited_mask_jun19.tif');
   
   
   %STEP 5: RUN CLASSIFICATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   %planetscope
   [PS_timeseries] = run_classification_timeseries_PS(tile_folder,files_PS,edited_mask_PS,image_meta_data_PS,R_PS,info_PS);
   
   cd(tile_folder);
   cd('PlanetScope');
   save('PS_timeseries.mat','PS_timeseries');
   disp(['finished planetscope classification ' num2str(pl_tiles(i))]); 
   
   
   [RE_timeseries] = run_classification_timeseries_RE(tile_folder,files_RE,edited_mask_RE,image_meta_data_RE,R_RE,info_RE);
   
   cd(tile_folder);
   cd('RapidEye');
   save('RE_timeseries.mat','RE_timeseries');
   disp(['finished rapideye classification' num2str(pl_tiles(i))]); 
   
   %STEP 6: COMBINE TIMESERIES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   doy = 121:273; 
   [complete_time_series] = combine_time_series(doy,edited_mask_RE,RE_timeseries,PS_timeseries);
   cd(tile_folder);
   save('complete_time_series_Jun19.mat','complete_time_series');
   disp(['finished timeseries ' num2str(pl_tiles(i))]); 
   end
   timing(i,1) = toc; 
   
end  