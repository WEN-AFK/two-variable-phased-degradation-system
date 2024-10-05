%% Plot the probability distribution
% pdf_wiener=pdf_wiener_r2;
% threshold=13.455; 
% dataset=47;
nn=size(pdf_wiener,1);
iter=5;
aa=find(X2(dataset,:)>=threshold);
dt=0.1;
for i=1:nn
    figure(2);
    plot(1:size(pdf_wiener,2),pdf_wiener(i,:),'b');
    hold on;
    b=max(pdf_wiener(i,:));
    a=(aa(1)-200-(i-1)*iter)*dt;
    [z,x]=max(pdf_wiener(i,:));
    Ture_Lk(i)=sum(pdf_wiener(i,:).*(0.1:0.1:280));
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

CRA_r2=CRA;
AE_r2=AE;
RMSE_r2=RMSE;
save V2_r_result CRA_r2 AE_r2 RMSE_r2
save am.mat amax amin xx a