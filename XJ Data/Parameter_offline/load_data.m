% load Bearing_Alldate;
% % % 读取载入的所有变量，并计算x的增量
% result = whos;
% for i=1:17
% eval(['y=',result(i).name,'.Max(:,1)']);
% [m,n]=size(y);
%     for j=1:m-1
%         bearing_incresing_1(i,j)=y(j+1)-y(j);
%     end
% end
% 
% for i=1:17
% eval(['y=',result(i).name,'.Max(:,2)']);
% [m,n]=size(y);
%     for j=1:m-1
%         bearing_incresing_2(i,j)=y(j+1)-y(j);
%     end
% end
% 
% figure(1);
% for i=1:17
%     subplot(6,3,i);
%     a=find(bearing_incresing_1(i,:)==0);
%     if size(a,2)==0
%         plot(bearing_incresing_1(i,:))
%     else
%         plot(bearing_incresing_1(i,1:a(1)-1));
%     end
%     xlabel('Times(m)');
%     ylabel('incresing');
% end
% 
% 
% figure(2);
% for i=1:17
%     subplot(6,3,i);
%     a=find(bearing_incresing_2(i,:)==0);
%     if size(a,2)==0
%         plot(bearing_incresing_2(i,:))
%     else
%         plot(bearing_incresing_2(i,1:a(1)-1));
%     end
%     xlabel('Times(m)');
%     ylabel('incresing');
% end



clc;
clear;
load XJ_Bearing_feature;
result = whos;
for i=1:15
% eval(['y=',result(i).name,'.Max(:,1)']);
eval(['y=',result(i).name,'.Energies_of_sixteen_bands.E5(:,15)']);
[m,n]=size(y);
    for j=1:m-1
        bearing_incresing_1(i,j)=y(j+1)-y(j);
    end
end

for i=1:15
% eval(['y=',result(i).name,'.Max(:,2)']);
eval(['y=',result(i).name,'.Energies_of_sixteen_bands.E6(:,15)']);
[m,n]=size(y);
    for j=1:m-1
        bearing_incresing_2(i,j)=y(j+1)-y(j);
    end
end

figure(1);
for i=1:15
    subplot(5,3,i);
    a=find(bearing_incresing_1(i,:)==0);
    if size(a,2)==0
        plot(bearing_incresing_1(i,:))
    else
        plot(bearing_incresing_1(i,1:a(1)-1));
    end
    xlabel('Times(m)');
    ylabel('incresing');
end


figure(2);
for i=1:15
    subplot(5,3,i);
    a=find(bearing_incresing_2(i,:)==0);
    if size(a,2)==0
        plot(bearing_incresing_2(i,:))
    else
        plot(bearing_incresing_2(i,1:a(1)-1));
    end
    xlabel('Times(m)');
    ylabel('incresing');
end
save XJ_Bearing_increasing.mat bearing_incresing_1 bearing_incresing_2

