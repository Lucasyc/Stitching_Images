function n2 = dist2(x, c)
% DIST2	Calculates squared distance between two sets of points.
% Adapted from Netlab neural network software:
% http://www.ncrg.aston.ac.uk/netlab/index.php
%
%	Description
%	D = DIST2(X, C) takes two matrices of vectors and calculates the
%	squared Euclidean distance between them.  Both matrices must be of
%	the same column dimension.  If X has M rows and N columns, and C has
%	L rows and N columns, then the result has M rows and L columns.  The
%	I, Jth entry is the  squared distance from the Ith row of X to the
%	Jth row of C.
%
%
%	Copyright (c) Ian T Nabney (1996-2001)

[~, dimx] = size(x);
[~, dimc] = size(c);
if dimx ~= dimc
	error('Data dimension does not match dimension of centres')
end


meanx = padarray(mean(x, 2), [0, dimx - 1], 'replicate', 'post');
meanc = padarray(mean(c, 2), [0, dimc - 1], 'replicate', 'post');
x = x - meanx;
c = c - meanc;
normx = padarray(sqrt(sum(abs(x).^2, 2)), [0, dimx - 1], 'replicate', 'post');
normc = padarray(sqrt(sum(abs(c).^2, 2)), [0, dimc - 1], 'replicate', 'post');
x = x ./ normx;
c = c ./normc;

n2 = x * c';

% n2 = (ones(ncentres, 1) * sum((x.^2)', 1))' + ...
%   ones(ndata, 1) * sum((c.^2)',1) - ...
%   2.*(x*(c'));
% 
% % Rounding errors occasionally cause negative entries in n2
% if any(any(n2<0))
%   n2(n2<0) = 0;
end