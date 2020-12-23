function [ h1, pred, ptime ] = F_corplot(data, pred, dtime, ptime)
% F_corplot: This function produces a correlation scatter plot of the
% processed cable voltage data and the predicted voltage signal
%   INPUTS:
%       - data: the processed cable voltage data
%       - pred: the predicted cable voltage data (likely is a different
%               length than data)
%       - dtime: time series corresponding to the processed cable voltage data
%       - ptime: time series corresponding to the predicted cable voltage data

% dataq = interp1(dtime,data,ptime);
%%
% Get the indices of all the times that overlap between the prediction and
% observation
spots=[];
badind=[];
counter= 1;
for i=1:length(ptime)
   temp = find((dtime) == ptime(i)); % for HAW3, -(30/(24*60)) from dtime
   if size(temp) > 0
       spots(counter) = temp;
       counter = counter + 1;
   else % save the indices where ptime isn't in dtime
       badind=[badind; i];
   end
end

% Tailor the prediction time series to start/end at the same time as the
% data series

ptime(badind)=[];
pred(badind)=[];

% sp = find(ptime == dtime(spots(1)));
% ep = find(ptime == dtime(spots(end)));

[b,stats] = robustfit(data(spots), pred);
disp(b)

h1= figure(1)
plot(data(spots),pred,'ok'); hold on
plot(data(spots),b(1)+b(2)*data(spots),'k')
string=['y=' num2str(b(1)) '+' num2str(b(2)) 'x'];
text(min(data),max(pred),string,'FontSize',14)
set(gca,'FontSize',16)
xlabel('cable data [V]')
ylabel('cable pred [V]')

end

