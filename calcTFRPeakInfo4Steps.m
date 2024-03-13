function [betaPeaks_preRH,betaPeaks_RH,betaPeaks_postRH] = calcTFRPeakInfo4Steps(TFR,timeVector,threshold,RHup,RHdwn)

numStepsRH=length(RHup);

betaPeaks_preRH=struct();
betaPeaks_RH=struct();
betaPeaks_postRH=struct();



for ii=1:numStepsRH
    si_preRH=timeVector>RHup(ii)-1.0 & timeVector<RHup(ii);
    si_RH=timeVector>RHup(ii) & timeVector<RHdwn(ii);
    si_postRH=timeVector>RHdwn(ii) & timeVector<RHdwn(ii)+1.0;
    
    [peaks_preRH,locs_preRH,widths_preRH]=findpeaks(TFR(si_preRH),'minPeakHeight',threshold);
    [peaks_RH,locs_RH,widths_RH]=findpeaks(TFR(si_RH),'minPeakHeight',threshold);
    [peaks_postRH,locs_postRH,widths_postRH]=findpeaks(TFR(si_postRH),'minPeakHeight',threshold);
    
    betaPeaks_preRH.peakRate(ii)=length(peaks_preRH)/sum(si_preRH);
    betaPeaks_RH.peakRate(ii)=length(peaks_RH)/sum(si_RH);
    betaPeaks_postRH.peakRate(ii)=length(peaks_postRH)/sum(si_postRH);

    betaPeaks_preRH.peaks(ii)={peaks_preRH};
    betaPeaks_RH.peaks(ii)={peaks_RH};
    betaPeaks_postRH.peaks(ii)={peaks_postRH};

    betaPeaks_preRH.locs(ii)={locs_preRH};
    betaPeaks_RH.locs(ii)={locs_RH};
    betaPeaks_postRH.locs(ii)={locs_postRH};

    betaPeaks_preRH.widths(ii)={widths_preRH};
    betaPeaks_RH.widths(ii)={widths_RH};
    betaPeaks_postRH.widths(ii)={widths_postRH};
    
end

