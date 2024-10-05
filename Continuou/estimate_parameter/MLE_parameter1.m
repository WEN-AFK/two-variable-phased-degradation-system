clc;
clear;
load('changepoint.mat')
load('X1.mat')
X0=2;
T=100;
dt=0.1;
N=T/dt;
lmada_1=0.01;
lmada_2=2.00;


for j=1:100

for k=1:100
    
m=size((10*(changepoint(j))+1:N)-10*(changepoint(j)),2);

lmada_1=sum(X_incresing1(j,1:10*changepoint(j)).*dt)/(10*changepoint(j)*dt^2);
lmada_2=sum(X_incresing1(j,10*changepoint(j)+1:end).*dt)/sum(m*dt^2);
sigma_B_1=sum((X_incresing1(j,1:10*changepoint(j))-lmada_1*dt).^2)/(10*changepoint(j)*dt);
sigma_B_2=sum((X_incresing1(j,10*changepoint(j)+1:end)-lmada_2*dt).^2)/sum(m*dt);

k=k+1;

end
parameter11(j,1)=lmada_1;
parameter11(j,2)=sqrt(sigma_B_1);
parameter11(j,3)=lmada_2;
parameter11(j,4)=sqrt(sigma_B_2);


end

parameter1(1,1)=sum(parameter11(:,1)/100);
parameter1(2,1)=sum(parameter11(:,2)/100);
parameter1(3,1)=sum(parameter11(:,3)/100);
parameter1(4,1)=sum(parameter11(:,4)/100);



lam_1 = mle(parameter11(:,1),'distribution','Normal');
lam_2 = mle(parameter11(:,3),'distribution','Normal');

tau_dis = mle(changepoint(1:100),'distribution','Normal');

parameter1(1,2)=lam_1(2);
parameter1(3,2)=lam_2(2);
parameter1=[parameter1;tau_dis];

save parameter1.mat parameter1 parameter11

