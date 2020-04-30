function [WL,LL,flag,N,edges] = new_inflection_points(image)

%find inflection points of NDWI image for classification
[N,edges] = histcounts(image,255);
N = medfilt1(N,5);
%N = N./max(N); 

%identify peaks
[peaks,locations,~,p_high] = findpeaks(N);
[peaks_low,locations_low,~,p_low] = findpeaks(-N);
ind = find(p_low < .2*max(abs(peaks_low)));
peaks_low(ind) = [];
locations_low(ind) = []; 

if length(unique(peaks)) ==  1
    
    flag = 1; 
    WL = 1;
    LL = 1;
    
else
ind = find(p_high < .1*.5*((max(peaks))+(max(peaks(peaks < unique(max(peaks)))))));
peaks(ind) = [];
locations(ind) = []; 

flag = 0; 


if isempty(locations_low == 1)  
   flag = 1; 
    WL = 1;
    LL = 1;  

else
%find low peak
[low_peak,low_location] = min(abs(peaks_low));
low_location = locations_low(low_location); 

%find two high peaks
[peak_max1,location_max1] = max(peaks);
location_max1 = locations(location_max1);
peaks(peaks == peak_max1) = [];
locations(locations == location_max1) = [];
[~,location_max2] = max(peaks);
location_max2 = locations(location_max2); 
if sign(low_location - location_max1)+sign(low_location - location_max2)~= 0 
   flag = 1; 
   
   peaks_low(peaks_low == -low_peak) = [];
   locations_low(locations_low == low_location) = [];
   [low_peak,low_location] = max(abs(peaks_low));
   low_location = locations_low(low_location);
   
end

   if sign(low_location - location_max1)+sign(low_location - location_max2)~= 0
       WL = 1;
       LL = 1;
   else

%check(1) = location_max1 - location_max2 > 10;
check(1) = isempty(location_max1) == 0;
check(2) = isempty(location_max2) == 0;
check(3) = isempty(low_location) == 0;

if sum(check)==3 
    if abs(location_max1 - location_max2) > 8
%if abs(location_max1 - location_max2) > 10 && isempty(location_max1) == 0 && isempty(low_location) == 0 && isempty(location_max2) == 0

%get land level 
thresh = 1.25*abs(low_peak); 
if location_max2 > location_max1
    x_line = linspace(location_max1,low_location,500);
    yi_line2 = N(location_max1:low_location);
    xi_line2 = location_max1:1:low_location;
else
    x_line = linspace(location_max2,low_location,500);
    yi_line2 = N(location_max2:low_location);
    xi_line2 = location_max2:1:low_location;
end
    y_line1 = linspace(thresh,thresh,500);
    y_line2 = interp1(xi_line2,yi_line2,x_line,'linear');
    
    d = y_line2 - y_line1;
    [~,ix] = min(abs(d));
    LL = x_line(ix);


%get water level
if location_max2 > location_max1
    x_line = linspace(low_location,location_max2,500);
    yi_line2 = N(low_location:location_max2);
    xi_line2 = low_location:1:location_max2;
else
    x_line = linspace(low_location,location_max1,500);
    yi_line2 = N(low_location:location_max1);
    xi_line2 = low_location:1:location_max1;
end
    y_line1 = linspace(thresh,thresh,500);
    y_line2 = interp1(xi_line2,yi_line2,x_line,'linear');
    
    d = y_line2 - y_line1;
    [~,ix] = min(abs(d));
    WL = x_line(ix);

    WL = edges(ceil(WL));
    LL = edges(floor(LL));
    
else
    flag = 1; 
    WL = 1;
    LL = 1; 
    
    end
else
    flag = 1; 
    WL = 1;
    LL = 1; 
end

end
    
end

end

    
    
    
    
    

   
    

