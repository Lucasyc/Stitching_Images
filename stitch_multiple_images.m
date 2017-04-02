function new_img = stitch_multiple_images(imgs)

	% Given a set of images in any order, stitch them together into a final panorama
	% Example call: stitch_multiple_images({img1, img2, img3})
    n = length(imgs);
    imgdouble = {};
    for i = 1 : n
        imgdouble{i} = im2double(rgb2gray(imgs{i}));
    end
    
    thisImg = imgdouble{1};
    order = [1];
    for i = 1 : n
        extremeValue = 0;
        matchedIndex = 0;
        value = 0;
        for j = 1 : n
            thisImg = imgdouble{j};
            if (isempty(find(order == j, 1)) && j ~= i)
                [x1, y1, x2, y2] = get_matches(imgdouble{i}, thisImg, 0);
%                 plotCorrespondence(imgdouble{i}, thisImg, x1, y1, x2, y2);
                [~, num_inliers, avg_residual, ~] = get_transform(x1, y1, x2, y2, imgdouble{i}, thisImg);
                value = num_inliers;
            end
            
            if (value > extremeValue)
                   matchedIndex =  j;
                   extremeValue = num_inliers;
            end
        end
        extremeValue = 0;
        if (length(order) ~= n)
           order = [order, matchedIndex]; 
        end
    end
    
    thisImg = imgs{1};
    k = 2;

    inlierKey = {};
    delta = {};
    i = 1;

    while (k <= length(order))
         [x1, y1, x2, y2] = get_matches(imgdouble{order(k)}, im2double(rgb2gray(thisImg)), 0);
         [T, num_inliers, avg_residual, key] = get_transform(x1, y1, x2, y2, imgdouble{order(k)}, im2double(rgb2gray(thisImg)));
         inlierKey{i} = [x2(key), y2(key)];
         fprintf('%d Match: \n matches: %d,   inliers:  %d\n', i, length(x1), num_inliers);
         plotCorrespondence(imgdouble{order(k)}, im2double(rgb2gray(thisImg)), x1(key), y1(key), x2(key), y2(key));
         [newImg, deltaX, deltaY] = get_stitched_images(imgs{order(k)}, thisImg, T, 1);
         if (deltaX < 0) 
             deltaX = 0; 
         end
         if (deltaY < 0) 
             deltaY = 0; 
         end
         delta{i} = [deltaX, deltaY];
         thisImg = newImg;
         k = k + 1;
         i = i + 1;
    end
    
    inlierKey{1}(:, 1) = inlierKey{1}(:, 1) + padarray(delta{1}(1, 1) + delta{2}(1, 1), [size(inlierKey{1}, 1) - 1, 0], 'post', 'replicate');
    inlierKey{1}(:, 2) = inlierKey{1}(:, 2) + padarray(delta{1}(1, 2) + delta{2}(1, 2), [size(inlierKey{1}, 1) - 1, 0], 'post', 'replicate');
    
    
%     padarray(delta{2}(1), [size(inlierKey{1}, 1) - 1, 0], 'post', 'replicate')
    inlierKey{2}(:, 1) = inlierKey{2}(:, 1) + padarray(delta{2}(1, 1), [size(inlierKey{2}, 1) - 1, 0], 'post', 'replicate');
    inlierKey{2}(:, 2) = inlierKey{2}(:, 2) + padarray(delta{2}(1, 2), [size(inlierKey{2}, 1) - 1, 0], 'post', 'replicate');
    
    figure, imshow(thisImg);
    figure, imshow(thisImg), axis image, hold on;
    plot(inlierKey{1}(:, 1), inlierKey{1}(:, 2), 'rs');
    plot(inlierKey{2}(:, 1), inlierKey{2}(:, 2), 'rs');
    
    
    
    
    
    
    
end