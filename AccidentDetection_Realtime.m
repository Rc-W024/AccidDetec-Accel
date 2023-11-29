clc;
clear;

% addpath(genpath('X:\XX\XX'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Set parameters                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filter window size
n=3;
% gravitational acceleration
g=9.8;
% detector length (~3s)
D=800;
% detector tail length (fall detection)
T=80;
% detection threshold
th=120;

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
%     Extract the features of the signal      %
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Accident detection              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y=[t accel_y];
detected=[];

% slide window across the signal
v=length(y)-D;
k=1;
while v~=0
    v=v-1;
    % find the anomalous targets (Fall detection)
    if y(D,2)>-0.1 & y(D,2)<0.5
        % calculate the signal power
        for i=1:length(pow)
            if pow(i,1)==y(D,1)
                % save the maximum power value in the set of samples (T)
                pmax=max(pow(i-T:i,2));
            end
        end
        % accident detection
        if pmax>th
            detected(k,:)=y(D,:);
            power_value(k,:)=pmax;
            k=k+1;
            % anomaly detector (Window)
            y=circshift(y,-(1:length(y)-D));
        else
            y=circshift(y,-(1:length(y)-D));
        end
    else
        y=circshift(y,-(1:length(y)-D));
    end
end

% output detection result
if isempty(detected)==0   
    for i=1:length(pow)
        for j=1:length(power_value)
            if pow(i,2)==power_value(j,1)
                % save the time series of the accident
                at(j,1)=pow(i,1);   
            end
        end
    end
    
    % find duplicate values
    accid_t=unique(at);
    
    % print the warning text
    format='WARNING: Accident detected at around %6.3f s.\n';
    fprintf(format,accid_t);
    
    % output result graph
    figure;
    subplot(2,1,1)
    plot(t,accel_y);
    hold on
    plot(detected(:,1),detected(:,2),'r+');
    title('Accident detection on Y-axis');
    xlabel('Time(s)');
    ylabel('Acceleration(g)');
    legend('Y-axis acceleration signal','Accident target');

    subplot(2,1,2)
    plot(t,pow0);
    hold on
    plot(at,power_value,'ro');
    title('Power of Accident detected');
    xlabel('Time(s)');
    ylabel('Power');
    legend('Acceleration pow','Accident target');    
else
    % output power graph
    figure;
    plot(t,pow0);
    title('Aceleration Power');
    xlabel('Time(s)');
    ylabel('Power');

    fprintf('NO accident detected.\n');
end


