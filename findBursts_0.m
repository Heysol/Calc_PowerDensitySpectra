function burstInfo=findBursts(tfr,tv,freqVector,Fs,plotit)

epochStart=tv(1);
epochEnd=tv(end);
n=size(tfr,2);
%%
if plotit
    figure, hold on
    pcolor(linspace(epochStart,epochEnd,n),freqVector*Fs,log10(tfr));
    colormap jet
    shading interp;
    set(gca,'clim',[1.5 3.8]);
    xlabel('Time [s]'); ylabel('Frequency [Hz]');
    ylim([10,60])
    xlim([epochStart,epochEnd])
end

%%
%tfr_norm=tfr;
%for ii=1:size(tfr_norm,1)
%    tfr_norm(ii,:)=tfr_norm(ii,:)/median(tfr_norm(ii,:));
%end

[~,idx30] = min(abs(freqVector-30/Fs)); %find index of frequency of interest
[~,idx36] = min(abs(freqVector-36/Fs)); %find index of frequency of interest
muPower=median(tfr(idx30:idx36,:));
tfr_norm=tfr./muPower;  

if plotit
    figure,hold on
    pcolor(linspace(epochStart,epochEnd,n),freqVector*Fs,tfr_norm)
    colormap jet
    shading interp;
    ylim([10,60])
    xlim([epochStart,epochEnd])
end
%%
tfr_mask=tfr_norm;
tfr_mask(tfr_mask<6)=0;
tfr_mask(tfr_mask>0)=1;
reshape(tfr_mask,size(tfr));

if plotit
    figure,hold on
    pcolor(linspace(epochStart,epochEnd,n),freqVector*Fs,tfr_mask)
    colormap jet
    shading flat;
    ylim([10,60])
    xlim([epochStart,epochEnd])
end

%%

%%
%{
tfr_mask=tfr;
for ii=1:size(tfr_mask,1)
    thresh=mean(tfr_mask(ii,:))+3*std(tfr_mask(ii,:));
    tfr_mask(ii,tfr_mask(ii,:)<thresh)=0;
    tfr_mask(ii,tfr_mask(ii,:)>=thresh)=1;
end

reshape(tfr_mask,size(tfr));
figure,hold on
pcolor(linspace(epochStart,epochEnd,n),freqVector*Fs,tfr_mask)
colormap jet
shading flat;
%ylim([10,60])
xlim([epochStart,epochEnd])
%}
%%
%%
bursts=bwconncomp(tfr_mask);
burstProps=regionprops(bursts,'Centroid','PixelList');

burstTime=[];
burstFreq=[];
burstStartTime=[];
burstEndTime=[];
burstDuration=[];
burstLowFreq=[];
burstHighFreq=[];
burstFreqSpan=[];

for ii=1:size(burstProps,1)
    % Find Center of Burst
    burstTime(ii)=burstProps(ii).Centroid(1)/2000+epochStart;
    burstFreq(ii)=freqVector(round(burstProps(ii).Centroid(2)))*Fs;
    
    % Measure Burst Duration
    burstStartTime(ii)=min(burstProps(ii).PixelList(:,1))/2000+epochStart;
    burstEndTime(ii)=max(burstProps(ii).PixelList(:,1))/2000+epochStart;
    burstDuration(ii)=burstEndTime(ii)-burstStartTime(ii);
    
    % Measure Burst Frequency Span
    burstLowFreq(ii)=min(burstProps(ii).PixelList(:,2));
    burstHighFreq(ii)=max(burstProps(ii).PixelList(:,2));
    burstFreqSpan(ii)=burstHighFreq(ii)-burstLowFreq(ii)+1;

    % max intensity can also be found under pixel value
end
%peakTime=windowStart+(peakTime./2000);


%%
burstData=[burstTime',burstFreq',burstDuration',burstFreqSpan'];
mask=ones(size(burstData,1),1);

for ii=1:numel(burstDuration)
   minDuration=1/burstFreq(ii)*3;
   if burstDuration(ii)<minDuration
      mask(ii)=0; 
   end
end

mask=logical(mask);
burstData=burstData(mask,:);

burstTime=burstData(:,1);
burstFreq=burstData(:,2);
burstDuration=burstData(:,3);
burstFreqSpan=burstData(:,4);

%%
bursts=struct();
bursts.lowBeta.burstTime=[];
bursts.lowBeta.burstFreq=[];
bursts.lowBeta.burstDuration=[];
bursts.lowBeta.burstFreqSpan=[];
bursts.highBeta.burstTime=[];
bursts.highBeta.burstFreq=[];
bursts.highBeta.burstDuration=[];
bursts.highBeta.burstFreqSpan=[];

for ii=1:numel(burstFreq)
    if burstFreq(ii)>=30 && burstFreq(ii)<=36
        bursts.highBeta.burstTime(end+1)=burstTime(ii);
        bursts.highBeta.burstFreq(end+1)=burstFreq(ii);
        bursts.highBeta.burstDuration(end+1)=burstDuration(ii);
        bursts.highBeta.burstFreqSpan(end+1)=burstFreqSpan(ii);
    end
    if burstFreq(ii)>=20 && burstFreq(ii)<30
        bursts.lowBeta.burstTime(end+1)=burstTime(ii);
        bursts.lowBeta.burstFreq(end+1)=burstFreq(ii);
        bursts.lowBeta.burstDuration(end+1)=burstDuration(ii);
        bursts.lowBeta.burstFreqSpan(end+1)=burstFreqSpan(ii);
    end
end

%%
burstInfo.numPeaks=numel(bursts.highBeta.burstDuration);
burstInfo.muPeakWidth=mean(bursts.highBeta.burstDuration);
burstInfo.muPeakFreq=mean(bursts.highBeta.burstFreq);
burstInfo.muPeakFreqSpan=mean(bursts.highBeta.burstFreqSpan);