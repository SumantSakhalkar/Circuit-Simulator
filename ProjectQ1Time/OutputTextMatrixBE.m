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
    
    
%    z=50*(ceil(round(NumberofSegments(i))/50.))+ 100;
    
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
 
 TotalTime = 10e-9;  %time for which the output should be shown
NoSampledPoints=1000; %number of steps in which time is to be sampled

MaxVoltage=1; %voltage of input graph

h=TotalTime/NoSampledPoints; %step size

%till 10 MHz in 10 Hz step.starting is zero as 

z=maxPassiveNode+1;


B_Matrix(z,1)=0; %Removing the dummy value given in netlist for the ac source
B_MatrixTimeCell{1}=B_Matrix;
 

j=2;

for n= 1:10 
    B_Matrix(z,1)=n*(MaxVoltage/10);
    B_Matrix(z+1,1)=n*(MaxVoltage/10);
    B_MatrixTimeCell{j}=B_Matrix;
	j=j+1;
end
j=j-1;
for n= 10:510
   
        B_Matrix(z,1) = MaxVoltage;
        B_Matrix(z+1,1)=B_Matrix(z,1);
		B_MatrixTimeCell{j}=B_Matrix;
		j=j+1;
end

j=j-1;
for n = 510:520
        
     B_Matrix(z,1) = MaxVoltage - (n-510)*(MaxVoltage/10);
     B_Matrix(z+1,1)=B_Matrix(z,1);
	 B_MatrixTimeCell{j}=B_Matrix;
	 j=j+1;	
end 
j=j-1;
for n = 520:1000
    
    B_Matrix(z,1) = 0;
    B_Matrix(z+1,1)=0;
	B_MatrixTimeCell{j}=B_Matrix;
    j=j+1;
end    
pulse(520) = 0;



% plot(pulse)
% 
% 
 %these matrices are used in the formula derived from Trapezoidal rule
%B2matrix=C_Matrix/h-G_Matrix/2;
%Amatrix=C_Matrix/h+G_Matrix/2;


AmatrixBE=C_Matrix/h+G_Matrix;
B2matrixBE=C_Matrix/h;

[L,U] = lu(AmatrixBE);

X_MatrixCell{1}=(U\(L\B_Matrix));



for j=2:1:length(B_MatrixTimeCell)
X_MatrixCell{j}=U\(L\(B_MatrixTimeCell{j}+B2matrixBE*X_MatrixCell{j-1}));
    end

	%trapezoidal rule depends on previous time instance which starts from
%Ginverse multiplied by B

%for j=2:1:length(B_MatrixTimeCell)
%X_MatrixCell{j}=(Amatrix)\(((B_MatrixTimeCell{j}+B_MatrixTimeCell{j-1})/2)+B2matrix*X_MatrixCell{j-1});
%    end

%below two, convert the cell arrays of both B and X into matrices which can
%be used for plotting
 wholeTime = toc;
 

 
filename = 'Q1Timefor100BE.mat';
save(filename);