clc;
clear;
load('Bearing_feature.mat')
load('bear_in.mat')

[m,n]=size(bear_in1);
for i=1:m
miu_1=sum(bear_in1(i,1:20))/20;
sigma_1=sqrt(sum((bear_in1(i,1:20)-miu_1).^2)/20);

miu_2=sum(bear_in2(i,1:20))/20;
sigma_2=sqrt(sum((bear_in2(i,1:20)-miu_2).^2)/20);

change_point_detectiong=0;
% if i==5
%     continue;
% end
n=find(bear_in1(i,:)>0);

for j=18:n(end)
    if change_point_detectiong==0
        if abs(bear_in1(i,j))>3*sigma_1 && abs(bear_in2(i,j))>3*sigma_2
                miu_before1=sum(bear_in1(i,j-19:j))/20;
                sigma_before1=sqrt(sum((bear_in1(i,j-19:j)-miu_before1).^2)/20);
                miu_after1=sum(bear_in1(i,j:j+19))/20;
                sigma_after1=sqrt(sum((bear_in1(i,j:j+19)-miu_after1).^2)/20);
                
                miu_before2=sum(bear_in2(i,j-19:j))/20;
                sigma_before2=sqrt(sum((bear_in2(i,j-19:j)-miu_before2).^2)/20);
                miu_after2=sum(bear_in2(i,j:j+19))/20;
                sigma_after2=sqrt(sum((bear_in2(i,j:j+19)-miu_after2).^2)/20);
 
                if sigma_after1>sigma_before1 && sigma_after2>sigma_before2
                    changepoint(i)=j;
                    change_point_detectiong=1;
                end
        end
    elseif change_point_detectiong==1
        break;
    end
end
end

changepoint=changepoint;
save changepoint.mat changepoint

