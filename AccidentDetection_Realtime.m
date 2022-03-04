clc;
clear;

addpath('functions');
addpath('data');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Set parameters                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filter window size
n=3;
% gravitational acceleration
g=9.8;
% threshold 20
th=15;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Acceleration data include 'accel_x, accel_y,%
% accel_z' on x, y and z axis                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read the data file
f=tsvread('23febStep&crash.tsv'); %9febcrash

% calibration data
t0=f(:,2);
t1=t0-t0(1);
t2=datetime(t1./1000,'ConvertFrom','posixtime','Format','mm:ss.SSS');
t=seconds(timeofday(t2));
accel_x=f(:,3)./g;
accel_y=f(:,4)./g;
accel_z=f(:,5)./g;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Fall detection - Y-axis            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y=[t accel_y];

% extract anomaly targets (fall data)
for i=1:length(y)
    if y(i,2)<-0.1 || y(i,2)>0.1
        y(i,:)=0;
    end
end

y(all(y==0,2),:)=[];

% output anomaly result
figure;
plot(t,accel_y);
hold on
plot(y(:,1),y(:,2),'r+');
title('Anomaly detection on Y-axis');
xlabel('Time(s)');
ylabel('Acceleration(g)');
legend('Y-axis acceleration signal','Anomaly target');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Accident detection              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% signal filter
ax=medfilt1(accel_x,n);
ay=medfilt1(accel_y,n);
az=medfilt1(accel_z,n);

% SVM - signal vector magnitude
svm=sqrt(ax.^2+ay.^2+az.^2);
% Power
pow0=abs(svm).^2;
pow=[t pow0];

% output acceleration power
figure;
plot(t,pow0);
title('Power');
xlabel('Time(s)');
ylabel('Power');

% calculate mean of each data group
for i=1:length(y)
    for j=1:length(pow)
        if y(i,1)==pow(j,1)
            anomal{i}=pow(j-50:j,2);
            med(i,:)=mean(anomal{1,i});
        end
    end
end

% eliminate false alarm targets
for i=1:length(med)
    if med(i)<th
        y(i,:)=0;
    end   
end

y(all(y==0,2),:)=[];

% print detection result
detected_t=y(:,1);
format='WARNING: Accident detected at around %6.3f s.\n';
fprintf(format,detected_t);

% output result
figure;
plot(t,accel_y);
hold on
plot(y(:,1),y(:,2),'r+');
title('Accident detection on Y-axis');
xlabel('Time(s)');
ylabel('Acceleration(g)');
legend('Y-axis acceleration signal','Accident target');

% abnormal data: line 12259-12260


