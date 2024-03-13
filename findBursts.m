function [peakTime,peakFreq]=findBursts(tfr_thresholded,timeVector,freqVector,Fs)

bursts=bwconncomp(tfr_thresholded);
burstProps=regionprops(bursts,'Centroid','PixelList','MaxIntensity');

burstTime=nan(size(burstProps,1),1);
burstFreq=nan(size(burstProps,1),1);
burstMag=nan(size(burstProps,1),1);
burstStartTime=nan(size(burstProps,1),1);
burstEndTime=nan(size(burstProps,1),1);
burstDuration=nan(size(burstProps,1),1);
burstLowFreq=nan(size(burstProps,1),1);
burstHighFreq=nan(size(burstProps,1),1);
burstFreqSpan=nan(size(burstProps,1),1);

for ii=1:size(burstProps,1)
    % Find Center of Burst
    burstTime(ii)=timeVector(1)+(burstProps(ii).Centroid(1)/Fs);
    burstFreq(ii)=freqVector(round(burstProps(ii).Centroid(2)))*Fs;
    
    % Find Max Intensity
    burstMag(ii)=burstProps(ii).MaxIntensity;
    
    % Measure Burst Duration
    burstStartTime(ii)=timeVector(1)+(min(burstProps(ii).PixelList(:,1))/2000);
    burstEndTime(ii)=timeVector(1)+(max(burstProps(ii).PixelList(:,1))/2000);
    burstDuration(ii)=burstEndTime(ii)-burstStartTime(ii);
    
    % Measure Burst Frequency Span
    burstLowFreq(ii)=min(burstProps(ii).PixelList(:,2));
    burstHighFreq(ii)=max(burstProps(ii).PixelList(:,2));
    burstFreqSpan(ii)=burstHighFreq(ii)-burstLowFreq(ii)+1;

end