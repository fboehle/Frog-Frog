set(tracePlot, 'CData', normMinMax(single(frogtrace)));
set(marginalDelayPlot, 'YData',normMinMax(mean(frogtrace,1)));
set(marginalLambdaPlot, 'YData',normMinMax(mean(frogtrace,2)));
set(textMinDisplay, 'String', ['Min. Int. = ', num2str(min(min(frogtrace)))]);
set(textMaxDisplay, 'String', ['Max. Int. = ', num2str(max(max(frogtrace)))]);
fwhmAutocorrelation = sprintf('FWHM = %.1f Pixel', calcFwAt((1:(numel(mean(frogtrace,1)))),normMinMax(mean(frogtrace,1)),0.5));
set(textFwhmDisplay, 'String', fwhmAutocorrelation);

pixelAvg = sum(sum(frogtrace))/(1376*1035);
drawnow;