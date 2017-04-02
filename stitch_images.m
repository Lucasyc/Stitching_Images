function new_img = stitch_images(img1, img2)

	% Return a new complete image that stitches the two input images together
	% If the two images cannot be stitched together, return 0
    if ndims(img1) == 3
        leftIm = im2double(rgb2gray(img1));
    else
        leftIm = img1;
    end
    
    if ndims(img2) == 3
        rightIm = im2double(rgb2gray(img2));
    else
        rightIm = img2;
    end
    
    [x1, y1, x2, y2] = get_matches(leftIm, rightIm, 0);
    [T, num_inliers, avg_residual, answerKey] = get_transform(x1, y1, x2, y2, leftIm, rightIm);
    fprintf('%d Match: \n matches: %d,   inliers:  %d\n', i, length(x1), num_inliers);
    
    plotTrial = answerKey;
    drawIm1 = leftIm;
    drawIm2 = rightIm;
    plotCorrespondence(drawIm1, drawIm2, x1(answerKey), y1(answerKey), x2(answerKey), y2(answerKey));
   
    [newImg, deltaX, deltaY] = get_stitched_images(img1, img2, T, 1);
    
    if (deltaX < 0)
        deltaX = 0;
    end
    if(deltaY < 0)
        deltaY = 0;
    end

    figure, imshow(newImg), axis image, hold on
    plot(x2(plotTrial) + deltaX, y2(plotTrial) + deltaY, 'rs');
    figure, imshow(newImg), hold on

    new_img = newImg;
    
end