function [newImg, deltaX, deltaY] = get_stitched_images(img1, img2, T, color)
    leftIm = img1;
    rightIm = img2;
    if (color ~= 1)
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
    end
    drawIm1 = leftIm;
    drawIm2 = rightIm;
    [~, xdata, ydata] = imtransform(drawIm1, T);
    xdataout = [floor(min(1, xdata(1))), ceil(max(max(size(drawIm1, 2), size(drawIm2, 2)), xdata(2)))];
    ydataout = [floor(min(1, ydata(1))), ceil(max(max(size(drawIm1, 1), size(drawIm2, 1)), ydata(2)))];
    im1_transf = imtransform(drawIm1, T, 'XData', xdataout, 'YData', ydataout);
    im2_transf = imtransform(drawIm2, maketform('affine', eye(3, 3)), 'XData', xdataout, 'YData', ydataout);
    
    
    
    
    newImg = max(im1_transf, im2_transf);

    deltaX = 1 - xdata(1);
    deltaY = 1 - ydata(1);
end