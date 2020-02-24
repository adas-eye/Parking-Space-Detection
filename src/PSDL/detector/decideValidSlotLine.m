function [valid, type, orientation] = decideValidSlotLine(firstKP, secKP, image, gabor, ...
                                                        halfGaussianWidth,...
                                                        threshForRespRatioForValidSlotLine,...
                                                        matchedGaborRespThreshSeparator, matchedGaborRespThreshBridge,...
                                                        sumOfGaborRespTwoBridgesThreh,...
                                                        sumOfGaborRespTwoSeparatorsThreh,...
                                                        KPScoreSumThresh)
%this function decides whether the two points firstKP and secKP can form a
%valid parking slot candiate on the give image
% valid is TRUE or FALSE, indicating whether the two points can form a
% higly possible parking slot line
% type is an integer value. type = 1 means the line is the "short side" of
% the underground park. type = 2 means the line is the "long side" of the
% on-ground park
% orientation is 0 or 1. 0 means the slot orientation is anti-clockwise
% while 1 means that the slot orientation is clockwise. The orientation of
% the slot is with respect to the vector from the first KP pointing to the
% second KP. 

%at first, calculate their distance. 
% distSquare = (firstKP(1) - secKP(1))^2 + (firstKP(2) - secKP(2))^2;
distSquare = sum((firstKP(1:2)-secKP(1:2)).^2);

%underground park or on-ground stardard slot (), short side. type = 1
forStandardSlotShortSideMin = 66.65; %canot be greater than 139.5
forStandardSlotShortSideMax = 98.75; %cannot be smaller than 193.5

%on-ground park for long bus, long side. type = 2
forLongBusSlotLongSideMin = 180.0; %
forLongBusSlotLongSideMax = 198.5;

%standard slot, long side. type = 3
forStandardSlotLongSideMin = 135;
forStandardSlotLongSideMax = 172.01;

valid = false;
type = 0;
orientation = 0;
%it should be noted that if valid=false, the values for type and
%orientation do not make any sense.

if distSquare>forStandardSlotShortSideMin^2 && distSquare<forStandardSlotShortSideMax^2 %standard slot, short side
    [respAnticlock1, respAnticlock2, respClock1, respClock2, alongLineResp1, alongLineResp2] ...
        = calGaborRespToDecideSlotDirection(firstKP, secKP, gabor, ...
                                                                       halfGaussianWidth, image);
    
    [valid, orientation] = deterValOfLineUsingGaborResp(firstKP(3), secKP(3), respAnticlock1, respAnticlock2, respClock1, respClock2, ...
                                                                                         alongLineResp1, alongLineResp2,...
                                                                                         threshForRespRatioForValidSlotLine,...
                                                                                         matchedGaborRespThreshSeparator, matchedGaborRespThreshBridge,...
                                                                                         sumOfGaborRespTwoBridgesThreh,...
                                                                                         sumOfGaborRespTwoSeparatorsThreh,...
                                                                                         KPScoreSumThresh);
    type = 1;                                                      
        
elseif distSquare>forLongBusSlotLongSideMin^2 && distSquare<forLongBusSlotLongSideMax^2 %long bus slot, long side
    [respAnticlock1, respAnticlock2, respClock1, respClock2, alongLineResp1, alongLineResp2] = ...
        calGaborRespToDecideSlotDirection(firstKP, secKP, gabor, ...
                                                                    halfGaussianWidth, image);
    
   [valid, orientation] = deterValOfLineUsingGaborResp(firstKP(3), secKP(3), respAnticlock1, respAnticlock2, respClock1, respClock2, ...
                                                                                         alongLineResp1, alongLineResp2,...
                                                                                         threshForRespRatioForValidSlotLine, ...
                                                                                         matchedGaborRespThreshSeparator, matchedGaborRespThreshBridge,...
                                                                                         sumOfGaborRespTwoBridgesThreh,...
                                                                                         sumOfGaborRespTwoSeparatorsThreh,...
                                                                                         KPScoreSumThresh);
                                                                                     
   type = 2;      
elseif distSquare>forStandardSlotLongSideMin^2 && distSquare<forStandardSlotLongSideMax^2 %standard slot, long side
    [respAnticlock1, respAnticlock2, respClock1, respClock2, alongLineResp1, alongLineResp2] = ...
        calGaborRespToDecideSlotDirection(firstKP, secKP, gabor, ...
                                                                    halfGaussianWidth, image);
    
    [valid, orientation] = deterValOfLineUsingGaborResp(firstKP(3), secKP(3), respAnticlock1, respAnticlock2, respClock1, respClock2, ...
                                                                                         alongLineResp1, alongLineResp2,...
                                                                                         threshForRespRatioForValidSlotLine, ...
                                                                                         matchedGaborRespThreshSeparator, matchedGaborRespThreshBridge,...
                                                                                         sumOfGaborRespTwoBridgesThreh,...
                                                                                         sumOfGaborRespTwoSeparatorsThreh,...
                                                                                         KPScoreSumThresh);
                                                                                     
    type = 3;      
end
