imageLeftName = 'uttower_left.jpg';
imageRightName = 'uttower_right.jpg';

%Load data
dataDir = fullfile('..', 'data');
leftIm = imread(fullfile(dataDir, imageLeftName));
rightIm = imread(fullfile(dataDir, imageRightName));

stitch_images(leftIm, rightIm);
