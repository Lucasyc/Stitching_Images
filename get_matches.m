function [x1, y1, x2, y2] = get_matches(img1, img2, do_visualization)

	% Return matched x,y locations across the two images. The point defined by (x1,y1) in
	% img1 should correspond to the point defined by (x2,y2) in img2.
    
    [feats1, row1, col1] = get_feats(img1);
    [feats2, row2, col2] = get_feats(img2);
        
    distMatrix = dist2(feats1, feats2);
    distMatrix = abs(distMatrix - 1);
    
%     threshold = 4.5;

%%%%%normal%%%%%%%%%%%%%
%     threshold = 0.05;
%%%%%%%%%%%%%%%%%%%%%%%

%%%%%ledge%%%%%%%%%%%%%%
    threshold = 0.1;
%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%ledge%%%%%%%%%%%%%%
%     threshold = 0.04;
%%%%%%%%%%%%%%%%%%%%%%%%

    [i1, i2] = find(distMatrix < threshold);
    
    y1 = row1(i1);
    y2 = row2(i2);
    x1 = col1(i1);
    x2 = col2(i2);
    
    color = {'ys'};
	if do_visualization
		% Display a single figure with the two input images side-by-side.
		% Visualize the features your method has found with some way of showing
		% the corresponding matches.
        
        plotCorrespondence(img1, img2, x1, y1, x2, y2);
	end

end

