function [image_meta_data] = get_image_meta_data_RE(files)


for j = 1:length(files)
        name = [files(j).name];
        xml_data = xml2struct_joe(name);
        image_meta_data(j).name = files(j).name(1:end-4); 
        ind = strfind(files(j).name(1:end-13),'_2018-');
        month = files(j).name(ind+6:ind+7);
        day = files(j).name(ind+9:ind+10);
        v = [2017 str2num(month) str2num(day) 0 0 0];
        v0 = [2017 1 1 0 0 0];
        doy = datenum(v) - datenum(v0) + 1;
        image_meta_data(j).date = [month '-' day];
        image_meta_data(j).doy = doy;
      
        image_meta_data(j).cloud_cover = str2num(xml_data.re_EarthObservation.gml_resultOf.re_EarthObservationResult.opt_cloudCoverPercentage.Text);
        image_meta_data(j).unusable_data = str2num(xml_data.re_EarthObservation.gml_resultOf.re_EarthObservationResult.re_unusableDataPercentage.Text);
        image_meta_data(j).azimuth_angle = str2num(xml_data.re_EarthObservation.gml_using.eop_EarthObservationEquipment.eop_acquisitionParameters.re_Acquisition.eop_incidenceAngle.Text);
        image_meta_data(j).illumination_azimuth = str2num(xml_data.re_EarthObservation.gml_using.eop_EarthObservationEquipment.eop_acquisitionParameters.re_Acquisition.opt_illuminationAzimuthAngle.Text);
        image_meta_data(j).illumination_elevation = str2num(xml_data.re_EarthObservation.gml_using.eop_EarthObservationEquipment.eop_acquisitionParameters.re_Acquisition.opt_illuminationElevationAngle.Text);
        image_meta_data(j).b1_TOA = str2num(xml_data.re_EarthObservation.gml_resultOf.re_EarthObservationResult.re_bandSpecificMetadata{1,1}.re_radiometricScaleFactor.Text);
        image_meta_data(j).b2_TOA = str2num(xml_data.re_EarthObservation.gml_resultOf.re_EarthObservationResult.re_bandSpecificMetadata{1,2}.re_radiometricScaleFactor.Text);
        image_meta_data(j).b3_TOA = str2num(xml_data.re_EarthObservation.gml_resultOf.re_EarthObservationResult.re_bandSpecificMetadata{1,3}.re_radiometricScaleFactor.Text);
        image_meta_data(j).b4_TOA = str2num(xml_data.re_EarthObservation.gml_resultOf.re_EarthObservationResult.re_bandSpecificMetadata{1,4}.re_radiometricScaleFactor.Text);
        image_meta_data(j).b5_TOA = str2num(xml_data.re_EarthObservation.gml_resultOf.re_EarthObservationResult.re_bandSpecificMetadata{1,5}.re_radiometricScaleFactor.Text);
        
    
 end