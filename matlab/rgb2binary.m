%Joseph Furlott
%with help (need to put in copyright notice) from Peter Bankhead et al. and
%ARIA



function [ bw_clean ] = rgb2binary( rgbimage, dark )

%usage: read in an image and for all fundus images, dark = true
% >> bw = rgb2binary( image, true);
% >> imshow(bw)



%takes in a fundus image and prints out the binary image
%clean_segmented_image portion needs to use variables instead
%   being hard coded in. but these work well for now

%get out of uint8 so can be processed
image = single(rgbimage(:,:,2)); 

%find out mask that is going to clean up the segmented image
bw_mask = imerode(image > 20, ones(3));

%find all the wavelet levels 1:5 and layer them onto each other
%using iuwt transforms here
w = 0;
s_in = image;
levels = 1:5; %should be a variable
%b3 spline coefficients...could make this better? why these??
b3 = [1 4 6 4 1]/ 16;

%compute the transform
for ii = 1:levels(end)
    h = dilate_wavelet_kernel(b3, 2^(ii-1)-1);
    
    s_out = imfilter(s_in, h' * h, 'symmetric');
    
    if ismember(ii, 1:5)
        w = w + s_in - s_out;
    end
    
    s_in = s_out;

end


%so w is our image that been through the transformation
%now lets do the segmentation based off a precentage.
%here I have hardcoded .2 but should be a variable and messed with.
%.2 gives decent results


if nargin < 5 
    if ~isempty(bw_mask)
        sorted_pix = sort(w(bw_mask(:)));
    else
        sorted_pix = sort(w(:));
    end
end



proportion = .2; %VARIABLE


%invert percented if dark (most fundus images are dark)
if dark
    proportion = 1 - proportion;
end

%calculate threshold....not sure how this work. just took function down
%below
%changing the threshold can make a huge difference so see what works best.
%Should be a variable
[threshold, sorted_pix] = percentage_threshold(sorted_pix, proportion, true);


if dark
    bw = w <= threshold;
else
    bw = w > threshold;
end

if ~isempty(bw_mask)
    bw = bw & bw_mask;
end

%segmenting done
%now to need to blend our image
min_object_size = 5000; %needs to be a variable
min_hole_size = 4; % needs to be a variable

if min_object_size > 0
    cc_objects = bwconncomp(bw);
    area_objects = cellfun('size', cc_objects.PixelIdxList, 1);
    bw_clean = false(size(bw));
    inds = area_objects >= min_object_size;
    bw_clean(cell2mat(cc_objects.PixelIdxList(inds)')) = true;
else
    bw_clean = bw;
end

%fill in holds if necesarry
if min_hole_size > 0
    cc_holes = bwconncomp(~bw_clean);
    area_holes = cellfun('size', cc_holes.PixelIdxList, 1);
    inds = area_holes < min_hole_size;
    bw_clean(cell2mat(cc_holes.PixelIdxList(inds)')) = true;
end

end













function h2 = dilate_wavelet_kernel(h, spacing)

h2 = zeros(1, numel(h) + spacing * (numel(h) - 1));

if size(h,1) > size(h,2)
    h2 = h2';
end

h2(1:spacing+1:end) = h;
end

function [threshold, data_sorted] = percentage_threshold(data, proportion, sorted)
% Determine a threshold so that (approx) proportion of data is above the 
% threshold.
% 
% Input:
%   DATA - the data from which the threshold should be computed
%   PROPORTION - the proportion of the data that should exceed the
%   threshold.  If > 1, it will first be divided by 100.
%   SORTED - TRUE if the data has already been sorted, FALSE otherwise
%
% Output:
%   THRESHOLD - either +Inf, -Inf or an actual value present in DATA.
%   DATA_SORTED - a sorted version of the data, that might be used later to
%   determine a different threshold.
%
% SEE ALSO PERCENTAGE_SEGMENT.
%
%
% Copyright © 2011 Peter Bankhead.
% See the file : Copyright.m for further details.

% Need to make data a vector
if ~isvector(data)
    data = data(:);
end

% If not told whether data is sorted, need to check
if nargin < 3
    sorted = issorted(data);
end

% Sort data if necessary
if ~sorted
    data_sorted = sort(data);
else
    data_sorted = data;
end

% Calculate threshold value
if proportion > 1
    proportion = proportion / 100;
end
proportion = 1-proportion;
thresh_ind = round(proportion * numel(data_sorted));
if thresh_ind > numel(data_sorted)
    threshold = Inf;
elseif thresh_ind < 1
    threshold = -Inf;
else
    threshold = data_sorted(thresh_ind);
end

end
