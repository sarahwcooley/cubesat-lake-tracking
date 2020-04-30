function [files_tif,files_xml] = get_file_list_RE(input_folder)

cd(input_folder);
files_tif = dir('*3A*.tif');
files_xml = dir('*metadata.xml');

index_tif = zeros(length(files_tif),1); 
index_xml = zeros(length(files_xml),1); 


for i = 1:length(files_tif)
    filename = files_tif(i).name(1:end-4);
    for j = 1:length(files_xml)
        filenamexml = files_xml(j).name(1:end-13);
        
        tf = strcmp(filename,filenamexml);
            if tf == 1
                index_tif(i) = 1;
                break
            end
    end
    
end

for i = 1:length(files_xml)
    filename = files_xml(i).name(1:end-13);
    for j = 1:length(files_tif)
        filenamexml = files_tif(j).name(1:end-4);
        
        tf = strcmp(filenamexml,filename);
            if tf == 1
                index_xml(i) = 1;
                break
            end
    end
    
end

files_tif(index_tif == 0) = [];
files_xml(index_xml == 0) = [];

end

