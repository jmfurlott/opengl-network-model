%Joseph Furlott
% December 6, 2012

%not perfectly tested!!!!!



function W = writeCoordinates( binaryImg, filenameWritten )
%% Prints out coordinates from a binary image (where the coordinates are given by white space = 0

sizeImg = size(binaryImg);

%initialize my I and J matrices
I = zeros(sizeImg(1), 1); % ix1 sized matrix
J = zeros(sizeImg(2), 1); % jx1

%start variable to help traverse matrix in the for loop

start = 1;

for i = 1:sizeImg(1),
    for j = 1:sizeImg(2),
        if binaryImg(i,j) == 0,
            I(start, 1) = i;
            J(start, 1) = j;
            start = start + 1;
        end
    end
end

%now coordinates have been extract from the image
%need to save them into one matrix, we will call that W where [I J]

W = zeros(start,2);

for i = 1:start-1,
    W(i,1) = I(i,1);
    W(i,2) = J(i,1);
end    

fprintf('%d %d \n', round(W));


% just need to write them back current method isn't working
% writes all of I in the two columsn and then switches to J and draws them
% of format: i1 i2
%            i3 i4....

fileID = fopen(filenameWritten, 'w');
fprintf(fileID, '%d %d \n', round(W));
fclose(fileID);





end

