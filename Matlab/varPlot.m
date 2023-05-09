function [v,threshold, newVar] = varPlot(X,ppm,Y,thresh)
%
% Created on Matblab Version R2020b
% Date: 1/17/2023
% Deanna Lanier
%
%   Description:
%       varPlot calculates the variance of spectral data filters out
%       the values that are BELOW the set threshold, and plots the
%       resulting spectral data
%
%   Input:
%       X: Stack of 1D spectra. Spectra should be normalized but is not
%       required. Data will be scaled.
%       ppm: chemical shift vector
%       Y: grouping to color the plot
%       Threshold value: % of data to keep after filtering based on
%       variance
%   
%   Output:
%       3 subplots:
%           #1: Original spectra
%           #2: Filtered spectral data
%           #4: Variance plot (points above the threshold colored in red,
%           points below in black
%
%       [v, threshold, v_filter, new Var]
%           v: the variance values at each point
%           threshold: the value of the threshold based on the percentage
%           selected
%           newVar: Filtered variance data 
 
%% scale data
data_RR = remove_region(X,ppm,-0.04,0.04);
data_scaled = scale(data_RR,'pareto');

%% calculate variance and filter data
v = var(data_scaled);
v_sort = sort(v);
[~,sortsize] = size(v_sort);
threshold = v_sort(ceil((thresh)*sortsize));
v_filter = find(v<=threshold);
[~,vsize] = size(v_filter);
newVar = data_RR;

for i = 1:vsize
    newVar(:,v_filter(i))=0;
end
%% Build colormap
        [map,~,ind] = unique(Y); % MJ 24JAN2018 map values in Yvec to avoid indexing problems with Y(k) = 0.
        cmap=distinguishable_colors(length(map));

%% Plot
if exist('Y')==0
    Y=ones(size(X,1),1);
end


figure;

S9 = subplot(3,1,1);

hold on;
for k= 1:size(data_RR,1)
    plotr(ppm,data_RR(k,:),'Color',cmap(ind(k),:))
end
hold off
title 'Original'
hold off

S12=subplot(3,1,3);

scatter(ppm,v,'r');
hold on

scatter(ppm(v_filter),v(v_filter),'k')
set(gca,'XDir','reverse')
title 'Variance'
hold off

S13 = subplot(3,1,2);

   
hold on;        
for k=1:size(newVar,1)
    plotr(ppm,newVar(k,:),'Color',cmap(ind(k),:))
end
hold off
title 'Filtered'
hold off

linkaxes([S9,S12,S13],'x');

   
end

