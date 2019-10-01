load('260stopped.mat');

 for j=7666590000:16666500:10e9  
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

wholeTime2 = toc;

filename = 'Q1Frequency260660.mat';
save(filename);