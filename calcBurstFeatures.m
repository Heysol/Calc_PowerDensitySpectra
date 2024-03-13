function burstFeatures=calcBurstFeatures(tfr_norm,timeVector,freqVector,Fs,thresh)

% Threshold TFR
[tfr_thresh]=thresholdTFR_norm(tfr_norm,thresh);
        
bursts=bwconncomp(tfr_thresh);
%burstProps=regionprops(bursts,'Centroid','PixelList');
burstProps=regionprops(bursts,'PixelList');

burstTime=nan(size(burstProps,1),1);
burstFreq=nan(size(burstProps,1),1);
burstMag=nan(size(burstProps,1),1);
maxPixelIdx=nan(size(burstProps,1),1);
burstStartTime=nan(size(burstProps,1),1);
burstEndTime=nan(size(burstProps,1),1);
burstDuration=nan(size(burstProps,1),1);
burstLowFreq=nan(size(burstProps,1),1);
burstHighFreq=nan(size(burstProps,1),1);
burstFreqSpan=nan(size(burstProps,1),1);

for ii=1:size(burstProps,1)   
    % Find Peak of Burst - Calculate Burst Magnitude
    burstTimes=burstProps(ii).PixelList(:,1);
    burstFreqs=burstProps(ii).PixelList(:,2);
    [burstMag(ii),maxPixelIdx(ii)]=calcBurstMag(tfr_norm,burstTimes,burstFreqs);
    
    % Find Center of Burst
    %burstTime(ii)=timeVector(1)+(burstProps(ii).Centroid(1)/Fs);
    %burstFreq(ii)=freqVector(round(burstProps(ii).Centroid(2)))*Fs;
    burstTime(ii)=timeVector(1)+(burstTimes(maxPixelIdx(ii))/Fs);
    burstFreq(ii)=freqVector(burstFreqs(maxPixelIdx(ii)))*Fs;
    
    % Measure Burst Duration
    burstStartTime(ii)=timeVector(1)+(min(burstProps(ii).PixelList(:,1))/2000);
    burstEndTime(ii)=timeVector(1)+(max(burstProps(ii).PixelList(:,1))/2000);
    burstDuration(ii)=burstEndTime(ii)-burstStartTime(ii);
    
    % Measure Burst Frequency Span
    burstLowFreq(ii)=freqVector(min(burstProps(ii).PixelList(:,2)))*Fs;
    burstHighFreq(ii)=freqVector(max(burstProps(ii).PixelList(:,2)))*Fs;
    burstFreqSpan(ii)=burstHighFreq(ii)-burstLowFreq(ii)+1;


        
end

% Creat Data Structure
burstFeatures.burstTime=burstTime;
burstFeatures.burstFreq=burstFreq;
%burstFeatures.burstMag=nan(size(burstProps,1),1);
burstFeatures.burstMag=burstMag;
burstFeatures.burstDuration=burstDuration;
burstFeatures.burstFreqSpan=burstFreqSpan;

% Remove Bursts shorter than 3 cycles
burstFeatures=removeShortBursts(burstFeatures);
