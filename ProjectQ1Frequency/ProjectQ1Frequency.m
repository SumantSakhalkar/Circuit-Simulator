tic
clear;
load('test.mat');

opnode1=9;
opnode2=0;
ipnode2=1;
ipnode1=0;

j=1;

for f=100000:16666500:10e9  
    GSC_Matrix=G_Matrix+1i*2*pi*f*C_Matrix;
  %  GSC_MatrixReplaced=GSC_Matrix;
   % GSC_MatrixReplaced(:,opnode1)=B_Matrix;
   % a=det(GSC_MatrixReplaced);
   % b=det(GSC_Matrix);
    [L,U] = lu(GSC_Matrix);
    X{round((f-100000)/16666500)+1}= U\(L\B_Matrix);
    %X{round((f-100000)/16666500)+1}= a/b;
    j=j+1;
end

toc
%    [L,U] = lu(GSC_Matrix{1});
%     X{1} = U\(L\B_Matrix);
% 
% 
% for j=2:length(GSC_Matrix)
%    [L,U] = lu(GSC_Matrix{j});
%     X{j} = U\(L\B_Matrix);
% end
% 

% 
% for  width=0:10:10000000
% magnitude(round(width/10)+1) = 20*log10((abs(X{round(width/10)+1}(opnode1Modified)))); 
% 
% phase(round(width/10)+1) =  (180*angle(X{round(width/10)+1}(opnode1Modified)))/pi;  
% end
% 
% fscale = 0:10:10000000;  % to match matrix dimensions with wath is to be shown in x axis
% 
% figure
% subplot(4,1,1)       % add first plot in 2 x 1 grid
% semilogx ( fscale, magnitude )
% xlabel('frequency in Hz');
% ylabel('magnitude in db');
% title('Magnitude plot')
% 
% subplot(4,1,2)       % add second plot in 2 x 1 grid
% semilogx ( fscale, phase )
% xlabel('frequency in Hz');
% ylabel('phase in degrees');
% title('Phase plot')
% 
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
% %  [L,U] = lu(G_Matrix);
% %     X = U\(L\B_Matrix);
