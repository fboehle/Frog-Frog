frogTrace = imrotate(frogTrace,0);
set(tracePlot, 'CData', frogTrace.');
pixelAvg = sum(sum(frogTrace))/(1376*1035);
