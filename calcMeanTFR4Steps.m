
function [meanTFR_preRH,meanTFR_RH,meanTFR_postRH]=calcMeanTFR4Steps(TFR,timeVector,RHup,RHdwn)

numStepsRH=length(RHup);
meanTFR_preRH=nan(numStepsRH,1);
meanTFR_RH=nan(numStepsRH,1);
meanTFR_postRH=nan(numStepsRH,1);

for ii=1:numStepsRH
    si_preRH=timeVector>RHup(ii)-1.0 & timeVector<RHup(ii);
    si_RH=timeVector>RHup(ii) & timeVector<RHdwn(ii);
    si_postRH=timeVector>RHdwn(ii) & timeVector<RHdwn(ii)+1.0;

    meanTFR_preRH(ii)=mean(TFR(si_preRH));
    meanTFR_RH(ii)=mean(TFR(si_RH));
    meanTFR_postRH(ii)=mean(TFR(si_postRH));
end


