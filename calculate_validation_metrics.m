function [complete_time_series] = calculate_validation_metrics(complete_time_series_old)

    complete_time_series = complete_time_series_old; 
    
    for j = 1:length(complete_time_series)
        
        doy = complete_time_series(j).doy; 
        lake_area = complete_time_series(j).area75;
        nodata = complete_time_series(j).NoData;
        type = complete_time_series(j).type;
        max_area = complete_time_series(j).max_area(1);
        max_area_flag = 100*(lake_area./max_area);
        cloud_cover = complete_time_series(j).cloud_cover; 
        perim = complete_time_series(j).perimeter;
        
        %ADDITIONAL QUALITY 1: median lake area
        
        indices = zeros(size(lake_area));
        indices(nodata >= 90) = 1;
        median_area = median(lake_area(indices == 0));
        complete_time_series(j).median_area = median_area*ones(size(lake_area));
        
        %ADDITIONAL QUALITY 2: percent difference from median lake area
        
        complete_time_series(j).percent_median = 100*(lake_area./median_area - 1);
        
        %ADDITIONAL QUALITY 3+4+5: percent difference from 5-day median and std median 
        
        indices(max_area_flag > 95) = 1; 
        ind = find(indices == 0);
        ll = lake_area(ind);
        valid_median_5d = medfilt1(ll,5,'truncate');
        valid_median_5day = 100*(ll./valid_median_5d - 1);
        valid_std_5day = 100*movstd(ll,5)./valid_median_5d;
        median_5day = zeros(size(lake_area));
        median_5day(ind) = valid_median_5day;
        median_5day(indices == 1) = -100;
        std_5day = zeros(size(lake_area));
        std_5day(ind) = valid_std_5day;
        std_5day(indices == 1) = -100;
        
        complete_time_series(j).median_5day = median_5day; 
        complete_time_series(j).std_5day = std_5day;
        complete_time_series(j).std = std(ll)*ones(size(lake_area)); 
        
        %ADDITIONAL QUALITY 6+7: percent difference from 10-day median 
        
        indices(max_area_flag > 95) = 1; 
        ind = find(indices == 0);
        ll = lake_area(ind);
        valid_median_10d = medfilt1(ll,10,'truncate');
        valid_median_10day = 100*(ll./valid_median_10d - 1);
        valid_std_10day = 100*movstd(ll,10)./valid_median_10d;
        median_10day = zeros(size(lake_area));
        median_10day(ind) = valid_median_10day;
        median_10day(indices == 1) = 100;
        std_10day = zeros(size(lake_area));
        std_10day(ind) = valid_std_10day;
        std_10day(indices == 1) = -100;
        
        complete_time_series(j).median_10day = median_10day;
        complete_time_series(j).std_10day = std_10day;
        
        %ADDITIONAL QUALITY 8 + 9: Perimeter
        
        pm = perim(ind);
        valid_perim_m_5d = medfilt1(pm,5,'truncate');
        valid_perim_m_5day = 100*(pm./valid_perim_m_5d - 1);
        perim_5day = zeros(size(lake_area));
        perim_5day(ind) = valid_perim_m_5day;
        perim_5day(indices == 1) = -100;
        
        valid_perim_m_10d = medfilt1(pm,10,'truncate');
        valid_perim_m_10day = 100*(pm./valid_perim_m_10d - 1);
        perim_10day = zeros(size(lake_area));
        perim_10day(ind) = valid_perim_m_10day;
        perim_10day(indices == 1) = -100;
        
        complete_time_series(j).perim_5day = perim_5day;
        complete_time_series(j).perim_10day = perim_10day;
        
        %EDIT CLOUD FLAG
        
        cloud_cover(type == 2) = 0.01*cloud_cover(type == 2);
        complete_time_series(j).cloud_cover = cloud_cover;
        
        %EDIT MAX AREA FLAG
        
        complete_time_series(j).max_area_percent = max_area_flag; 
    
    end
    
end
    