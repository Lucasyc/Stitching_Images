This is a MATLAB project that can take multiple images that have overlaps as input, and then output a stitiching image like a panoramic cameras. 
The proccess is three steps:

1. Use corner detection to detect the features of each image
2. Run RANSAC to randomly select 4 points to form a homography mapping from one image to another, and find how many inliers are there in this transformation, if there are enough inliers, take this transform. 
3. Stitch images with such transforms.  
