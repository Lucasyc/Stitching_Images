function plotCorrespondence(img1, img2, x1, y1, x2, y2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    newIm1 = img1;
    newIm2 = img2;
    if size(img1) ~= size(img2)
        [r1, c1] = size(img1);
        [r2, c2] = size(img2);
        newSizeR = max(r1, r2);
        newSizeC = max(c1, c2);
        xdata = [1, newSizeC];
        ydata = [1, newSizeR];
        newIm1 = imtransform(newIm1, maketform('affine', eye(3, 3)), 'XData', xdata, 'YData', ydata);
        newIm2 = imtransform(newIm2, maketform('affine', eye(3, 3)), 'XData', xdata, 'YData', ydata);
    end
    [~, img1_y] = size(newIm1);
    n = size(x1);
    x2 = x2 + img1_y;
    bothIm = [newIm1, newIm2];
    figure, imagesc(bothIm), axis image, colormap(gray), hold on
    plot(x1, y1, 'ys'), title('corners detected');
    plot(x2, y2, 'ys'), title('corners detected');
    for i = 1 : n
       line([x1(i, :), x2(i, :)], [y1(i, :), y2(i, :)], 'color', 'r', 'LineWidth', 0.1); 
    end
%         
%         figure, imagesc(img2), axis image, colormap(gray), hold on
%         plot(y2, x2, 'ys'), title('corners detected');
    

end

