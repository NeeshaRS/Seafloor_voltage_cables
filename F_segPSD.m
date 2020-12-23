function [minV, maxV, index, segPSD ] = F_segPSD( data_segments )
% F_segPSD: This determines which of the NaN-free data segments is longest,
% then uses that segment to produce a power spectral density using the PMTM method.
%   INPUTS: 
%       data_segments- a structure that has each of the corresponding data
%       and time series NaN-free segments
%   OUTPUTS:
%       segPSD: the power spectra density of the segment
%       max: the max segment length
%       min: the min segment length

% Determine the number of segments
sizeD=size(data_segments.data);
n = sizeD(2);

% Initialize the array of segment lengths
segLength=zeros(n,1);

% Determine the length of each segment & save it
for i=1:n
    temp=size(data_segments.data{i});
    segLength(i)=temp(2);
end

% Determine the max & min segment length. Save the index of the max length
% segment.
[maxV, index]= max(segLength);
minV= min(segLength);

% Save the max length segment to produce the PSD
data= data_segments.data{index};
time= data_segments.time{index};

% Producing the PSD
NW=2; %2, 5/2, 3, 7/2, 4 are the typical values
NFFT=2*600*60; % 2 month window
Fr=1/3600; % Sampling frequency, 1 per hour
% Determining the PSD
[P,Pc,f]=pmtm(data,NW,NFFT,Fr);
% Determining the power amplitudes
Amp=zeros(length(P),1);
for i=1:length(P)
   Amp(i,1)=(2*P(i,1)*(Fr/NFFT));
end
% Determining the periods
T=zeros(length(f)-1,1);
for i=2:length(f)
   T(i-1)=(1/f(i))*(Fr)*(1/24);
end

% Plotting
segPSD = figure(1);
set(segPSD,'Position',[100 100 500 900],'PaperPositionMode','auto');
subplot(211)
semilogy(T,P(2:end),'k','LineWidth',2); hold on
set(gca,'FontSize',16)
axis([0 3 10^0 10^8])
xlabel('Period (Days)')
ylabel('Power/Frequency (nT^2/Hz)')
% Plotting the tidal lines as a double check
periods=[4 4.8 6 8 11.967236 12 12.421 12.6583 23.934472 24 24.066 25.891]/24;
period_string=['S6';'S5';'S4';'S3';'K2';'S2';'M2';'N2';'K1';'S1';'P1';'O1'];
a = axis;
for kk=1:length(periods)
   line([periods(kk) periods(kk)],[a(3) a(4)],'LineStyle','--','color','b') 
end
subplot(212)
semilogy(T,P(2:end),'k','LineWidth',2); hold on
set(gca,'FontSize',16)
axis([0 500 10^0 10^8])
xlabel('Period (Days)')
ylabel('Power/Frequency (nT^2/Hz)')

end

