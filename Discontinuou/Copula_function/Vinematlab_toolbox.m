clc;
clear; 
close all;
load('pdf_wiener_r1');
load('pdf_wiener_r2');
pdf_wiener_V1=pdf_wiener_r1;
pdf_wiener_V2=pdf_wiener_r2;
pdf_wiener_In=pdf_wiener_V1.*pdf_wiener_V2;
F1=1-cumsum(pdf_wiener_V1,2);
F2=1-cumsum(pdf_wiener_V2,2);
len=size(pdf_wiener_r1,1);


for j=1:len
    for i=1:2800
        if F1(j,i)<0
            F1(j,i)=0.001;
        end
        if F2(j,i)<0
            F2(j,i)=0.001;
        end
        if F1(j,i)==1
            F1(j,i)=0.9999;
        end
        if F2(j,i)==1
            F2(j,i)=0.9999;
        end
    end
end
FF=F1.*F2;


for i=1:len
i;
u1=F1(i,:)';
u2=F2(i,:)';
[pValue(i),TestStat(i)] = PairCopulaIndepTest(u1,u2);
[family(i),ParamHat,rotation] = PairCopulaSelect(u1,u2,'R');
end




for i=1:len
i;
u1=F1(i,:)';
u2=F2(i,:)';
[AIC_Frank(i),Param_Frank(i)] = PairCopulaAIC('Frank',u1,u2);
ParamHat_Frank = PairCopulaFit('Frank',u1,u2);
CDF_Frank(i,:) = PairCopulaCDF('Frank',u1,u2,Param_Frank(i));
PDF_Frank(i,:) = PairCopulaPDF('Frank',u1,u2,Param_Frank(i)).*pdf_wiener_V1(i,:)'.*pdf_wiener_V2(i,:)';
end



for i=1:len
u1=F1(i,:)';
u2=F2(i,:)';
[AIC_Clayton(i),Param_Clayton(i)] = PairCopulaAIC('Clayton',u1,u2);
ParamHat_Clayton = PairCopulaFit('Clayton',u1,u2);
CDF_Clayton(i,:) = PairCopulaCDF('Clayton',u1,u2,Param_Clayton(i));
PDF_Clayton(i,:) = PairCopulaPDF('Clayton',u1,u2,Param_Clayton(i)).*pdf_wiener_V1(i,:)'.*pdf_wiener_V2(i,:)';
end


for i=1:len
u1=F1(i,:)';
u2=F2(i,:)';
[AIC_Gumbel(i),Param_Gumbel(i)] = PairCopulaAIC('Gumbel',u1,u2);
ParamHat_Gumbel = PairCopulaFit('Gumbel',u1,u2);
CDF_Gumbel(i,:) = PairCopulaCDF('Gumbel',u1,u2,Param_Gumbel(i));
PDF_Gumbel(i,:) = PairCopulaPDF('Gumbel',u1,u2,Param_Gumbel(i)).*pdf_wiener_V1(i,:)'.*pdf_wiener_V2(i,:)';
end

for i=1:len
u1=F1(i,:)';
u2=F2(i,:)';
[AIC_Gaussian(i),Param_Gaussian(i)] = PairCopulaAIC('Gaussian',u1,u2);
ParamHat_Gaussian = PairCopulaFit('Gaussian',u1,u2);
CDF_Gaussian(i,:) = PairCopulaCDF('Gaussian',u1,u2,Param_Gaussian(i));
PDF_Gaussian(i,:) = PairCopulaPDF('Gaussian',u1,u2,Param_Gaussian(i)).*pdf_wiener_V1(i,:)'.*pdf_wiener_V2(i,:)';
end


t=0.1:0.1:280;
nn=size(CDF_Gaussian,1);
for i=1:nn
    if rem(i,10)==1
        figure(2)
        subplot(5,4,fix(i/10)+1)
        plot(t,CDF_Frank(i,:),'k','LineWidth',1)
        hold on;
        plot(t,CDF_Clayton(i,:),'r','LineWidth',1.5,'Marker','x','MarkerSize',4)
        hold on;
        plot(t,F1(i,:),'Color',[255 193 37]./255,'LineWidth',1.5)
        hold on;
        plot(t,F2(i,:),'Color',[0 191 255]./255,'LineWidth',1.5)
        hold on;
        plot(t,FF(i,:),'Color',[209 95 238]./255,'LineWidth',1.5)
        hold on; 
        xlim([0 280])
        ylim([0 1])
        legend('Frank copula','Clayton copula','PC1','PC2','Independent','Location','East')
    end
    set(gca,'FontSize',14,'FontWeight','bold' );
end

AIC=[AIC_Clayton;AIC_Frank;AIC_Gaussian;AIC_Gumbel];
figure(1)
plot(AIC(1,:),'LineWidth',1.5);
hold on
plot(AIC(2,:),'LineWidth',1.5);
hold on
plot(AIC(3,:),'LineWidth',1.5);
hold on
plot(AIC(4,:),'LineWidth',1.5);
hold on
legend('Clayton','Frank','Gumbel','Gaussian','Location','East');
set(gca,'FontSize',14,'FontWeight','bold' );