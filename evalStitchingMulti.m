imgName1 = '1.JPG';
imgName2 = '2.JPG';
imgName3 = '3.JPG';

dataDir = fullfile('../data', 'ledge');
img1 = imread(fullfile(dataDir, imgName1));
img2 = imread(fullfile(dataDir, imgName2));
img3 = imread(fullfile(dataDir, imgName3));

imgs = {img1, img2, img3};
stitch_multiple_images(imgs);
