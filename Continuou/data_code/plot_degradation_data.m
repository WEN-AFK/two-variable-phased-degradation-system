load('X1.mat');
load('X2.mat');
T=100;
for j=1:100   
    figure(1)
    P1=plot(0.1:0.1:T,X1(j,:),'Color',[220 220 220]/255);
    hold on
end
plot(0.1:0.1:T,X1(47,:),"Color",'r','LineWidth',2.5); 
hold on
xlabel('Time');
ylabel('Degradation state')
legend(P1,'PC1');
set(gca,'FontSize',24,'FontWeight','bold' );
axis on

for j=1:100   
    figure(2)
    P2=plot(0.1:0.1:T,X2(j,:),'Color',[220 220 220]/255);
    hold on
end
plot(0.1:0.1:T,X2(47,:),"Color",'r','LineWidth',2.5); 
hold on
xlabel('Time');
ylabel('Degradation state')
legend(P2,'PC2');
set(gca,'FontSize',24,'FontWeight','bold' );
axis on

