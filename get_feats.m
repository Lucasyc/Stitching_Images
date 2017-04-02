function [feats, x, y] = get_feats(img)

	% Return an N x M matrix of features, along with the corresponding x,y
	% locations of the detected features.

	% N and M both depend on what method of feature detection you choose to use.
	% N = number of features found
	% M = feature vector length
    
    %%%%%%%%%%%%%%%%% PARAMETERS %%%%%%%%%%%%%%%%%%%%
    %%%%  ledge  %%%%%%%
    harrisSigma = 1.1;
    %%%%%%%%%%%%%%%%%
    
    %%%%  Other  %%%%%%%
%     harrisSigma = 3;
    %%%%%%%%%%%%%%%%%
    
    %%%%  pier  %%%%%%%
%     harrisSigma = 4;
    %%%%%%%%%%%%%%%%%
    
    harrisThreshold = 0.06;
    
%     harrisRadius = 5;
    harrisRadius = 4;
    harrisFlag = 0;  
    
    %%%%%%%   other  %%%%%%
%     featVara = 10;
    %%%%%%%%   pier %%%%%%%
    featVara = 10;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [sizeX, sizeY] = size(img);
    [cornerIm, r, c] = harris(img, harrisSigma, harrisThreshold, ...
        harrisRadius, harrisFlag);
    
    for i = 1 : sizeX
        for j = 1 : sizeY
            if (i <= featVara || i >= sizeX - featVara || j <= featVara || j >=...
                    sizeY - featVara)
               cornerIm(i, j) = 0; 
            end
        end
    end
    
    [x, y] = find(cornerIm == 1);
        
    [featNum, ~] = size(x);
    feats = zeros(featNum, (2 * featVara + 1).^2);
    
    for i = 1 : featNum
        featurePixels = img(max(0, (x(i) - featVara)):min(sizeX, (x(i) + featVara))...
            , max(0, (y(i) - featVara)):min(sizeY, (y(i) + featVara)));
        feats(i, :) = transpose(featurePixels(:));
    end
    
   
end
