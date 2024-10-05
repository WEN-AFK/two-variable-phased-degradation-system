clc;
clear;
load('changepoint.mat')
load('Bearing_feature.mat')
load('bear_in.mat')
X0=2;
dt=1;
lmada_1=1;
lmada_2=2.00;


for j=1:5
pp=find(bear_in2(j,:)>0);
N=pp(end);
bear_incresing2=bear_in2(j,1:N-10);
for k=1:100  
    
m=size(((changepoint(j))+1:N-10)-(changepoint(j)),2);
lmada_1=sum(bear_incresing2(1:changepoint(j)).*dt)/(changepoint(j)*dt^2);
lmada_2=sum(bear_incresing2(changepoint(j)+1:end).*dt)/sum(m*dt^2);
sigma_B_1=sum((bear_incresing2(1:changepoint(j))-lmada_1*dt).^2)/(changepoint(j)*dt);
sigma_B_2=sum((bear_incresing2(changepoint(j)+1:end)-lmada_2*dt).^2)/sum(m*dt);
k=k+1;

end
parameter12(j,1)=lmada_1;
parameter12(j,2)=sqrt(sigma_B_1);
parameter12(j,3)=lmada_2;
parameter12(j,4)=sqrt(sigma_B_2);
end

parameter2(1,1)=sum(parameter12(:,1)/5);
parameter2(2,1)=sum(parameter12(:,2)/5);
parameter2(3,1)=sum(parameter12(:,3)/5);
parameter2(4,1)=sum(parameter12(:,4)/5);


lam_1 = mle(parameter12(:,1),'distribution','Normal');
lam_2 = mle(parameter12(:,3),'distribution','Normal');

tau_dis = mle(changepoint(1:5),'distribution','Normal');

parameter2(1,2)=lam_1(2);
parameter2(3,2)=lam_2(2);
parameter2=[parameter2;tau_dis];

save parameter2.mat parameter2 parameter12