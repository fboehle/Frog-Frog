set(tracePlot, 'CData', frogtrace);
set(marginalDelayPlot, 'YData',mean(frogtrace,1));
set(marginalLambdaPlot, 'YData',mean(frogtrace,2));
set(textDisplay, 'String', ['Max. Int. = ', num2str(max(max(frogtrace)))]);
pixelAvg = sum(sum(frogtrace))/(1376*1035);
drawnow;