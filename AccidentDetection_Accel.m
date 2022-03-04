clc;
clear;

addpath('function');
addpath('data');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Set parameters                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filter window size
n=3;
% gravitational acceleration
g=9.8;
% threshold
th=6.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Acceleration data include 'accel_x, accel_y,%
% accel_z' on x, y and z axis                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read the data file
f=tsvread('XXX.tsv');

% calibration data
t0=f(:,2);
t1=t0-t0(1);
t2=datetime(t1./1000,'ConvertFrom','posixtime','Format','mm:ss.SSS');
t=seconds(timeofday(t2));
accel_x=f(:,3)./g;
accel_y=f(:,4)./g;
accel_z=f(:,5)./g;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Preprocess acceleration data         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% signal filter for x, y, z axis (median filter)
ax=medfilt1(accel_x,n);
ay=medfilt1(accel_y,n);
az=medfilt1(accel_z,n);

% output raw signal
figure;
subplot(2,1,1);
plot(t,accel_x,'r');
hold on
plot(t,accel_y,'g');
hold on
plot(t,accel_z,'b');
title('Raw data');
xlabel('Time(s)');
ylabel('Acceleration(g)');
legend('Axis X','Axis Y','Axis Z');

% output filtered signal
subplot(2,1,2);
plot(t,ax,'r');
hold on
plot(t,ay,'g');
hold on
plot(t,az,'b');
title('Filtered data');
xlabel('Time(s)');
ylabel('Acceleration(g)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Extract signal features           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SVM - signal vector magnitude
svm=sqrt(ax.^2+ay.^2+az.^2);

% output filtered signal
figure;
plot(t,svm);
title('Accel Signal');
xlabel('Time(s)');
ylabel('Acceleration(g)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Accident detection              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% anomaly detection
tag=find(svm>=th);

% output anomaly targets
figure;
subplot(2,1,1);
plot(t,svm);
hold on
plot(t(tag),svm(tag),'r+');
title('Anomaly detection');
xlabel('Time(s)');
ylabel('Acceleration(g)');
legend('Acceleration signal','Anomaly target');

% accident detection
for i=1:length(tag)
    data{i}=svm(tag(i)-3:tag(i));
    med(i,:)=mean(data{1,i});
    %stand(i,:)=std(data{1,i});
end

for j=1:length(med)
    if med(j)<6
        tag(j)=0;
    end   
end

tag(tag==0)=[];

% output accident targets
subplot(2,1,2);
plot(t,svm);
hold on
plot(t(tag),svm(tag),'ro');
title('Accident detection');
xlabel('Time(s)');
ylabel('Acceleration(g)');
legend('Acceleration signal','Accident target');



