%% Plot the probability distribution
% load('Bearing_feature.mat');
% load('pdf_wiener_r1_2.mat');
% dataset=1;
% pdf_wiener=pdf_wiener_r1_2;
nn=size(pdf_wiener,1);
iter=1;
aa=find(Bearing2_feature(dataset,:)>=threshold);
dt=1;
for i=1:nn
    figure(2);
    plot(1:size(pdf_wiener,2),pdf_wiener(i,:),'b');
    hold on;
    b=max(pdf_wiener(i,:));
    a=(aa(1)-30-(i-1)*iter)*dt;
    [z,x]=max(pdf_wiener(i,:));
    Ture_Lk(i)=sum(pdf_wiener(i,:).*(1:1:370));
    plot(x,z,'o'); 
    line([a a],[0 b*1.5],'linestyle','-', 'Color','r', 'LineWidth', 1);
    xlabel('RUL');
    ylabel('PDF');
    error(i)=(a-x);
end


amax=a+a.*0.2;
amin=a-a.*0.2;
error=abs(a-Ture_Lk);
RMSE=sqrt(sum((a-x).^2)/size(a,2));
AE=error;
CRA=sum(1-AE./a)/nn;


%% bearing1-1
% CRA_r1_2=CRA;
% AE_r1_2=AE;
% RMSE_r1_2=RMSE;
% save V1_2_r_result CRA_r1_2 AE_r1_2 RMSE_r1_2

%% bearing1-2
CRA_r2_2=CRA;
AE_r2_2=AE;
RMSE_r2_2=RMSE;
save V2_2_r_result CRA_r2_2 AE_r2_2 RMSE_r2_2

%% bearing1-3
% CRA_r3_2=CRA;
% AE_r3_2=AE;
% RMSE_r3_2=RMSE;
% save V3_2_r_result CRA_r3_2 AE_r3_2 RMSE_r3_2

%% bearing2-2
% CRA_r4_2=CRA;
% AE_r4_2=AE;
% RMSE_r4_2=RMSE;
% save V4_2_r_result CRA_r4_2 AE_r4_2 RMSE_r4_2