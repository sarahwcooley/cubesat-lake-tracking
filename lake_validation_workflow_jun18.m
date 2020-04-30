%planet validation script
%goal: display lakes

%Step 1: input lake data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for p = 1:length(tiles)
if re_exist(p) == 1
tile_str = num2str(tiles(p));
grid_str = grids{p};
tile_folder = ['\\files.brown.edu\Research\IBES_SmithLab\Shared\AKGRDs\' grid_str '\' tile_str '\2017\'];
cd(tile_folder);


%Step 2: input lake ids to be validated through looking at the buffered
%mask
cd('RapidEye');
mask = imread('edited_mask_jun19.tif');
figure(2)
disp([tile_str])

%get number of lakes
num_thresh = 0.03; % 3 percent of lakes
area_thresh = 40000;
area_check = regionprops(mask,'Area');
number_lakes = num_thresh*sum((25*[area_check.Area]) >= area_thresh);

display(['Number Lakes = ' num2str(number_lakes)]);
imshow(mask,[0 1],'InitialMagnification','fit');
pause
lake_ids = input('enter lake_ids? ');



%Step 2: get filenames %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(tile_folder);
cd('PlanetScope');
load PS_timeseries
edited_mask_PS = imread('edited_mask_jun19.tif'); 
cd('classified');

files_PS_ndwi = dir('*ndwi.tif');
files_PS_classified = dir('*classified.tif');

cd(tile_folder);
cd('RapidEye/');
edited_mask_RE = imread('edited_mask_jun19.tif'); 
load RE_timeseries

cd('classified');
files_RE_ndwi = dir('*ndwi.tif');
files_RE_classified = dir('*classified.tif');
doy_total = 121:304;
[file_names] = combine_file_names(doy_total,RE_timeseries,PS_timeseries,files_PS_classified, ...
    files_PS_ndwi,files_RE_classified,files_RE_ndwi);

ed_mask_PS = edited_mask_PS;
ed_mask_RE = edited_mask_RE;

%Step 3: find bounding box of lake %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for k = 1:length(lake_ids)

edited_mask_PS = ed_mask_PS;
edited_mask_RE = ed_mask_RE;

lake_id = lake_ids(k);
cd(tile_folder)
load complete_time_series_jun18
doy = complete_time_series(lake_id).doy; 
lake_area = complete_time_series(lake_id).area75;
nodata = complete_time_series(lake_id).NoData;
type = complete_time_series(lake_id).type;
max_area = complete_time_series(lake_id).max_area(1);


edited_mask_PS(edited_mask_PS ~= lake_id) = 0;
edited_mask_PS(edited_mask_PS > 1) = 1;
edited_mask_RE(edited_mask_RE ~= lake_id) = 0;
edited_mask_RE(edited_mask_RE > 1) = 1;


% get bounding box in PS coordinates 
bb_PS = regionprops(edited_mask_PS,'BoundingBox');
bb_PS = ceil(bb_PS.BoundingBox);
idx_x_PS = [bb_PS(1)-5 bb_PS(1)+bb_PS(3)+5];
idx_y_PS = [bb_PS(2)-5 bb_PS(2)+bb_PS(4)+5];
if idx_x_PS(1)<1, idx_x_PS(1)=1; end
if idx_y_PS(1)<1, idx_y_PS(1)=1; end
if idx_x_PS(2)>8000, idx_x_PS(2)=8000; end
if idx_y_PS(2)>8000, idx_y_PS(2)=8000; end

% get bounding box in RE coordinates 
bb_RE = regionprops(edited_mask_RE,'BoundingBox');
bb_RE = ceil(bb_RE.BoundingBox);
idx_x_RE = [bb_RE(1)-5 bb_RE(1)+bb_RE(3)+5];
idx_y_RE = [bb_RE(2)-5 bb_RE(2)+bb_RE(4)+5];
if idx_x_RE(1)<1, idx_x_RE(1)=1; end
if idx_y_RE(1)<1, idx_y_RE(1)=1; end
if idx_x_RE(2)>5000, idx_x_RE(2)=5000; end
if idx_y_RE(2)>5000, idx_y_RE(2)=5000; end


%Step 4: loop through images %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

validation  = zeros(length(lake_area),1);

for i = 1:length(lake_area)
    cd(tile_folder)
    if nodata(i) > 20
        validation(i) = -1;
    else
        if lake_area(i) > 0.95*max_area 
            validation(i) = 0;
        else
        %load images
        if type(i) == 1
            
            cd('PlanetScope/classified');
            ndwi = imread(file_names(i).n_name,'PixelRegion',{[idx_y_PS(1),idx_y_PS(2)],[idx_x_PS(1),idx_x_PS(2)]});
            classified = imread(file_names(i).c_name,'PixelRegion',{[idx_y_PS(1),idx_y_PS(2)],[idx_x_PS(1),idx_x_PS(2)]});
         
        else
            cd('RapidEye/classified');
            ndwi = imread(file_names(i).n_name,'PixelRegion',{[idx_y_RE(1),idx_y_RE(2)],[idx_x_RE(1),idx_x_RE(2)]});
            classified = imread(file_names(i).c_name,'PixelRegion',{[idx_y_RE(1),idx_y_RE(2)],[idx_x_RE(1),idx_x_RE(2)]});
          
        end
        
        
        %show images
        
        figure(1)
        
        subplot(2,2,1) %ndwi
        imshow(ndwi,[0 250],'InitialMagnification','fit');
        
        subplot(2,2,2) %classified
        classified(classified < 75) = 0;
        classified(classified > 100) = 0;
        imshow(classified,[0 100],'InitialMagnification','fit');
        
        subplot(2,2,[3,4])
        hold off
        scatter(doy,lake_area,50,'MarkerFaceColor','k');
        hold on
        scatter(doy(i),lake_area(i),100,'MarkerFaceColor','r');
        
        disp(['Lake Area = ' num2str(lake_area(i))]);
        %input validation
        x = input('Valid? ');
        validation(i) = x;
        end
    end
        cd(tile_folder);
        output_name = ['validation_' num2str(lake_id) '.mat'];
        save(output_name,'validation'); 
    
end

end

end

end
        




