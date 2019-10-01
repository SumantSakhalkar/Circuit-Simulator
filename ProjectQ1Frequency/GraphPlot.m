load('Q1Frequencyfor110.mat');

%x=loadsig('celldatanew.ac0');

% f=evalsig(x,'HERTZ');
% v9=evalsig(x,'v_9');
% 
% v9mag=20*log10((abs(v9)));
% 
% v9phase=(180*angle(v9))/pi;
% 
% v6=evalsig(x,'v_6');
% 
% v6mag=20*log10((abs(v6)));
% 
% v6phase=(180*angle(v6))/pi;
% 
% v16=evalsig(x,'v_16');
% 
% v16mag=20*log10((abs(v16)));
% 
% v16phase=(180*angle(v16))/pi;

for  width=100000:16666500:10e9
magnitude9(round(width/16666500)+1) = 20*log10((abs(X{round(width/16666500)+1}(9)))); 

phase9(round(width/16666500)+1) =  (180*angle(X{round(width/16666500)+1}(9)))/pi;  
end

for  width=100000:16666500:10e9
magnitude6(round(width/16666500)+1) = 20*log10((abs(X{round(width/16666500)+1}(6)))); 

phase6(round(width/16666500)+1) =  (180*angle(X{round(width/16666500)+1}(6)))/pi;  
end

for  width=100000:16666500:10e9
magnitude16(round(width/16666500)+1) = 20*log10((abs(X{round(width/16666500)+1}(16)))); 

phase16(round(width/16666500)+1) =  (180*angle(X{round(width/16666500)+1}(16)))/pi;  
end

fscale = 100000:16666500:10e9;  % to match matrix dimensions with wath is to be shown in x axis

figure
subplot(2,1,1)       % add first plot in 2 x 1 grid
% semilogx ( fscale, magnitude )
plot(fscale, magnitude9 )
xlabel('Freq (Hertz)');
ylabel('Magnitude (dB)');
title('Magnitude plot at O/P1')

subplot(2,1,2)       % add second plot in 2 x 1 grid
% semilogx ( fscale, phase )
plot(fscale, phase9 )
xlabel('Freq (Hertz)');
ylabel('Phase (degrees)');
title('Phase plot at O/P1')

figure
subplot(2,1,1)       % add first plot in 2 x 1 grid
% semilogx ( fscale, magnitude )
semilogx(fscale, magnitude6 )
xlabel('Freq (Hertz)');
ylabel('Magnitude (dB)');
title('Magnitude plot at O/P2')

subplot(2,1,2)       % add second plot in 2 x 1 grid
% semilogx ( fscale, phase )
semilogx(fscale, phase6 )
xlabel('Freq (Hertz)');
ylabel('Phase (degrees)');
title('Phase plot  at O/P2')


figure
subplot(2,1,1)       % add first plot in 2 x 1 grid
% semilogx ( fscale, magnitude )
semilogx(fscale, magnitude16 )
xlabel('Freq (Hertz)');
ylabel('Magnitude (db)');
title('Magnitude plot at O/P3')

subplot(2,1,2)       % add second plot in 2 x 1 grid
% semilogx ( fscale, phase )
semilogx(fscale, phase16 )
xlabel('Freq (Hertz)');
ylabel('Phase (degrees)');
title('Phase plot at O/P3')

% subplot(2,2,1)       % add first plot in 2 x 1 grid
% % semilogx ( fscale, magnitude )
% plot( f,v5,fscale, magnitude5 )
% xlabel('frequency in Hz');
% ylabel('magnitude in db');
% title('Magnitude plot')
% 
% subplot(2,2,2)       % add second plot in 2 x 1 grid
% % semilogx ( fscale, phase )
% plot( fscale, phase5 )
% xlabel('frequency in Hz');
% ylabel('phase in degrees');
% title('Phase plot')

% subplot(4,1,3)       % add first plot in 2 x 1 grid
% plot ( fscale, magnitude )
% axis([0 10 -10 80])
% xlabel('frequency in Hz');
% ylabel('magnitude in db');
% title('Magnitude plot(0 to 10Hz)')
% 
% subplot(4,1,4)       % add second plot in 2 x 1 grid
% plot ( fscale, phase )
% axis([0 10 -50 150])
% xlabel('frequency in Hz');
% ylabel('phase in degrees');
% title('Phase plot(0 to 10Hz)')
