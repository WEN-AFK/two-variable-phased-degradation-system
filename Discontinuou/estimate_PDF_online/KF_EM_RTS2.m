%% initialization parameter
clc;
clear;
load('parameter2.mat');
load('X1.mat');
load('X2.mat');
long=size(X2,2);
dataset=40;
dt=0.1;

change_point_detectiong=0;
miu_1=sum(X_incresing2(dataset,1:40))/40;
sigma_1=sqrt(sum((X_incresing2(dataset,1:40)-miu_1).^2)/40);
miu_2=sum(X_incresing2(dataset,1:40))/40;
sigma_2=sqrt(sum((X_incresing2(dataset,1:40)-miu_2).^2)/40);

for hits=1:long

        if change_point_detectiong==0
            if abs(X_incresing1(dataset,hits))>3*sigma_1 && abs(X_incresing2(dataset,hits))>3*sigma_2
                    miu_before1=sum(X_incresing1(dataset,hits-39:hits))/40;
                    sigma_before1=sqrt(sum((X_incresing1(dataset,hits-39:hits)-miu_before1).^2)/40);
                    miu_after1=sum(X_incresing1(dataset,hits:hits+19))/20;
                    sigma_after1=sqrt(sum((X_incresing1(dataset,hits:hits+19)-miu_after1).^2)/20);

                    miu_before2=sum(X_incresing2(dataset,hits-39:hits))/40;
                    sigma_before2=sqrt(sum((X_incresing2(dataset,hits-39:hits)-miu_before2).^2)/40);
                    miu_after2=sum(X_incresing2(dataset,hits:hits+19))/20;
                    sigma_after2=sqrt(sum((X_incresing2(dataset,hits:hits+19)-miu_after2).^2)/20);

                    if sigma_after1>sigma_before1 && sigma_after2>sigma_before2
                        changep_online=hits;
                        change_point_detectiong=1;
                    end
            end
        elseif change_point_detectiong==1
            break;
        end
end

%% The first phase of the update process
for hits=3:changep_online 
Z_ture=X_incresing2(dataset,:);
F=1; 
Z_0=parameter2(1,1)*0.5;
Z_0_0=parameter2(1,1);
X_0=1.00;
H=0.1;
Q=0.01;
P_0_0=parameter2(1,2);
P_0=parameter2(1,2);
R=parameter2(2,1)^2*0.1;
r=0;

%KF
    for k=1:40
        for t=1:1:hits
        Zk_predict(t)=F*Z_0; 
        Pk_predict{1,t}=F*P_0*F'+Q;       
        S=H*Pk_predict{1,t}*H'+R;
        K{1,t}=Pk_predict{1,t}*H'/(S);
        Zk(t)=Zk_predict(t)+K{1,t}*(Z_ture(t)-H*Zk_predict(t));%
        PK{1,t}=(eye(1)-K{1,t}*H)*Pk_predict{1,t};%

        P_0=PK{1,t};
        Z_0=Zk(t);
        end 

        PKK(1,hits)=P_0;
        ZKK(:,hits)=Z_0;
        
        % RTS
        Z_k(t)=Z_0;
        P_K{1,t}=P_0;
        M_K{1,t}=F*PK{1,t-1}-K{1,t}*H*F*PK{1,t-1};
        
        for t=hits-1:-1:1
            G{1,t}=PK{1,t}*F'/(Pk_predict{1,t+1});
            Z_k(t)=Zk(t)+G{1,t}*(Z_k(t+1)-Zk_predict(t+1));
            P_K{1,t}=PK{1,t}+G{1,t}*(P_K{1,t+1}-Pk_predict{1,t+1})*G{1,t}';
        end
        G_0=P_0_0*F'/(Pk_predict{1,1});
        Z_k_0=Z_0_0+G_0*(Z_k(1)-Zk_predict(1));
        P_K_0=P_0_0+G_0*(P_K{1,1}-Pk_predict{1,1})*G_0';
        
        for t=hits-1:-1:2
        M_K{1,t}=PK{1,t}*G{1,t-1}'+G{1,t}*(M_K{1,t+1}-F*PK{1,t})*G{1,t-1}';
        end
        M_K{1,1}=PK{1,1}*G_0'+G{1,t}*(M_K{1,t+1}-F*PK{1,t})*G_0;
        
        % EM
        Z_0=Z_k_0;
        Z_0_0=Z_k_0;
        lmada(hits)=Z_k_0(1);
        P_0=P_K_0;
        P_0_0=P_K_0;
        P_lmada(hits)=P_K_0(1);       
        for i=1:hits
        R1(i)=(Z_ture(i)^2-2*Z_ture(i)*H*Z_k(i)+H*(Z_k(i)*Z_k(i)'+P_K{1,i})*H')/dt;
        end
        R=sum(R1)/hits;
        RR(hits)=R;


        for i=2:hits
        Q1{1,i}=Z_k(i)*Z_k(i)'+P_K{1,i}-F*(Z_k(i-1)*Z_k(i)'+M_K{1,i})-(Z_k(i)*Z_k(i-1)'+M_K{1,i})*F'+F*(Z_k(i-1)*Z_k(i-1)'+P_K{1,i-1})*F';
        end
        Q1{1,1}=Z_k(1)*Z_k(1)'+P_K{1,1}-F*(Z_k_0*Z_k(1)'+M_K{1,1})-(Z_k(1)*Z_k_0'+M_K{1,1})*F'+F*(Z_k_0*Z_k_0'+P_K_0)*F';
        
        Q2=0;
        for i=1:hits
        Q2=Q2+Q1{1,i};
        end
        Q(1,1)=Q2(1,1)./hits;
        QQ(1,hits)=Q(1,1);     
    end
end

RR1=RR(1:changep_online);
PKK1=PKK(1,1:changep_online);
ZKK1=ZKK(1:changep_online);

%% The second phase of the update process
clc;
clearvars -except changep_online RR1 PKK1 ZKK1 dataset;
load('parameter2.mat');
load('X1.mat');
load('X2.mat');
long=size(X2,2);
dt=0.1;

for hits=3:long-changep_online 
Z_ture=X_incresing2(dataset,changep_online+1:end);
X_0=X1(dataset,changep_online);
F=1; 
H=0.1;
Z_0=parameter2(3,1);
Z_0_0=parameter2(3,1);
Q=0.001;
P_0_0=parameter2(3,2);
P_0=parameter2(3,2);
R=parameter2(4,1)*0.1;
m=((changep_online+1:long)-changep_online);
n=((changep_online:long-1)-changep_online);


%KF
 
    for k=1:40
        for t=1:1:hits
        Zk_predict(t)=F*Z_0; 
        Pk_predict{1,t}=F*P_0*F'+Q;       
        S=H*Pk_predict{1,t}*H'+R;
        K{1,t}=Pk_predict{1,t}*H'/(S);
        Zk(t)=Zk_predict(t)+K{1,t}*(Z_ture(t)-H*Zk_predict(t));%
        PK{1,t}=(eye(1)-K{1,t}*H)*Pk_predict{1,t};%

        P_0=PK{1,t};
        Z_0=Zk(t);
        end 

        PKK(1,hits)=P_0;
        ZKK(:,hits)=Z_0;
        
        % RTS
        Z_k(t)=Z_0;
        P_K{1,t}=P_0;
        M_K{1,t}=F*PK{1,t-1}-K{1,t}*H*F*PK{1,t-1};
        
        for t=hits-1:-1:1
            G{1,t}=PK{1,t}*F'/(Pk_predict{1,t+1});
            Z_k(t)=Zk(t)+G{1,t}*(Z_k(t+1)-Zk_predict(t+1));
            P_K{1,t}=PK{1,t}+G{1,t}*(P_K{1,t+1}-Pk_predict{1,t+1})*G{1,t}';
        end
        G_0=P_0_0*F'/(Pk_predict{1,1});
        Z_k_0=Z_0_0+G_0*(Z_k(1)-Zk_predict(1));
        P_K_0=P_0_0+G_0*(P_K{1,1}-Pk_predict{1,1})*G_0';
        
        for t=hits-1:-1:2
        M_K{1,t}=PK{1,t}*G{1,t-1}'+G{1,t}*(M_K{1,t+1}-F*PK{1,t})*G{1,t-1}';
        end
        M_K{1,1}=PK{1,1}*G_0'+G{1,t}*(M_K{1,t+1}-F*PK{1,t})*G_0;
        
        % EM
        Z_0=Z_k_0;
        Z_0_0=Z_k_0;
        lmada(hits)=Z_k_0(1);
        P_0=P_K_0;
        P_0_0=P_K_0;
        P_lmada(hits)=P_K_0(1);       
        for i=1:hits
        R1(i)=(Z_ture(i)^2-2*Z_ture(i)*H*Z_k(i)+H*(Z_k(i)*Z_k(i)'+P_K{1,i})*H')/dt;
        end
        R=sum(R1)/hits;
        RR(hits)=R;


        for i=2:hits
        Q1{1,i}=Z_k(i)*Z_k(i)'+P_K{1,i}-F*(Z_k(i-1)*Z_k(i)'+M_K{1,i})-(Z_k(i)*Z_k(i-1)'+M_K{1,i})*F'+F*(Z_k(i-1)*Z_k(i-1)'+P_K{1,i-1})*F';
        end
        Q1{1,1}=Z_k(1)*Z_k(1)'+P_K{1,1}-F*(Z_k_0*Z_k(1)'+M_K{1,1})-(Z_k(1)*Z_k_0'+M_K{1,1})*F'+F*(Z_k_0*Z_k_0'+P_K_0)*F';
        
        Q2=0;
        for i=1:hits
        Q2=Q2+Q1{1,i};
        end
        Q(1,1)=Q2(1,1)./hits;
        QQ(1,hits)=Q(1,1);     
    end
end

RR1=[RR1,RR];
PKK1=[PKK1,P_lmada];
ZKK1=[ZKK1,lmada];