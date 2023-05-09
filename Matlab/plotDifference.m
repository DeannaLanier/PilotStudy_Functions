function [difference] = plotDifference(X1,X2,ppm)
%
% Created on Matlab version R2020b
% Date: 03/28/2023
% Author: Deanna Lanier
%
%
%   Description:
%       plotDifference calculates the difference between two spectra and
%       plots the difference
%           spectra(1) - spectra(2) = Difference Plot. 
%       The data does not have to be aligned or normalized and should not
%       be scaled.
%   
%   Input:
%       X1: 1D Spectra
%       X2: 1D Spectra
%       ppm: chemical shift vector
%
%   Output: 
%       2 subplots:
%           #1: Original 2 spectra stacked (spectra 1 will always be blue and spectra 2 will alwasy be red)
%           #2: Difference plot
%       [difference]: vector of the difference between the two spectra
%


% Find the difference between the two input spectra

difference = (X1) - (X2);

%plot the original and difference

t = tiledlayout(1,2);

% Tile 1
ax1 = nexttile
hold on;
plot(ppm,(X1),'Marker','none',"Color",'blue','LineWidth',0.2);
plot(ppm,(X2),'Marker','none',"Color",'red','LineWidth',0.2);
set(gca,'XDir','reverse');
title('Original');
hold off;

% Tile 2
ax2 = nexttile
plotr(ppm,difference)
title('Difference')

t.TileSpacing = 'compact';
t.Padding = 'compact';

linkaxes([ax1 ax2 ],'xy')


end

