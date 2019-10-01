% Most of the code to derive values from netlist and populating the needed
% matrices is from the code for Assignment 1 devoid of Frequeny Logic

clear all;
clc;
%Below two are the nodes across which output voltage is measured
opnode1=13; % Across resistance placed between 13 and 0
opnode2=0;
ipnode2=1;
ipnode1=0;
filename = 'netlist.txt' ; 
fid = fopen(filename);
NLCell = textscan(fid,'%s','Delimiter','\n');   
fclose(fid);
NetList = deblank(NLCell{1}); %%Stores the Netlist in a Cell Matrix with each line as row

number_of_lines=numel(NetList);


 fid = fopen(filename);
for n = 1:number_of_lines
SplitNL{n,1} = strsplit(char(NetList(n))); %%splitting done into columns
end
fclose(fid);

%%Each row will be having different number of columns so making column
  %%value constant = 8 and filling them with '0'
for k=1:number_of_lines
  L = length(SplitNL{k});
  SplitNL{k}(L+1:8) = {'0'}; 
end

%%Converting input into a Netlist in the form of Matrix for easy aces of
%%elements
for n = 1:8
    NLMatrix(:, n) = cellfun(@(x) strtrim(x(n)), SplitNL);
end
NLMatrixDecoy=NLMatrix
%%Numbers are stores as strings in this matrix.The below converts number strings to
%%numeric
a=1;
for i=1:size(NLMatrix,1)
    for j=1:8
        a=a+1;
      array{a}=str2double(NLMatrix(i,j));  
if  isnan(str2double(NLMatrix(i,j)))
    NLMatrix(i,j)=NLMatrix(i,j);
 else
     NLMatrix{i,j}=str2double(NLMatrix(i,j));
 end
    end
end
    

%%VSurceInex stores the row numbers starting with V ie DC Voltage source
VSourceIndex = strmatch('V', char(NLMatrix(:,1)));


NLMatrixCopy=NLMatrix;
%z=maxPassiveNode;

VCCSIndex = strmatch('G', char(NLMatrix(:,1)));



% for i=1:length(VSourceIndex)
%     %%a and b are nodes where independent DC voltage source is present 
%     a=min(NLMatrix{VSourceIndex(i),2},NLMatrix{VSourceIndex(i),3});
%     b=max(NLMatrix{VSourceIndex(i),2},NLMatrix{VSourceIndex(i),3});
%     
%     %%The main aim of this code is to short thr DC voltage sources . Done
%     %%by renaming nodes For eg If there is a DC source between node 4 and
%     %%node 5, node 5 becomes new node 4 and node 6 becomes node 5 and so on
%     
%     %%Columns 2 and 3 are checked as they have all nodes so checking 2
%     %%columns only
%     for j=1:length(NLMatrix)
%     if  NLMatrix{j,2}== b
%         NLMatrix{j,2}=a;
%        
%     end
%     if NLMatrix{j,2}> b
%        NLMatrix{j,2}=NLMatrix{j,2}-1;
%     end
%     
%     if  NLMatrix{j,3}== b
%         NLMatrix{j,3}=a;
%       
%     end
%     if NLMatrix{j,3}> b
%        NLMatrix{j,3}=NLMatrix{j,3}-1;
%     end
%     end
%     
%     %%For VCCS the even column 4,5 in Netlist have nodes so modifying them
%     %%also
%     for k=1:length(VCCSIndex)
%     if  NLMatrix{VCCSIndex(k),4}== b
%     NLMatrix{VCCSIndex(k),4}=a;
%       
%     end
%     if NLMatrix{VCCSIndex(k),4}> b
%        NLMatrix{VCCSIndex(k),4}=NLMatrix{VCCSIndex(k),4}-1;
%     end
%     
%     if  NLMatrix{VCCSIndex(k),5}== b
%     NLMatrix{VCCSIndex(k),5}=a;
%       
%     end
%     if NLMatrix{VCCSIndex(k),5}> b
%        NLMatrix{VCCSIndex(k),5}=NLMatrix{VCCSIndex(k),5}-1;
%     end
%     end
%      
% end


 a=max([NLMatrix{:,2}]);
 b=max([NLMatrix{:,3}]);
 %Below is number of Max nodes in the circuit
 maxPassiveNode=max(a,b);
 
 %%Below 4 are used to get row numbers of respective electrical elements
 
ResistorIndex           = strmatch('R', char(NLMatrix(:,1)));
CapacitorIndex          = strmatch('C', char(NLMatrix(:,1)));
VCCSIndex               = strmatch('G', char(NLMatrix(:,1)));
ACSourceIndex           = strmatch('AC', char(NLMatrix(:,1)));
NonLinearResistorIndex   = strmatch('NLR', char(NLMatrix(:,1)));


%%As this is SMALL SIGNAL ANALYSIS DC Voltages are neglected so their
%%respective rows and columns too are not added in G+SC Matrix

RowsMNA=maxPassiveNode+length(VSourceIndex)+length(ACSourceIndex);
ColsMNA=maxPassiveNode+length(VSourceIndex)+length(ACSourceIndex);

G_Matrix=zeros(RowsMNA,RowsMNA);
C_Matrix=cell(RowsMNA,RowsMNA);
B_Matrix=zeros(RowsMNA,1);
F_matrix=cell(RowsMNA,1);
B_MatrixAC=zeros(RowsMNA,1);

%%Below fills C_Matrix with zeros
     ix=cellfun('isempty',C_Matrix);
     C_Matrix(ix)={0};
     
     ix=cellfun('isempty',F_matrix);
     F_matrix(ix)={0};

%%This is for populating G matrix with Row Data
for i=1:length(ResistorIndex)
    a=min(NLMatrix{ResistorIndex(i),2},NLMatrix{ResistorIndex(i),3});
      
    b=max(NLMatrix{ResistorIndex(i),2},NLMatrix{ResistorIndex(i),3});
        
    
    if a==0
        G_Matrix(b,b)=(G_Matrix(b,b)+(1/(NLMatrix{ResistorIndex(i),4})));
    else
      
        G_Matrix(a,a)=(G_Matrix(a,a)+(1/(NLMatrix{ResistorIndex(i),4})));
        G_Matrix(b,b)=(G_Matrix(b,b)+(1/(NLMatrix{ResistorIndex(i),4})));
        G_Matrix(a,b)=(G_Matrix(a,b)-(1/(NLMatrix{ResistorIndex(i),4})));
        G_Matrix(b,a)=(G_Matrix(b,a)-(1/(NLMatrix{ResistorIndex(i),4})));
    end 
    
end


for i=1:maxPassiveNode
    X_Matrix{i,1}=strcat('V',num2str(i));

end


for i=1:length(CapacitorIndex)
    a=min(NLMatrix{CapacitorIndex(i),2},NLMatrix{CapacitorIndex(i),3});
      

    b=max(NLMatrix{CapacitorIndex(i),2},NLMatrix{CapacitorIndex(i),3});
            

    
    if a==0
       
        C_Matrix{b,b}=C_Matrix{b,b}+(NLMatrix{CapacitorIndex(i),4});
    else
        

        C_Matrix{a,a}=C_Matrix{a,a}+(NLMatrix{CapacitorIndex(i),4});
        C_Matrix{b,b}=C_Matrix{b,b}+(NLMatrix{CapacitorIndex(i),4});
        C_Matrix{a,b}=C_Matrix{a,b}-(NLMatrix{CapacitorIndex(i),4});
        C_Matrix{b,a}=C_Matrix{b,a}-(NLMatrix{CapacitorIndex(i),4});        

    end 
end

% z is used as reference to the number folowed by maximum number of passive
% nodes and is later used to store the voltage of input triangular wave
z=maxPassiveNode;

for i=1:length(VSourceIndex)
    a=min(NLMatrix{VSourceIndex(i),2},NLMatrix{VSourceIndex(i),3});
    b=max(NLMatrix{VSourceIndex(i),2},NLMatrix{VSourceIndex(i),3});
    z=z+1;
    if a==0
        G_Matrix(b,z)=1;
        G_Matrix(z,b)=1;
    else
        G_Matrix(a,z)=1;
        G_Matrix(z,a)=1;
        G_Matrix(b,z)=-1;
        G_Matrix(z,b)=-1;
    end
      B_Matrix(z,1)=NLMatrix{VSourceIndex(i),4};
      B_MatrixAC(z,1)=0;
      X_Matrix{z,1}=strcat('I_',NLMatrix{VSourceIndex(i),1});
end
for i=1:length(ACSourceIndex)
    a=min(NLMatrix{ACSourceIndex(i),2},NLMatrix{ACSourceIndex(i),3});
    b=max(NLMatrix{ACSourceIndex(i),2},NLMatrix{ACSourceIndex(i),3});
    z=z+1;
    if a==0
        G_Matrix(b,z)=1;
        G_Matrix(z,b)=1;
    else
        G_Matrix(a,z)=1;
        G_Matrix(z,a)=1;
        G_Matrix(b,z)=-1;
        G_Matrix(z,b)=-1;
    end
      B_Matrix(z,1)=NLMatrix{ACSourceIndex(i),5};
      B_MatrixAC(z,1)=NLMatrix{ACSourceIndex(i),5};
      X_Matrix{z,1}=strcat('I_',NLMatrix{ACSourceIndex(i),1});
      
end


%below logic derives modified nodes for output and input as shorting of VDC
%reduces the number of nodes
for i=1:length(VCCSIndex)
    a=min(NLMatrix{VCCSIndex(i),4},NLMatrix{VCCSIndex(i),5});
    b=max(NLMatrix{VCCSIndex(i),4},NLMatrix{VCCSIndex(i),5});
    
    c=min(NLMatrix{VCCSIndex(i),2},NLMatrix{VCCSIndex(i),3});
    d=max(NLMatrix{VCCSIndex(i),2},NLMatrix{VCCSIndex(i),3});
    
    if a==0 && c~=0
        G_Matrix(d,b)=(G_Matrix(d,b)+((NLMatrix{VCCSIndex(i),6})));
        G_Matrix(c,b)=(G_Matrix(c,b)-((NLMatrix{VCCSIndex(i),6})));
    end
    
    if c==0 && a~=0
       G_Matrix(d,a)=(G_Matrix(d,a)-((NLMatrix{VCCSIndex(i),6})));
       G_Matrix(d,b)=(G_Matrix(d,b)+((NLMatrix{VCCSIndex(i),6})));
    end
    
     if c==0 && a==0

       G_Matrix(d,b)=(G_Matrix(d,b)+((NLMatrix{VCCSIndex(i),6})));
    end 
    if a~=0 && c~=0
        G_Matrix(c,a)=(G_Matrix(c,a)+((NLMatrix{VCCSIndex(i),6})));
        G_Matrix(d,b)=(G_Matrix(d,b)+((NLMatrix{VCCSIndex(i),6})));
        G_Matrix(c,b)=(G_Matrix(c,b)-((NLMatrix{VCCSIndex(i),6})));
        G_Matrix(d,a)=(G_Matrix(d,a)-((NLMatrix{VCCSIndex(i),6})));
    end 
end


SymString='syms s e ';

for i=1:length(X_Matrix)
    SymString=[SymString X_Matrix{i} ' '];
end

eval(SymString)

for i=1:length(NonLinearResistorIndex)
    a=min(NLMatrix{NonLinearResistorIndex(i),2},NLMatrix{NonLinearResistorIndex(i),3});
    b=max(NLMatrix{NonLinearResistorIndex(i),2},NLMatrix{NonLinearResistorIndex(i),3});
    
 if a==0
        Dummy=(NLMatrix{NonLinearResistorIndex(i),4});
        s=strcat('(',X_Matrix(b,1),')');
        Dummy=strrep(Dummy, 'VD', s);
        %Dummy=strrep(Dummy, 'e', num2str(exp(1)));
        F_matrix{b,1}= subs(Dummy);
        
        
 else
        Dummy=(NLMatrix{NonLinearResistorIndex(i),4});
        s=strcat('(',X_Matrix(a,1),'-',X_Matrix(b,1),')');
        Dummy=strrep(Dummy, 'VD', s);
        %Dummy=strrep(Dummy, 'e', num2str(exp(1)));
        Dummy2=strcat('-',Dummy);
        F_matrix(a,1)=subs(Dummy);
        F_matrix(b,1)=subs(Dummy2);
    end 
     
end


DiffF_matrix=cell(RowsMNA,RowsMNA);
ix=cellfun('isempty',DiffF_matrix);
     DiffF_matrix(ix)={0};
     
     e=exp(1);
     
for i=1:1:RowsMNA
    for j=1:1:RowsMNA
        if isnumeric(F_matrix{i,1}) ~= 1
        DiffF_matrix{i,j}= diff(F_matrix{i,1},X_Matrix(j));
        end
    end
end

Xguess_Matrix=zeros(RowsMNA,1);
% Xguess_Matrix = Xguess_Matrix - (F_matrix/DiffF_matrix);

Xguess_Matrix = [1;0;0;0];      %initial guess
Term=[1;1;1;1];


j=1;

while abs(Term(2,1)) >= 0.00001  && j<4
    kya=1;
    
ExtraTerm=    G_Matrix*Xguess_Matrix-B_Matrix;

ExtraTermTracker{j}=ExtraTerm;
Fatzero=subs(F_matrix,X_Matrix,Xguess_Matrix);

FatzeroTracker{j}=Fatzero;


DifFatzero=subs(DiffF_matrix,X_Matrix,Xguess_Matrix);

DifFatzeroTracker{j}=DifFatzero;

Fatzero=eval(Fatzero);
Fatzero=ExtraTerm+Fatzero;
DifFatzero=eval(DifFatzero);



M_Matrix=G_Matrix+DifFatzero;

MatrixTracker{j}=M_Matrix;
FTracker{j}=Fatzero;
Term=M_Matrix\Fatzero;

TermTracker{j}=Term;

Xguess_Matrix=Xguess_Matrix-Term;

CheckerXmatrix{j}=Xguess_Matrix;
j=j+1;

end

% 
% 

Astring='A=[';
Xstring='X=[';
Zstring='Z=[';

% % % X_Matrix, GSC_Matrix, B_Matrix

for i=1:length(X_Matrix),     %for each row in the arrays.

    Xstring=[Xstring  X_Matrix{i} ';'];    %Enter element into array X;
    
end
  %Close array assignment.
Xstring=[Xstring '];'];

%

% 
% %Evaluate strings with array assignments.
% eval(Xstring)
 
%Done creating the variables A, X, and Z ----------------------------
C_Matrix=cell2mat(C_Matrix);

% TotalTime = 0.06;  %time for which the output should be shown
% NoSampledPoints=1000; %number of steps in which time is to be sampled
% 
% MaxVoltage=50; %voltage of input graph
% 
% h=TotalTime/NoSampledPoints; %step size
% 
% %till 10 MHz in 10 Hz step.starting is zero as 
% 
% 
% B_Matrix(z,1)=0; %Removing the dummy value given in netlist for the ac source
% B_MatrixTimeCell{1}=B_Matrix;
% 
% %B_MatrixTimeCell is a cell array that stores in it collection of values of
% %B matrices at all time points
% 
% %Below for loops construct the B MAtrix on basis of the input information
% %given
% 
% j=2;
% for t=h:h:0.005  
% B_Matrix(z,1)=MaxVoltage*t/0.005;
% B_MatrixTimeCell{j}=B_Matrix;
% j=j+1;
% end
% 
% 
% for t=t(length(t))+h:h:0.025
%     
% B_Matrix(z,1)=MaxVoltage;
% B_MatrixTimeCell{j}=B_Matrix;
% j=j+1;
% end
%   
% 
% for t=t(length(t))+h:h:0.030
%     
% B_Matrix(z,1)=MaxVoltage*(0.03-t)/0.005;
% B_MatrixTimeCell{j}=B_Matrix;
% j=j+1;
% end
% 
% 
% 
% for t=t(length(t))+h:h:TotalTime
%     
% B_Matrix(z,1)=0;
% B_MatrixTimeCell{j}=B_Matrix;
% j=j+1;
% end
% 
% 
% %these matrices are used in the formula derived from Trapezoidal rule
% B2matrix=C_Matrix/h-G_Matrix/2;
% Amatrix=C_Matrix/h+G_Matrix/2;
% 
% X_MatrixCell{1}=G_Matrix\B_Matrix;
% 
% %trapezoidal rule depends on previous time instance which starts from
% %Ginverse multiplied by B
% 
% for j=2:1:length(B_MatrixTimeCell)
% X_MatrixCell{j}=(Amatrix)\(((B_MatrixTimeCell{j}+B_MatrixTimeCell{j-1})/2)+B2matrix*X_MatrixCell{j-1});
% end
% 
% %below two, convert the cell arrays of both B and X into matrices which can
% %be used for plotting
% 
% for  k=1:1:length(X_MatrixCell)
% magnitudeIP(k) = B_MatrixTimeCell{k}(z);
% magnitudeOP(k) = X_MatrixCell{k}(opnode1); 
% end
% 
% 
% time = 0:1000*h:1000*TotalTime;  % to match matrix dimensions with what is to be shown in x axis
% 
% figure
% subplot(2,1,1)       % add second plot in 2 x 1 grid
% plot ( time, magnitudeIP )
% xlabel('Time in MilliSeconds');
% ylabel('Vin at input');
% title('Time Response of Input')
% 
% 
% subplot(2,1,2)       % add second plot in 2 x 1 grid
% plot ( time, magnitudeOP )
% xlabel('Time in MilliSeconds');
% ylabel('Vout across resistance');
% title('Time Response of Output')
