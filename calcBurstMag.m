function [burstMag,maxPixelIdx]=calcBurstMag(tfr_norm,burstTime,burstFreq)

pixelMag=nan(numel(burstTime),1);
for ii=1:numel(burstTime)
    pixelMag(ii)=tfr_norm(burstFreq(ii),burstTime(ii));
end
[burstMag,maxPixelIdx]=max(pixelMag);
    