function X = ischarincell(Y)
%ISCHARINCELL find cells that contain character arrays.

X = logical(zeros(size(Y)));

for k = 1:length(Y)
	if isstr(Y{k})
		X(k) = true;
	end
end
