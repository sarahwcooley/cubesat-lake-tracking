function [files_tif,files_xml] = get_file_list_PS(input_folder)

cd(input_folder);

files_tif = dir('*_Analytic.tif'); 
files_xml = dir('*_metadata.xml');

for i = 1:length(files_tif)
    num_index(i) = str2num(files_tif(i).name(1:6)); 
end
for i = 1:length(files_xml)
    xml_index(i) = str2num(files_xml(i).name(1:6)); 

end

ind_bad_tif = ismember(num_index,xml_index);
 

ind_bad_xml = ismember(xml_index,num_index);


files_tif(ind_bad_tif == 0) = [];
files_xml(ind_bad_xml == 0) = []; 
end






