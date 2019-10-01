tic;
clear all;
clc;
%Below two are the nodes across which output voltage is measured
opnode1=2;
opnode2=0;
ipnode2=1;
ipnode1=0;

NLMatrix = NetListMatrix('NetListProjectQ1.txt');

NLMatrixCopy=NLMatrix;

MaxFrquency = 10e9;

%[NLMatrix] = InterconnectAnalyser(NLMatrix,MaxFrquency);


 a=max([NLMatrix{:,2}]);
 b=max([NLMatrix{:,3}]);
 %Below is number of Max nodes in the circuit
 maxPassiveNodeOriginal=max(a,b);
 
 maxPassiveNode = maxPassiveNodeOriginal;

        
 InterconnectIndex = strmatch('TL', char(NLMatrix(:,1)));


for i=1:length(InterconnectIndex)
    
    
    NumberofSegments(i)     = 20 * NLMatrix{InterconnectIndex(i),8} * MaxFrquency* sqrt(NLMatrix{InterconnectIndex(i),5} * NLMatrix{InterconnectIndex(i),7}) ;
    
     z=round(NumberofSegments(i));
    
    
%    z=50*(ceil(round(NumberofSegments(i))/50.))+70;
    
    DelX= NLMatrix{InterconnectIndex(i),8}/z;
    
    for j=1:z 
    LengthofNL=length(NLMatrix(:,2));
        if j==1


    
    %Capacitor generation%
    NLMatrix{LengthofNL+1,1} = strcat('C',NLMatrix{InterconnectIndex(i),1},num2str(j));
    NLMatrix{LengthofNL+1,2} = NLMatrix{InterconnectIndex(i),2};
    NLMatrix{LengthofNL+1,3} = 0;
    NLMatrix{LengthofNL+1,4} = NLMatrix{InterconnectIndex(i),7}*DelX;
    
    %Conductance generation
    
    NLMatrix{LengthofNL+2,1} = strcat('RG',NLMatrix{InterconnectIndex(i),1},num2str(j));
    NLMatrix{LengthofNL+2,2} = NLMatrix{InterconnectIndex(i),2};
    NLMatrix{LengthofNL+2,3} = 0;
    NLMatrix{LengthofNL+2,4} = 1/(NLMatrix{InterconnectIndex(i),6}*DelX);
    
    %Resistor generation%
    maxPassiveNode = maxPassiveNode+1;
    NLMatrix{LengthofNL+3,1} = strcat('R',NLMatrix{InterconnectIndex(i),1},num2str(j));
    NLMatrix{LengthofNL+3,2} = NLMatrix{InterconnectIndex(i),2};
    NLMatrix{LengthofNL+3,3} = maxPassiveNode;
    NLMatrix{LengthofNL+3,4} = NLMatrix{InterconnectIndex(i),4}*DelX;
    
    %Inductor generation
    
    NLMatrix{LengthofNL+4,1} = strcat('L',NLMatrix{InterconnectIndex(i),1},num2str(j));
    NLMatrix{LengthofNL+4,2} = maxPassiveNode;
    maxPassiveNode             = maxPassiveNode+1;
    NLMatrix{LengthofNL+4,3} = maxPassiveNode;
    NLMatrix{LengthofNL+4,4} = NLMatrix{InterconnectIndex(i),5}*DelX;

        elseif  j == z
                
    %Capacitor generation%
    NLMatrix{LengthofNL+1,1} = strcat('C',NLMatrix{InterconnectIndex(i),1},num2str(j));
    NLMatrix{LengthofNL+1,2} = maxPassiveNode;
    NLMatrix{LengthofNL+1,3} = 0;
    NLMatrix{LengthofNL+1,4} = NLMatrix{InterconnectIndex(i),7}*DelX;
    
    %Conductance generation
    
    NLMatrix{LengthofNL+2,1} = strcat('RG',NLMatrix{InterconnectIndex(i),1},num2str(j));
    NLMatrix{LengthofNL+2,2} = maxPassiveNode;
    NLMatrix{LengthofNL+2,3} = 0;
    NLMatrix{LengthofNL+2,4} = 1/(NLMatrix{InterconnectIndex(i),6}*DelX);
    
    %Resistor generation
    
    NLMatrix{LengthofNL+3,1} = strcat('R',NLMatrix{InterconnectIndex(i),1},num2str(j));
    NLMatrix{LengthofNL+3,2} = maxPassiveNode;
    maxPassiveNode = maxPassiveNode + 1;
    NLMatrix{LengthofNL+3,3} = maxPassiveNode;
    NLMatrix{LengthofNL+3,4} = NLMatrix{InterconnectIndex(i),4}*DelX;
    
    %Inductor generation
    
    NLMatrix{LengthofNL+4,1} = strcat('L',NLMatrix{InterconnectIndex(i),1},num2str(j));
    NLMatrix{LengthofNL+4,2} = maxPassiveNode;
    NLMatrix{LengthofNL+4,3} = NLMatrix{InterconnectIndex(i),3};
    NLMatrix{LengthofNL+4,4} = NLMatrix{InterconnectIndex(i),5}*DelX;
    
        else
            
    %Capacitor generation%
    NLMatrix{LengthofNL+1,1} = strcat('C',NLMatrix{InterconnectIndex(i),1},num2str(j));
    NLMatrix{LengthofNL+1,2} = maxPassiveNode;
    NLMatrix{LengthofNL+1,3} = 0;
    NLMatrix{LengthofNL+1,4} = NLMatrix{InterconnectIndex(i),7}*DelX;
    
    %Conductance generation
    
    NLMatrix{LengthofNL+2,1} = strcat('RG',NLMatrix{InterconnectIndex(i),1},num2str(j));
    NLMatrix{LengthofNL+2,2} = maxPassiveNode;
    NLMatrix{LengthofNL+2,3} = 0;
    NLMatrix{LengthofNL+2,4} = 1/(NLMatrix{InterconnectIndex(i),6}*DelX);
    
    %Resistor Generation
    NLMatrix{LengthofNL+3,1} = strcat('R',NLMatrix{InterconnectIndex(i),1},num2str(j));
    NLMatrix{LengthofNL+3,2} = maxPassiveNode;
    maxPassiveNode = maxPassiveNode + 1;
    NLMatrix{LengthofNL+3,3} = maxPassiveNode;
    NLMatrix{LengthofNL+3,4} = NLMatrix{InterconnectIndex(i),4}*DelX;
    
    %Inductor generation
    
    NLMatrix{LengthofNL+4,1} = strcat('L',NLMatrix{InterconnectIndex(i),1},num2str(j));
    NLMatrix{LengthofNL+4,2} = maxPassiveNode;
    maxPassiveNode = maxPassiveNode + 1;
    NLMatrix{LengthofNL+4,3} = maxPassiveNode;
    NLMatrix{LengthofNL+4,4} = NLMatrix{InterconnectIndex(i),5}*DelX;
    
        end
    end   
    
end   



 [G_Matrix C_Matrix B_Matrix B_MatrixAC X_Matrix maxPassiveNode] = GCXBgenerator(NLMatrix);
 

 j=1
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

 wholeTime = toc;

filename = 'Q1Frequencyfor70.mat';
save(filename);

% fileID = fopen('celldatanew.txt','w');
% formatSpec = '%s %d %d %d\n';
% [nrows,ncols] = size(NLMatrix);
% for row = 1:nrows
%     fprintf(fileID,formatSpec,NLMatrix{row,:});
% end
% fclose(fileID);