# cubesat-lake-tracking
Matlab workflow for Planet Labs CubeSats lake tracking workflow written by Sarah Cooley, as described in Cooley et al. (2019), Arctic-Boreal Lake Dynamics Revealed Using CubeSat Imagery, Geophysical Research Letters. A complete description of this method can be found in the Supplementary Information for that paper. The entire workflow is designed to be used for Planet Labs Ortho Tiles (both RapidEye and PlanetScope) and loops through each Planet Labs tile. If you have any questions, please contact me at sarah_cooley(@)brown.edu. 

# Initial Classification and Tracking Scripts: 
Please note, these require the 60 m buffered lake mask to already be created and corrected for tile overlap. This initial mask can be created in a variety of ways, but I personally created it through summing the classifications of the first ~10 cloud-free images and then manually checking every tile to ensure the initial classification + 60 m buffer was accurate and included every lake’s maximum extent. These scripts also require the georeference files to already be saved for each tile, as Matlab cannot always read in raw Planet imagery as geotiffs due to the image compression method used. I created the georeferenced files by resaving a single RapidEye and a single PlanetScope image for each tile in Python and then reading in the resaved images in Matlab as geotiffs and saving the georeference.   
1. run_planet_tile_processing_jun18.m – Loops through Planet tiles to classify the images and create time series of lake area
2. get_file_list_PS/RE.m – gets list of files in each folder
3.	get_image_meta_data_PS/RE.m – parses .xml files to get image metadata (uses xml2struct_joe.m script for parsing xml data but this xml parser can be swapped for a different xml parsing script found online)
4.	run_classification_time_series_PS/RE.m – classifies all images and calculates the lake area time series
5.	classify_image_PS.m – classifies the image into water using NDWI and a histogram thresholding approach
6.	new_inflection_points.m – finds the threshold points in the image based on the difference in prominence between the land and water peaks
7.	calculate_lake_area.m – calculates the lake area based on the edited mask and the classified image
8.	combine_time_series.m – since rapideye and planetscope time series are calculated separately, this script combines the observations to produce the complete time series

# Manual Validation Scripts:
1.	lake_validation_workflow_jun18.m – after manually inputting the lake ids I want to validate, this walks me through the validation process by displaying the time series of lake area, the NDWI image and the classified image for each observation. I then input “1” for valid or “0” for invalid for each observation which is then saved as a .mat file to be later used for validation
2.	combine_file_names.m – used for figuring out the proper filenames order for the validation workflow
3.	combine_validation_data.m – sorts and combines all of the validated data and compiles into a table
4.	create_tree_bagger_model.m – creates the random forest classification model from validation dataset
5.	create_validation_table.m – function which reshapes the validation table to be in the correct format for the tree bagger model

# Final Dataset Scripts:
These steps require the complete time series from step 1 and the random forest classification model created after the manual validation.
1.	lake_validation_and_metric_calculation.m – runs the validation, filtering and calculation of lake metrics for each tile
2.	calculate_validation_metrics.m – calculates the metrics used for the random forest regression model
3.	run_bagged_classification.m – runs the random forest classification using the validation metrics and the classification model
4.	filter_validated_time_series.m – applies additional filtering steps to the time series for each lake
5.	calculate_lake_metrics.m – calculates the lake metrics, such as max/min/mean area, dynamism, variability, etc for each lake area time series
