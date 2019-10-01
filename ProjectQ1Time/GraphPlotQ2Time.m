load('Q1Time250.mat');


% x=loadsig('Q2TimeHSPICE.tr0');
% t=evalsig(x,'TIME');
% v3=evalsig(x,'v_3');
% 
% 
% 
% v5=evalsig(x,'v_5');
% 
% 
% v8=evalsig(x,'v_8');



 
for  k=1:1:length(X_MatrixCell)
magnitudeIP(k) = B_MatrixTimeCell{k}(z);
magnitudeOP9(k) = X_MatrixCell{k}(9); 
magnitudeOP6(k) = X_MatrixCell{k}(6); 
magnitudeOP16(k) = X_MatrixCell{k}(16); 
end
% 
% 



time = 0:h:TotalTime;

figure
subplot(4,1,1)       % add second plot in 2 x 1 grid
plot ( time, magnitudeIP )
xlabel('Time (sec)');
ylabel('Vin (Volts)');
title('Time Response at Input')
% 
% 
subplot(4,1,2)       % add second plot in 2 x 1 grid
plot ( time, magnitudeOP9 )
xlabel('Time (sec)');
ylabel('Vout (Volts)');
title('Time Response of O/P 1 ')

subplot(4,1,3)       % add second plot in 2 x 1 grid
plot ( time, magnitudeOP6 )
xlabel('Time (sec)');
ylabel('Vout (Volts)');
title('Time Response of O/P 2 ')
% 
% 
subplot(4,1,4)       % add second plot in 2 x 1 grid
plot ( time, magnitudeOP16 )
xlabel('Time (sec)');
ylabel('Vout (Volts)');
title('Time Response of O/P 3')

% figure
% subplot(2,1,1)       % add second plot in 2 x 1 grid
% plot ( time, magnitudeIP )
% xlabel('Time in Seconds');
% ylabel('Vin at input');
% title('Time Response of Input')
% % 
% % 
% subplot(2,1,2)       % add second plot in 2 x 1 grid
% plot ( time, magnitudeOP8 )
% xlabel('Time in MilliSeconds');
% ylabel('Vout across resistance');
% title('Time Response of Output')