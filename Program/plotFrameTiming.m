% function plotFrameTiming(frameTimingMat)
diffMat = diff(frameTimingMat');
dataMean = mean(diffMat);
dataHz = 1 ./ dataMean;
dataSd = std(diffMat);
for iTrial = 1:size(diffMat,2)
    fprintf('trial %d >>\tISI_mean %.6f\tISI_Hz %.4f\tISI_sd %.6f\n',...
        iTrial,...
        dataMean(iTrial),...
        dataHz(iTrial),...
        dataSd(iTrial));
end


plot(diffMat);