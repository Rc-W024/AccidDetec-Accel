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
% train cells
T=350;
% guard cells
G=85;
% offset
offset=15;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Acceleration data include 'accel_x, accel_y,%
% accel_z' on x, y and z axis                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read the data file
f=tsvread('9febcrash.tsv');

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

% output power of accel signal
pow=abs(svm).^2;

figure;
plot(t,pow);
title('Power of Accel Signal');
xlabel('Time');
ylabel('Power');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Anomaly CFAR detection            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
threshold_cfar=zeros(length(pow)-(G+T+1),1);

% slide window across the signal length
for i=1:(length(pow)-(G+T+1))     
    % determine the noise threshold by measuring it within the training cells
    noise_level=sum(pow(i:i+T-1));
    % scale the noise_level by appropriate offset value and take average over T training cells
    threshold=(noise_level/T)*offset;
    % add threshold value
    threshold_cfar(i)=threshold;
end

th=circshift(threshold_cfar,G);
detected=[];

% find points that exceed the threshold
for i=1:length(th)
    if pow(i)>th(i)
        detected(i,1)=t(i);
        detected(i,2)=pow(i);
    end
end

detected(any(detected,2)==0,:)=[];

% output peaks detection result
figure;
subplot(2,1,1);
plot(t,pow);
hold on
plot(t(1:length(th),1),th,'r');
hold on
plot(detected(:,1),detected(:,2),'b+');
title('CFAR anomaly detection');
xlabel('Time');
ylabel('Power');
legend('Signal','CFAR Threshold','Anomalies detected')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Accident detection              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
accel=[t svm];

% eliminate false alarm targets
for i=1:length(detected)
    num=find(accel>detected(i) & accel<detected(i)+3);
    Data{i}=accel(num(1:length(num)),2);
    %med(i,:)=mean(Data{1,i});
    stand(i,:)=std(Data{1,i});
end

for j=1:length(stand)
    if stand(j)<0.7
        detected(j,:)=0;
    end   
end

detected(any(detected,2)==0,:)=[];

%output accident detection result
subplot(2,1,2);
plot(t,pow);
hold on
plot(detected(:,1),detected(:,2),'r+');
title('Accident detection');
xlabel('Time');
ylabel('Power');
legend('Signal','Accident detected')

% Mapping detected targets onto the acceleration signal
res=[];

for i=1:length(detected)
    for j=1:length(accel)
        if detected(i)==accel(j,1)
            res(i)=accel(j,2);
        end
    end
end

% print detection result
accid=reshape([detected(:,1) res']',1,length(detected)+length(res));
format='WARNING: Accident detected at %6.3f s, the strength of resultant acceleration signal is %6.4f g.\n';
fprintf(format,accid);

figure;
plot(t,svm);
hold on
plot(detected(:,1),res,'ro');
title('Accident detection (Accel)');
xlabel('Time');
ylabel('Power');
legend('Signal','Accident detected')

