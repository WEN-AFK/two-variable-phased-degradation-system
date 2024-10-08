%% PDF
close all
load('parameter2.mat');
% threshold=5100.00;%bearing1-1
threshold=10000.00;%bearing1-2
% threshold=3300.00;%bearing1-3
% threshold=2800.00;%bearing2-2

i=1;
for Tk=30:1:long
    Xk=(Bearing2_feature(dataset,Tk));
    if Xk>=threshold
        break;
    end  

    if Tk>=changep_online 
        Theta1=sqrt(PKK1(1,Tk));
        lmada=ZKK1(1,Tk);
        sigma_B2=RR1(1,Tk);
        for Lk=1:400-Tk
            w1=(threshold-Xk);
            F1=w1;        
            F2=sqrt(2*pi*(Lk*dt)^3*(Lk*dt*Theta1^2+sigma_B2));   
            F3=exp(-(threshold-Xk-Lk*dt*lmada).^2./(2*Lk*dt*(Lk*dt*Theta1^2+sigma_B2)));
            F=F1./F2.*F3*dt;
            pdf_wiener(i,Lk)=F;

            if pdf_wiener(i,Lk)<=0
                1;
            end
        end
        
    elseif Tk<changep_online
        j=1;
        clear pdf_wiener11;
        pdf_wiener11=zeros(1,370);
        for tau=Tk:1:300
               for Lk=1:400-Tk
                if Tk+Lk<=tau 
                    Theta1=sqrt(PKK1(1,Tk));
                    lmada=ZKK1(1,Tk);
                    sigma_B2=RR1(1,Tk);
                    w1=(threshold-Xk);
                    F1=w1;        
                    F2=sqrt(2*pi*(Lk*dt)^3*(Lk*dt*Theta1^2+sigma_B2));   
                    F3=exp(-(threshold-Xk-Lk*dt*lmada).^2./(2*Lk*dt*(Lk*dt*Theta1^2+sigma_B2)));
                    F=F1./F2.*F3*dt;
                    pdf_wiener11(j,Lk)=F;
                elseif Tk+Lk>tau 
                    Theta_1=sqrt(PKK1(1,Tk));
                    lmada_1=ZKK1(1,Tk);
                    sigma_B_1=RR1(1,Tk);
                    Theta_2=parameter2(3,2);
                    lmada_2=parameter2(3,1);
                    sigma_B_2=parameter2(4,1)^2;

                    TT1=(Tk+Lk-tau)*dt;
                    TT2=(tau-Tk)*dt;
                    miu_A3=lmada_2*TT1;
                    sigma_A3=Theta_2^2*TT1^2+sigma_B_2*TT1; 
                    miu_B3=threshold-Xk-lmada_1*TT2;
                    sigma_B3=Theta_1*TT2^2+sigma_B_1*TT2;                
                    miu_A4=lmada_2*TT1;
                    sigma_A4=Theta_2^2*TT1^2+sigma_B_2*TT1;
                    miu_B4=Xk-threshold-lmada_1*TT2-(2*(threshold-Xk)*Theta_1*TT2)/sigma_B_1;
                    sigma_B4=Theta_1*TT2^2+sigma_B_1*TT2; 
                    K1=normcdf((miu_B3*sigma_A3+miu_A3*sigma_B3)/sqrt(sigma_A3*sigma_B3*(sigma_A3+sigma_B3)));
                    K2=normpdf((miu_B3*sigma_A3+miu_A3*sigma_B3)/sqrt(sigma_A3*sigma_B3*(sigma_A3+sigma_B3)));
                    K3=normcdf((miu_B4*sigma_A4+miu_A4*sigma_B4)/sqrt(sigma_A4*sigma_B4*(sigma_A4+sigma_B4)));
                    K4=normpdf((miu_B4*sigma_A4+miu_A4*sigma_B4)/sqrt(sigma_A4*sigma_B4*(sigma_A4+sigma_B4)));
                    if K1<(10^(-20))
                        K1=0; 
                    end

                    if K2<(10^(-20))
                        K2=0;
                    end

                    if K3<(10^(-20))
                        K3=0;
                    end

                    if K4<(10^(-20))
                       K4=0; 
                    end

                    F1=(miu_B3*sigma_A3+miu_A3*sigma_B3)/(sigma_A3+sigma_B3)*K1+sqrt(sigma_A3*sigma_B3/(sigma_A3+sigma_B3))*K2;
                    F2=1/sqrt(2*pi*TT1^2*(sigma_A3+sigma_B3))*exp(-(miu_A3-miu_B3)^2/2.0/(sigma_A3+sigma_B3));
                    F3=(miu_B4*sigma_A4+miu_A4*sigma_B4)/(sigma_A4+sigma_B4)*K3+sqrt(sigma_A4*sigma_B4/(sigma_A4+sigma_B4))*K4;
                    F5=log(1/sqrt(2*pi*TT1^2*(sigma_A4+sigma_B4)));
                    F6=-(miu_A4-miu_B4)^2/2.0/(sigma_A4+sigma_B4);
                    F7=(2*lmada_1*(threshold-Xk))/sigma_B_1+((2*sigma_B_1*Theta_1*(threshold-Xk)^2)+2*(threshold-Xk)^2*Theta_1^2*TT2)/(sigma_B_1^2*(TT2*Theta_1+sigma_B_1));
                    F4=1/sqrt(2*pi*TT1^2*(sigma_A4+sigma_B4))*exp(-(miu_A4-miu_B4)^2/2.0/(sigma_A4+sigma_B4))*exp((2*lmada_1*(threshold-Xk))/sigma_B_1+((2*sigma_B_1*Theta_1*(threshold-Xk)^2)+2*(threshold-Xk)^2*Theta_1^2*TT2)/(sigma_B_1^2*(TT2*Theta_1+sigma_B_1)));
                    if F3==0
                        F=(F1*F2)*dt;
                    else  
                        F=(F1*F2-F3*exp(F5+F6+F7))*dt;
                    end
                    pdf_wiener11(j,Lk)=F;                
                end

                if pdf_wiener11(j,Lk)<=0
                    1;
                end
                
                if F==-inf
                    1;
                end
                
                if isnan(F)
                    1;
                end
                
               end
               j=j+1;
        end
       pd=makedist('normal','mu',parameter2(5,1),'sigma',parameter2(5,2));
       trn = truncate(pd,Tk*dt,300);
       tau1=Tk*dt:dt:300;
       pdf_wiener(i,:)=trapz(tau1,pdf_wiener11.*pdf(trn,tau1)',1);            
    end
    
    Ture_Lk(i)=sum(pdf_wiener(i,:).*(1:1:370));
    i=i+1;
end
%% bearing1-1
% pdf_wiener_r1_2=pdf_wiener;
% save pdf_wiener_r1_2.mat  pdf_wiener_r1_2

%% bearing1-2
pdf_wiener_r2_2=pdf_wiener;
save pdf_wiener_r2_2.mat  pdf_wiener_r2_2

%% bearing1-3
% pdf_wiener_r3_2=pdf_wiener;
% save pdf_wiener_r3_2.mat  pdf_wiener_r3_2

%% bearing2-2
% pdf_wiener_r4_2=pdf_wiener;
% save pdf_wiener_r4_2.mat  pdf_wiener_r4_2