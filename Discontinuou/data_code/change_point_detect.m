clc;
clear;
load('X1.mat')
load('X2.mat')
T=100;


[m,n]=size(X_incresing1);
for i=1:m
miu_1=sum(X_incresing1(i,1:40))/40;
sigma_1=sqrt(sum((X_incresing1(i,1:40)-miu_1).^2)/40);

miu_2=sum(X_incresing2(i,1:40))/40;
sigma_2=sqrt(sum((X_incresing2(i,1:40)-miu_2).^2)/40);

change_point_detectiong=0;

for j=1:n
    if change_point_detectiong==0
        if abs(X_incresing1(i,j))>4*sigma_1 && abs(X_incresing2(i,j))>4*sigma_2
                miu_before1=sum(X_incresing1(i,j-39:j))/40;
                sigma_before1=sqrt(sum((X_incresing1(i,j-39:j)-miu_before1).^2)/40);
                miu_after1=sum(X_incresing1(i,j:j+19))/20;
                sigma_after1=sqrt(sum((X_incresing1(i,j:j+19)-miu_after1).^2)/20);
                
                miu_before2=sum(X_incresing2(i,j-39:j))/40;
                sigma_before2=sqrt(sum((X_incresing2(i,j-39:j)-miu_before2).^2)/40);
                miu_after2=sum(X_incresing2(i,j:j+19))/20;
                sigma_after2=sqrt(sum((X_incresing2(i,j:j+19)-miu_after2).^2)/20);
 
                if sigma_after1>sigma_before1 && sigma_after2>sigma_before2
                    changepoint(i)=j;
                    change_gamma1(i)=X_incresing1(i,j);
                    change_gamma2(i)=X_incresing2(i,j);
                    change_point_detectiong=1;
                end
        end
    elseif change_point_detectiong==1
        break;
    end
end

% figure(i)    
% subplot(2,1,1)    
% plot(0.1:0.1:T,X_incresing1(i,:),'r')
% hold on  
% line([0 100],[3*sigma_1 3*sigma_1],'linestyle','-', 'Color','r', 'LineWidth', 2);
% line([0 100],[-3*sigma_1 -3*sigma_1],'linestyle','-', 'Color','r', 'LineWidth', 2);
% xlabel('Times(m)')
% ylabel('Bearing1_2_feature')
% 
% subplot(2,1,2)    
% plot(0.1:0.1:T,X_incresing2(i,:),'b')
% hold on
% line([0 100],[3*sigma_2 3*sigma_2],'linestyle','-', 'Color','b', 'LineWidth', 2);
% line([0 100],[-3*sigma_2 -3*sigma_2],'linestyle','-', 'Color','b', 'LineWidth', 2);
% xlabel('Times(m)')
% ylabel('Bearing1_2_feature')
end

changepoint=changepoint./10;
save change_gamma1.mat change_gamma1
save change_gamma2.mat change_gamma2
save changepoint.mat changepoint

