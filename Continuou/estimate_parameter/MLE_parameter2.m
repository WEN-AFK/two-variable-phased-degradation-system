clc;
clear;
load('changepoint.mat')
load('X2.mat')
X0=2;
T=100;
dt=0.1;
N=T/dt;
lmada_1=0.01;
lmada_2=0.25;

for j=1:100
for k=1:100
    
m=size((10*(changepoint(j))+1:N)-10*(changepoint(j)),2);

lmada_1=sum(X_incresing2(j,1:10*changepoint(j)-1).*dt)/((10*changepoint(j)-1)*dt^2);
lmada_2=sum(X_incresing2(j,10*changepoint(j)+1:end).*dt)/sum(m*dt^2);
sigma_B_1=sum((X_incresing2(j,1:10*changepoint(j)-1)-lmada_1*dt).^2)/((10*changepoint(j)-1)*dt);
sigma_B_2=sum((X_incresing2(j,10*changepoint(j)+1:end)-lmada_2*dt).^2)/sum(m*dt);

k=k+1;

end
parameter12(j,1)=lmada_1;
parameter12(j,2)=sqrt(sigma_B_1);
parameter12(j,3)=lmada_2;
parameter12(j,4)=sqrt(sigma_B_2);
end

parameter2(1,1)=sum(parameter12(:,1)/100);
parameter2(2,1)=sum(parameter12(:,2)/100);
parameter2(3,1)=sum(parameter12(:,3)/100);
parameter2(4,1)=sum(parameter12(:,4)/100);

lam_1 = mle(parameter12(:,1),'distribution','Normal');
lam_2 = mle(parameter12(:,3),'distribution','Normal');
tau_dis = mle(changepoint,'distribution','Normal');

parameter2(1,2)=lam_1(2);
parameter2(3,2)=lam_2(2);
parameter2=[parameter2;tau_dis];

save parameter2.mat parameter2 parameter12