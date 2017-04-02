function [T, num_inliers, avg_residual, answerKey] = get_transform(x1, y1, x2, y2, img1, img2)

	% Do RANSAC to determine the best transformation between the matched coordinates
	% provided by (x1,y1,x2,y2).

	% Return the transformation, the number of inliers, and average residual
%     assert((size(x1) ~= size(y1)) | (size(x2) ~= size(y2)) | (size(x1) ~= size(x2)));

%     if (size(x1) ~= size(y1) || size(x2) ~= size(y2) || size(x1) ~= size(x2))
%        error('The vector sizes are not the same!'); 
%     end
    
    T = ones(3, 3);
    [pairNum, ~] = size(x1);
    
    sample_count = 0;
    
    %%%%%%%%%Inlier Rate ledge%%%%%%%%%%%
%     p = 0.7;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%Inlier Rate other%%%%%%%%%%%
    p = 0.8;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    answerKey = [];
    originXY = [x1, y1, ones(pairNum, 1)];
    afterXY = [x2, y2, ones(pairNum, 1)];
    avgDist = 0;
    
    maxNum = 0;
    minDis = 1000;
    maxAnswerKey = [];
    
    while (1)
        if (pairNum <= 4) 
            inlierNum = 0.1;
            avgDist = 100;
            break;
        end
        thisTrial = randperm(pairNum, 4);
        A = zeros(8, 9);
        xi = [x1(thisTrial), y1(thisTrial), ones(4, 1)];
        x_t = x2(thisTrial);
        y_t = y2(thisTrial);
        for i = 1 : 4
           A(2*i - 1:2*i, :) = [zeros(1, 3), xi(i, :), -y_t(i, :).*xi(i, :);...
               xi(i, :), zeros(1, 3), -x_t(i, :) .* xi(i, :)];
        end
        [~, ~, v] = svd(A);
        h = v(:, end);
        T_matrix = reshape(h, 3, 3)';
        answer = (T_matrix * originXY')';
        answer(:, 1) = answer(:, 1) ./ answer(:, 3);
        answer(:, 2) = answer(:, 2) ./ answer(:, 3);
        z_copy = answer(:, 3);
        answer(:, 3) = answer(:, 3) ./ answer(:, 3);
        inlierNum = 0;
        z = 0;
        for i = 1 : pairNum
            if (sqrt((abs(answer(i, 1) - afterXY(i, 1)))^2 + (abs(answer(i, 2) - afterXY(i, 2)))^2) < 10) 
                inlierNum = inlierNum + 1;
                answerKey = [answerKey; i];
                avgDist = avgDist + sqrt((abs(answer(i, 1) - afterXY(i, 1)))^2 + (abs(answer(i, 2) - afterXY(i, 2)))^2);
                z = z + z_copy(i, 1);
            end
        end
        ratio = inlierNum / pairNum;
        if (ratio > p) 
            T = maketform('projective', [x1(thisTrial), y1(thisTrial)], [x2(thisTrial), y2(thisTrial)]);
            break;
        end      
        
        if (inlierNum > maxNum)
           maxNum = inlierNum;
           minDis = avgDist;
           maxAnswerKey = answerKey;
           trial = thisTrial;
        end
        
        if (sample_count > 100000)
           T = maketform('projective', [x1(trial), y1(trial)], [x2(trial), y2(trial)]);
           inlierNum = maxNum;
           avgDist = minDis;
           answerKey = maxAnswerKey;
           break;
        end
        sample_count = sample_count + 1;
        answerKey = [];
        avgDist = 0;
        maxAnswerKey = [];
    end
    
    num_inliers = inlierNum;    
    avg_residual = avgDist / inlierNum;
end



