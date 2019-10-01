function [G_Matrix C_Matrix B_Matrix B_MatrixAC X_Matrix maxPassiveNode] = GCXBgenerator(NLMatrix)

%%VSurceInex stores the row numbers starting with V ie DC Voltage source
VSourceIndex = strmatch('V', char(NLMatrix(:,1)));


NLMatrixCopy=NLMatrix;
%z=maxPassiveNode;

VCCSIndex = strmatch('G', char(NLMatrix(:,1)));


 a=max([NLMatrix{:,2}]);
 b=max([NLMatrix{:,3}]);
 %Below is number of Max nodes in the circuit
 maxPassiveNode=max(a,b);
 
 %%Below 4 are used to get row numbers of respective electrical elements
 
ResistorIndex   = strmatch('R', char(NLMatrix(:,1)));
CapacitorIndex  = strmatch('C', char(NLMatrix(:,1)));
InductorIndex   = strmatch('L', char(NLMatrix(:,1)));
VCCSIndex       = strmatch('G', char(NLMatrix(:,1)));
VACSourceIndex   = strmatch('ACV', char(NLMatrix(:,1)));
CSourceIndex    = strmatch('IS', char(NLMatrix(:,1)));
CACSourceIndex    = strmatch('ACI', char(NLMatrix(:,1)));

VCVSIndex = strmatch('AV', char(NLMatrix(:,1)));

%%As this is SMALL SIGNAL ANALYSIS DC Voltages are neglected so their
%%respective rows and columns too are not added in G+SC Matrix

RowsMNA=maxPassiveNode+length(VSourceIndex)+length(VACSourceIndex)+length(InductorIndex)+length(VCVSIndex);
ColsMNA=maxPassiveNode+length(VSourceIndex)+length(VACSourceIndex)+length(InductorIndex)+length(VCVSIndex);

G_Matrix=zeros(RowsMNA,RowsMNA);
C_Matrix=cell(RowsMNA,RowsMNA);
B_Matrix=zeros(RowsMNA,1);
B_MatrixAC=zeros(RowsMNA,1);

%%Below fills C_Matrix with zeros
     ix=cellfun('isempty',C_Matrix);
     C_Matrix(ix)={0};

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

if length(VSourceIndex) ~= 0
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
      B_MatrixAC(z,1)=B_MatrixAC(z,1);
      X_Matrix{z,1}=strcat('I_',NLMatrix{VSourceIndex(i),1});
end
end

%Stamp  for Inductor 
for i=1:length(InductorIndex)
    a=min(NLMatrix{InductorIndex(i),2},NLMatrix{InductorIndex(i),3});
    b=max(NLMatrix{InductorIndex(i),2},NLMatrix{InductorIndex(i),3});
    z=z+1;
    if a==0
        G_Matrix(b,z)=1;
        G_Matrix(z,b)=1;
        C_Matrix{z,z}=-NLMatrix{InductorIndex(i),4};
    else
        G_Matrix(a,z)=1;
        G_Matrix(z,a)=1;
        G_Matrix(b,z)=-1;
        G_Matrix(z,b)=-1;
        C_Matrix{z,z}=-NLMatrix{InductorIndex(i),4};
        
    end
      B_Matrix(z,1)=NLMatrix{InductorIndex(i),4};
      B_MatrixAC(z,1)=B_MatrixAC(z,1);
      X_Matrix{z,1}=strcat('I_',NLMatrix{InductorIndex(i),1});
      
end



for i=1:length(CSourceIndex)
    a=min(NLMatrix{CSourceIndex(i),2},NLMatrix{CSourceIndex(i),3});
    b=max(NLMatrix{CSourceIndex(i),2},NLMatrix{CSourceIndex(i),3});
    if a==0
        B_Matrix(b,1)=B_Matrix(b,1)+NLMatrix{CSourceIndex(i),4};
    else
         B_Matrix(a,1)=B_Matrix(a,1)+NLMatrix{CSourceIndex(i),4};
         B_Matrix(b,1)=B_Matrix(b,1)-NLMatrix{CSourceIndex(i),4};
    end

end

for i=1:length(CACSourceIndex)
    a=min(NLMatrix{CACSourceIndex(i),2},NLMatrix{CACSourceIndex(i),3});
    b=max(NLMatrix{CACSourceIndex(i),2},NLMatrix{CACSourceIndex(i),3});
    if a==0
         B_Matrix(b,1)  =B_Matrix(b,1)+NLMatrix{CACSourceIndex(i),4};
         B_MatrixAC(b,1)=B_MatrixAC(b,1)+NLMatrix{CACSourceIndex(i),4};
    else
         B_Matrix(a,1)=B_Matrix(a,1)+NLMatrix{CACSourceIndex(i),4};
         B_Matrix(b,1)=B_Matrix(b,1)-NLMatrix{CACSourceIndex(i),4};
         
         B_MatrixAC(a,1)=B_MatrixAC(a,1)+NLMatrix{CACSourceIndex(i),4};
         B_MatrixAC(b,1)=B_MatrixAC(b,1)-NLMatrix{CACSourceIndex(i),4};
    end

end





for i=1:length(VACSourceIndex)
    a=min(NLMatrix{VACSourceIndex(i),2},NLMatrix{VACSourceIndex(i),3});
    b=max(NLMatrix{VACSourceIndex(i),2},NLMatrix{VACSourceIndex(i),3});
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
      B_Matrix(z,1)=NLMatrix{VACSourceIndex(i),5};
      B_MatrixAC(z,1)=NLMatrix{VACSourceIndex(i),5};
      X_Matrix{z,1}=strcat('I_',NLMatrix{VACSourceIndex(i),1});
      
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

%Code for Voltage controlled voltage source
if length(VCVSIndex)~=0
for i=1:length(VCVSIndex)

    a=min(NLMatrix{VCVSIndex(i),4},NLMatrix{VCVSIndex(i),5});
    b=max(NLMatrix{VCVSIndex(i),4},NLMatrix{VCVSIndex(i),5});
    
    c=min(NLMatrix{VCVSIndex(i),2},NLMatrix{VCVSIndex(i),3});
    d=max(NLMatrix{VCVSIndex(i),2},NLMatrix{VCVSIndex(i),3});
    
    z=z+1;
    
    if a==0 && c~=0
        G_Matrix(c,z)=1;
        G_Matrix(z,c)=1;
        G_Matrix(d,z)=-1;
        G_Matrix(z,d)=-1;
        G_Matrix(z,b)=NLMatrix{VCVSIndex(i),6};
       
    end
    
    if c==0 && a~=0

        G_Matrix(d,z)=1;
        G_Matrix(z,d)=1;
        G_Matrix(z,a)=NLMatrix{VCVSIndex(i),6};
        G_Matrix(z,b)=-NLMatrix{VCVSIndex(i),6};
    end
    
     if c==0 && a==0

        G_Matrix(d,z)=1;
        G_Matrix(z,d)=1;
        G_Matrix(z,b)=NLMatrix{VCVSIndex(i),6};
    end 
    if a~=0 && c~=0
        G_Matrix(c,z)=1;
        G_Matrix(z,c)=1;
        G_Matrix(d,z)=-1;
        G_Matrix(z,d)=-1;
        G_Matrix(z,a)=NLMatrix{VCVSIndex(i),6};
        G_Matrix(z,b)=-NLMatrix{VCVSIndex(i),6};
    end 
    

      X_Matrix{z,1}=strcat('I_',NLMatrix{VCVSIndex(i),1});
end
end



C_Matrix=cell2mat(C_Matrix);
