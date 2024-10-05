%% 仿真具有时变随机跳变的退化过程
clc; 
clear all;
load('tau.mat')
%% 数据仿真这个地方还是要研究一下
for j=1:100
    X0=2.5;
    T=100;
    dt=0.1;
    N=T/dt;
    
    sigma_B_1=0.04;
    miu_lmada_1=0.011;
    sigma_lmada_1=0.001;
    lmada_1=normrnd(miu_lmada_1,sigma_lmada_1);
    
    sigma_B_2=0.40;
    miu_lmada_2=0.40;
    sigma_lmada_2=0.002;
    lmada_2=normrnd(miu_lmada_2,sigma_lmada_2);
    
    sigma_o=0.002;
   
    S=randn(1,N);
    dx=sqrt(dt)*S;
    
    % 给定跳变的位置与大小
%     tau=normrnd(miu_tau,sigma_trau,1);
    phase1=1;
    phase2=0;


    for i=1:N      
        if i/10==fix(tau(j))
            X2(j,i)=X2(j,i-1)++lmada_2*dt+sigma_B_2*dx(i);
            X_incresing2(j,i)=+lmada_2*dt+sigma_B_2*dx(i);
            phase2=1;
            phase1=0;
        elseif i==1
            lmada_1=lmada_1;
            X2(j,i)= X0+lmada_1*dt+sigma_B_1*dx(i);
            X_incresing2(j,i)=X2(j,i)-X0;    
        elseif  phase1==1 && phase2==0 
            lmada_1=lmada_1;
            X2(j,i)= X2(j,i-1)+lmada_1*dt+sigma_B_1*dx(i);
            X_incresing2(j,i)=X2(j,i)-X2(j,i-1);
            lmada_all(j,i)=lmada_1;
        elseif phase1==0 && phase2==1
            lmada_2=lmada_2;
            X2(j,i)= X2(j,i-1)+lmada_2*dt+sigma_B_2*dx(i);
            X_incresing2(j,i)=X2(j,i)-X2(j,i-1);
            lmada_all(j,i)=lmada_2;
        end
        
    end
    figure(1)
    plot(0.1:0.1:T,X2(j,:));
    hold on
    figure(2)
    plot(0.1:0.1:T,X_incresing2(j,:));
    hold on
end


figure(1)
plot(0.1:0.1:T,X2(47,:),"Color",'r','LineWidth',2.5); 
hold on
xlabel('Time');
ylabel('Degradation state')
set(gca,'FontSize',44,'FontWeight','bold' );
axis on

save  X2.mat X2 X_incresing2