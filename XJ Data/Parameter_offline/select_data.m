clc
clear
load('XJ_Bearing_increasing.mat');
load('XJ_Bearing_feature.mat');
pisition=[1 2 3 7 10];
for i=1:size(pisition,2)
    bear_in1(i,:)=bearing_incresing_1(pisition(i),:);
    bear_in2(i,:)=bearing_incresing_2(pisition(i),:);
end


figure(1)
subplot(2,3,1)
n=size(Bearing1_1_feature.Max,1);
plot(Bearing1_1_feature.Energies_of_sixteen_bands.E5(:,15))
Bearing1_feature(1,1:n)=Bearing1_1_feature.Energies_of_sixteen_bands.E5(:,15)';
hold on
plot(Bearing1_1_feature.Energies_of_sixteen_bands.E6(:,15))
Bearing2_feature(1,1:n)=Bearing1_1_feature.Energies_of_sixteen_bands.E6(:,15)';
hold on

subplot(2,3,2)
n=size(Bearing1_2_feature.Max,1);
plot(Bearing1_2_feature.Energies_of_sixteen_bands.E5(:,15))
Bearing1_feature(2,1:n)=Bearing1_2_feature.Energies_of_sixteen_bands.E5(:,15)';
hold on
plot(Bearing1_2_feature.Energies_of_sixteen_bands.E6(:,15))
Bearing2_feature(2,1:n)=Bearing1_2_feature.Energies_of_sixteen_bands.E6(:,15)';
hold on

subplot(2,3,3)
n=size(Bearing1_3_feature.Max,1);
plot(Bearing1_3_feature.Energies_of_sixteen_bands.E5(:,15))
Bearing1_feature(3,1:n)=Bearing1_3_feature.Energies_of_sixteen_bands.E5(:,15);
hold on 
plot(Bearing1_3_feature.Energies_of_sixteen_bands.E6(:,15))
Bearing2_feature(3,1:n)=Bearing1_3_feature.Energies_of_sixteen_bands.E6(:,15);
hold on 

subplot(2,3,4)
n=size(Bearing2_2_feature.Max,1);
plot(Bearing2_2_feature.Energies_of_sixteen_bands.E5(:,15))
Bearing1_feature(4,1:n)=Bearing2_2_feature.Energies_of_sixteen_bands.E5(:,15);
hold on 
plot(Bearing2_2_feature.Energies_of_sixteen_bands.E6(:,15))
Bearing2_feature(4,1:n)=Bearing2_2_feature.Energies_of_sixteen_bands.E6(:,15);
hold on 

subplot(2,3,5)
n=size(Bearing2_5_feature.Max,1);
plot(Bearing2_5_feature.Energies_of_sixteen_bands.E5(:,15))
Bearing1_feature(5,1:n)=Bearing2_5_feature.Energies_of_sixteen_bands.E5(:,15);
hold on
plot(Bearing2_5_feature.Energies_of_sixteen_bands.E6(:,15))
Bearing2_feature(5,1:n)=Bearing2_5_feature.Energies_of_sixteen_bands.E6(:,15);
hold on
save bear_in.mat  bear_in1  bear_in2

save Bearing_feature.mat  Bearing1_feature  Bearing2_feature