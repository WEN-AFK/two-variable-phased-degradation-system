for j=1:100    
    miu_tau=60;
    sigma_trau=10;
    tau(j)=normrnd(miu_tau,sigma_trau,1);
end
save tau.mat tau