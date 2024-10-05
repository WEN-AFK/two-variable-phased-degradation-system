%% simulation data PDF
load('parameter2.mat');
threshold=21.55; 
long=size(X2,2);
close all
% syms x1_tau
i=1;

for Tk=200:4:long
    Xk=(X2(dataset,Tk));
    if Xk>=threshold
        break;
    end  
    if Tk>changep_online 
        Theta1=sqrt(PKK1(1,Tk));
        lmada=ZKK1(1,Tk);
        sigma_B2=RR1(1,Tk);
%         Theta1=parameter2(3,2);
%         lmada=parameter2(3,1);
%         sigma_B2=parameter2(4,1)^2;
        for Lk=1:3000-Tk
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
        
    elseif Tk<=changep_online
        j=1;
        clear pdf_wiener11;
        pdf_wiener11=zeros(1,2800);
        for tau=Tk:1:1200
          for Lk=1:3000-Tk
            if Tk+Lk<tau 
                Theta1=sqrt(PKK1(1,Tk));
                lmada=ZKK1(1,Tk);
                sigma_B2=RR1(1,Tk);
                w1=(threshold-Xk);
                F1=w1;        
                F2=sqrt(2*pi*(Lk*dt)^3*(Lk*dt*Theta1^2+sigma_B2));   
                F3=exp(-(threshold-Xk-Lk*dt*lmada).^2./(2*Lk*dt*(Lk*dt*Theta1^2+sigma_B2)));
                F=F1./F2.*F3*dt;
                pdf_wiener11(j,Lk)=F;
            elseif Tk+Lk==tau
                x1_tau=threshold:0.001:3*threshold;
                Theta_1=PKK1(1,Tk);
                lmada_1=ZKK1(1,Tk);
                sigma_B_1=RR1(1,Tk);
                miu_gamma=parameter2(6,1);
                sigma_gamma=parameter2(6,2);
                TT2=(tau-Tk)*dt;
                
                miu_A1=x1_tau-miu_gamma;
                sigma_A1=sigma_gamma^2; 
                miu_B1=Xk+lmada_1*TT2;
                sigma_B1=Theta_1*TT2^2+sigma_B_1*TT2;                
                miu_A2=x1_tau-miu_gamma;
                sigma_A2=sigma_gamma^2;
                miu_B2=-Xk+2*threshold+lmada_1*TT2+(2*(threshold-Xk)*Theta_1*TT2)/sigma_B_1;
                sigma_B2=Theta_1*TT2^2+sigma_B_1*TT2; 
                
                K1=1-normcdf((-threshold*(sigma_A1+sigma_B1)+miu_B1*sigma_A1+miu_A1*sigma_B1)/sqrt(sigma_A1*sigma_B1*(sigma_A1+sigma_B1)));
                K2=1-normcdf((-threshold*(sigma_A2+sigma_B2)+miu_B2*sigma_A2+miu_A2*sigma_B2)/sqrt(sigma_A2*sigma_B2*(sigma_A2+sigma_B2)));
                
                F1=1/sqrt(2*pi*(sigma_A1+sigma_B1))*exp(-(miu_A1-miu_B1).^2/2.0/(sigma_A1+sigma_B1)).*K1;
                F2=1/sqrt(2*pi*(sigma_A2+sigma_B2))*exp(-(miu_A2-miu_B2).^2/2.0/(sigma_A2+sigma_B2))*exp((2*lmada_1*(threshold-Xk))/sigma_B_1+((2*sigma_B_1*Theta_1*(threshold-Xk)^2)+2*(threshold-Xk)^2*Theta_1^2*TT2)/(sigma_B_1^2*(TT2*Theta_1+sigma_B_1)));
                F5=log(1/sqrt(2*pi*(sigma_A2+sigma_B2)));
                F6=-(miu_A2-miu_B2).^2/2.0/(sigma_A2+sigma_B2);
                F7=(2*lmada_1*(threshold-Xk))/sigma_B_1+((2*sigma_B_1*Theta_1*(threshold-Xk)^2)+2*(threshold-Xk)^2*Theta_1^2*TT2)/(sigma_B_1^2*(TT2*Theta_1+sigma_B_1));
                
                K2_NZ=find(K2~=0);
                K2_Z=find(K2==0);
                F8=exp(F5+F6+F7);
                
                
                if all(K2==0)
                    F=F1;
                else
                    F=F1-[F8(K2_NZ),K2(K2_Z)].*K2;
                end
                pdf_wiener11(j,Lk)=trapz(x1_tau,F);   
                1;
            elseif Tk+Lk>tau 
                
                x1_tau=-100:0.01:17;
                Theta_1=PKK1(1,Tk);
                lmada_1=ZKK1(1,Tk);
                sigma_B_1=RR1(1,Tk);
                Theta_2=parameter2(3,2);
                lmada_2=parameter2(3,1);
                sigma_B_2=parameter2(4,1)^2;
                miu_gamma=parameter2(6,1);
                sigma_gamma=parameter2(6,2);
                
                TT1=(Tk+Lk-tau)*dt;
                TT2=(tau-Tk)*dt;
                
                miu_A1=x1_tau-miu_gamma;
                sigma_A1=sigma_gamma^2; 
                miu_B1=Xk+lmada_1*TT2;
                sigma_B1=Theta_1*TT2^2+sigma_B_1*TT2;                
                miu_A2=x1_tau-miu_gamma;
                sigma_A2=sigma_gamma^2;
                miu_B2=-Xk+2*threshold+lmada_1*TT2+(2*(threshold-Xk)*Theta_1*TT2)/sigma_B_1;
                sigma_B2=Theta_1*TT2^2+sigma_B_1*TT2; 
                
                K1=1-normcdf((-threshold*(sigma_A1+sigma_B1)+miu_B1*sigma_A1+miu_A1*sigma_B1)/sqrt(sigma_A1*sigma_B1*(sigma_A1+sigma_B1)));
                K2=1-normcdf((-threshold*(sigma_A2+sigma_B2)+miu_B2*sigma_A2+miu_A2*sigma_B2)/sqrt(sigma_A2*sigma_B2*(sigma_A2+sigma_B2)));
                                              
                F1=1/sqrt(2*pi*(sigma_A1+sigma_B1))*exp(-(miu_A1-miu_B1).^2/2.0/(sigma_A1+sigma_B1)).*K1;
                F2=1/sqrt(2*pi*(sigma_A2+sigma_B2))*exp(-(miu_A2-miu_B2).^2/2.0/(sigma_A2+sigma_B2))*exp((2*lmada_1*(threshold-Xk))/sigma_B_1+((2*sigma_B_1*Theta_1*(threshold-Xk)^2)+2*(threshold-Xk)^2*Theta_1^2*TT2)/(sigma_B_1^2*(TT2*Theta_1+sigma_B_1)));
                F3=(threshold-x1_tau)./sqrt(2*pi*TT1^3*(Theta_2^2*TT1+sigma_B_2)).*exp(-(threshold-x1_tau-lmada_2*TT1).^2/(2*TT1*(Theta_2^2*TT1+sigma_B_2)));
                                
                F5=log(1/sqrt(2*pi*(sigma_A2+sigma_B2)));
                F6=-(miu_A2-miu_B2).^2/2.0/(sigma_A2+sigma_B2);
                F7=(2*lmada_1*(threshold-Xk))/sigma_B_1+((2*sigma_B_1*Theta_1*(threshold-Xk)^2)+2*(threshold-Xk)^2*Theta_1^2*TT2)/(sigma_B_1^2*(TT2*Theta_1+sigma_B_1));
                
                K2_NZ=find(K2~=0);
                K2_Z=find(K2==0);
                F8=exp(F5+F6+F7); 

                if all(K2==0)
                    F=F1.*F3*dt;
                else
                    F=(F1-[F8(K2_NZ),K2(K2_Z)].*K2).*F3*dt;
                end
                 pdf_wiener11(j,Lk)=trapz(x1_tau,F); 
                
            end
            
                if pdf_wiener11(j,Lk)<=0
                    1;
                end
                if abs(pdf_wiener11(j,Lk))==inf
                    1;
                end
                if isnan(pdf_wiener11(j,Lk))
                    1; 
                end
          end
         j=j+1;
        end
       pd=makedist('normal','mu',parameter2(5,1),'sigma',parameter2(5,2));
       trn = truncate(pd,Tk*dt,120);
       tau1=Tk*dt:dt:120;
       pdf_wiener(i,:)=trapz(tau1,pdf_wiener11.*pdf(trn,tau1)',1);           
    end
     
    Ture_Lk(i)=sum(pdf_wiener(i,:).*(0.1:0.1:280));
    i=i+1;
end

pdf_wiener_r2=pdf_wiener;
save pdf_wiener_r2.mat pdf_wiener_r2