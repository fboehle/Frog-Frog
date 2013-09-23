%*********************************************************
%	Full width at specified intensity
%	
%	Developement started: 2013
%	Author: Frederik Böhle code@fboehle.de
%
%*********************************************************
%   
%   Description: 
%
%   Notes:
%
%   Changelog:
%
%*********************************************************

function [borderLower, borderHigher] = findBorderIndex(Data, percentage)

    percentage = percentage / 100;
    


        [maxData,maxIndex] = max(Data); %find roughly the center of the peak

    if((min(Data) > max(Data(1:maxIndex)) * percentage) || (min(Data) > max(Data(maxIndex:length(Data))) * percentage))
        borderLower = 1;
        borderHigher = length(Data);
    else
        
        for index = maxIndex:length(Data)
            if(Data(index) < maxData * percentage)
                if((Data(index) + Data(index - 1 )) < 2 * maxData * percentage) %if the average is smaller than the percentage value, the index with the higher value is returned
                    borderHigher = index - 1 ;
                    break;
                else
                    borderHigher = index;
                    break;
                end
            end
        end

        for index = maxIndex:-1:1
            if(Data(index) < maxData * percentage)
                if((Data(index) + Data(index + 1 )) < 2 * maxData*percentage)
                    borderLower = index + 1 ;
                    break;
                else
                    borderLower = index;
                    break;
                end
            end
        end
        
    end