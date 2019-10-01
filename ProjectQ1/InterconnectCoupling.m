function [NLMatrix] = InterconnectCoupling(NLMatrix,MaxFrquency)

 a=max([NLMatrix{:,2}]);
 b=max([NLMatrix{:,3}]);
 %Below is number of Max nodes in the circuit
 maxPassiveNodeOriginal=max(a,b);
 
 maxPassiveNode = maxPassiveNodeOriginal;

        
 InterconnectIndex = strmatch('TL', char(NLMatrix(:,1)));


for i=1:length(InterconnectIndex)
    
    
    NumberofSegments(i)     = 20 * NLMatrix{InterconnectIndex(i),8} * MaxFrquency* sqrt(NLMatrix{InterconnectIndex(i),5} * NLMatrix{InterconnectIndex(i),7}) ;
    
    z=round(NumberofSegments(i));
    
    InterconnectNodeHandler{i,1} = NLMatrix{InterconnectIndex(i),1};
    
    DelX= NLMatrix{InterconnectIndex(i),8}/z;
    
    for j=1:z 
    LengthofNL=length(NLMatrix(:,2));
    
    if j==1
        
    InterconnectNodeHandler{i,2} = NLMatrix{InterconnectIndex(i),2};
        
    %Capacitor generation%
    NLMatrix{LengthofNL+1,1} = strcat('C',NLMatrix{InterconnectIndex(i),1});
    NLMatrix{LengthofNL+1,2} = NLMatrix{InterconnectIndex(i),2};
    NLMatrix{LengthofNL+1,3} = 0;
    NLMatrix{LengthofNL+1,4} = NLMatrix{InterconnectIndex(i),7}*DelX;
    
    %Conductance generation
    
    NLMatrix{LengthofNL+2,1} = strcat('RG',NLMatrix{InterconnectIndex(i),1});
    NLMatrix{LengthofNL+2,2} = NLMatrix{InterconnectIndex(i),2};
    NLMatrix{LengthofNL+2,3} = 0;
    NLMatrix{LengthofNL+2,4} = 1/NLMatrix{InterconnectIndex(i),6}*DelX;
    
    %Resistor generation%
    maxPassiveNode = maxPassiveNode+1;
    NLMatrix{LengthofNL+3,1} = strcat('R',NLMatrix{InterconnectIndex(i),1});
    NLMatrix{LengthofNL+3,2} = NLMatrix{InterconnectIndex(i),2};
    NLMatrix{LengthofNL+3,3} = maxPassiveNode;
    NLMatrix{LengthofNL+3,4} = NLMatrix{InterconnectIndex(i),4}*DelX;
    
    %Inductor generation
    
    InterconnectNodeHandler{i,5} = maxPassiveNode;
    
    NLMatrix{LengthofNL+4,1} = strcat('L',NLMatrix{InterconnectIndex(i),1});
    NLMatrix{LengthofNL+4,2} = maxPassiveNode;
    maxPassiveNode             = maxPassiveNode+1;
    NLMatrix{LengthofNL+4,3} = maxPassiveNode;
    NLMatrix{LengthofNL+4,4} = NLMatrix{InterconnectIndex(i),5}*DelX;
     
   %Mutual Inductor ie voltage source generation
    
   increment=1;
        for k=1:length(InterconnectIndex)
            if k ~= i
            NLMatrix{LengthofNL+4+increment,1} = strcat('AV',NLMatrix{InterconnectIndex(i),1});
            NLMatrix{LengthofNL+4+increment,2} = maxPassiveNode;
            maxPassiveNode                     = maxPassiveNode+1;
            NLMatrix{LengthofNL+4+increment,3} = maxPassiveNode;
            NLMatrix{LengthofNL+4+increment,4} = k;
            NLMatrix{LengthofNL+4+increment,5} = k;
            NLMatrix{LengthofNL+4+increment,6} = NLMatrix{InterconnectIndex(i),8+increment}*DelX/NLMatrix{InterconnectIndex(k),5};
            increment = increment +1 ;
            end
        end
       
    InterconnectNodeHandler{i,3}=maxPassiveNode;

    elseif  j == z
        
    InterconnectNodeHandler{i,4}=maxPassiveNode;
                
    %Capacitor generation%
    NLMatrix{LengthofNL+1,1} = strcat('C',NLMatrix{InterconnectIndex(i),1});
    NLMatrix{LengthofNL+1,2} = maxPassiveNode;
    NLMatrix{LengthofNL+1,3} = 0;
    NLMatrix{LengthofNL+1,4} = NLMatrix{InterconnectIndex(i),7}*DelX;
    
    %Conductance generation
    
    NLMatrix{LengthofNL+2,1} = strcat('RG',NLMatrix{InterconnectIndex(i),1});
    NLMatrix{LengthofNL+2,2} = maxPassiveNode;
    NLMatrix{LengthofNL+2,3} = 0;
    NLMatrix{LengthofNL+2,4} = 1/NLMatrix{InterconnectIndex(i),6}*DelX;
    
    %Resistor generation
    InterconnectNodeHandler{i,6} = maxPassiveNode;  %same as column4 so not needed
    
    NLMatrix{LengthofNL+3,1} = strcat('R',NLMatrix{InterconnectIndex(i),1});
    NLMatrix{LengthofNL+3,2} = maxPassiveNode;
    maxPassiveNode = maxPassiveNode + 1;
    NLMatrix{LengthofNL+3,3} = maxPassiveNode;
    NLMatrix{LengthofNL+3,4} = NLMatrix{InterconnectIndex(i),4}*DelX;
    
    %Inductor generation
    
    NLMatrix{LengthofNL+4,1} = strcat('L',NLMatrix{InterconnectIndex(i),1});
    NLMatrix{LengthofNL+4,2} = maxPassiveNode;
    maxPassiveNode           = maxPassiveNode+1;
    NLMatrix{LengthofNL+4,3} = maxPassiveNode;
    NLMatrix{LengthofNL+4,4} = NLMatrix{InterconnectIndex(i),5}*DelX;
    
        %Mutual Inductor ie voltage source generation
    increment=1;
        for k=1:length(InterconnectIndex)  
            if k ~= i
                NLMatrix{LengthofNL+4+increment,1} = strcat('AV',NLMatrix{InterconnectIndex(i),1});
                NLMatrix{LengthofNL+4+increment,2} = maxPassiveNode;
                maxPassiveNode                     = maxPassiveNode+1;
                NLMatrix{LengthofNL+4+increment,3} = maxPassiveNode;
                NLMatrix{LengthofNL+4+increment,4} = k;
                NLMatrix{LengthofNL+4+increment,5} = k;
                NLMatrix{LengthofNL+4+increment,6} = NLMatrix{InterconnectIndex(i),8+increment}*DelX/NLMatrix{InterconnectIndex(k),5};
                increment = increment +1 ;
            end
        end
        
            
            maxPassiveNode=maxPassiveNode-1;
            NLMatrix{LengthofNL+4+increment-1,3} = NLMatrix{InterconnectIndex(i),3};
           
    
    else
            
    %Capacitor generation%
    NLMatrix{LengthofNL+1,1} = strcat('C',NLMatrix{InterconnectIndex(i),1});
    NLMatrix{LengthofNL+1,2} = maxPassiveNode;
    NLMatrix{LengthofNL+1,3} = 0;
    NLMatrix{LengthofNL+1,4} = NLMatrix{InterconnectIndex(i),7}*DelX;
    
    %Conductance generation
    
    NLMatrix{LengthofNL+2,1} = strcat('RG',NLMatrix{InterconnectIndex(i),1});
    NLMatrix{LengthofNL+2,2} = maxPassiveNode;
    NLMatrix{LengthofNL+2,3} = 0;
    NLMatrix{LengthofNL+2,4} = 1/NLMatrix{InterconnectIndex(i),6}*DelX;
    
    %Resistor Generation
    NLMatrix{LengthofNL+3,1} = strcat('R',NLMatrix{InterconnectIndex(i),1});
    NLMatrix{LengthofNL+3,2} = maxPassiveNode;
    maxPassiveNode = maxPassiveNode + 1;
    NLMatrix{LengthofNL+3,3} = maxPassiveNode;
    NLMatrix{LengthofNL+3,4} = NLMatrix{InterconnectIndex(i),4}*DelX;
    
    %Inductor generation
    
    NLMatrix{LengthofNL+4,1} = strcat('L',NLMatrix{InterconnectIndex(i),1});
    NLMatrix{LengthofNL+4,2} = maxPassiveNode;
    maxPassiveNode = maxPassiveNode + 1;
    NLMatrix{LengthofNL+4,3} = maxPassiveNode;
    NLMatrix{LengthofNL+4,4} = NLMatrix{InterconnectIndex(i),5}*DelX;
    
    %Mutual Inductor ie voltage source generation
    
    increment=1;
    
    for k=1:length(InterconnectIndex)   
    if k ~= i
    NLMatrix{LengthofNL+4+increment,1} = strcat('AV',NLMatrix{InterconnectIndex(i),1});
    NLMatrix{LengthofNL+4+increment,2} = maxPassiveNode;
    maxPassiveNode                     = maxPassiveNode+1;
    NLMatrix{LengthofNL+4+increment,3} = maxPassiveNode;
    NLMatrix{LengthofNL+4+increment,4} = k;
    NLMatrix{LengthofNL+4+increment,5} = k;    
    NLMatrix{LengthofNL+4+increment,6} = NLMatrix{InterconnectIndex(i),8+increment}*DelX/NLMatrix{InterconnectIndex(k),5};
    increment = increment +1 ;
    end
    end
    
        end
    end   
end


% Below is for coupled
for i=1:length(InterconnectIndex)
    LengthofNL=length(NLMatrix(:,2));
    increment=1;
    
    for j=1:length(InterconnectNodeHandler(:,1))
        if i<j
        NLMatrix{LengthofNL+increment,1} = strcat('CC',NLMatrix{InterconnectIndex(i),1},NLMatrix{InterconnectIndex(j),1});
        NLMatrix{LengthofNL+increment,2} = InterconnectNodeHandler{i,2};
        NLMatrix{LengthofNL+increment,3} = InterconnectNodeHandler{j,2};
        NLMatrix{LengthofNL+increment,4} = NLMatrix{InterconnectIndex(i),10+increment}*DelX;
        increment= increment +1 ;
        end
    end
end

for i=1:length(InterconnectIndex)
    LengthofNL=length(NLMatrix(:,2));
    increment=1;
    for j=1:length(InterconnectNodeHandler(:,1))
        if i<j 
        node1  =    InterconnectNodeHandler{i,3};
        node2  =    InterconnectNodeHandler{j,3};
        
            while node1 <= InterconnectNodeHandler{i,4}
            NLMatrix{LengthofNL+increment,1} = strcat('CC',NLMatrix{InterconnectIndex(i),1},NLMatrix{InterconnectIndex(j),1});
            NLMatrix{LengthofNL+increment,2} = node1;
            NLMatrix{LengthofNL+increment,3} = node2;
            NLMatrix{LengthofNL+increment,4} = NLMatrix{InterconnectIndex(i),10+j-i}*DelX;
            node1=node1+4;
            node2=node2+4;
            increment= increment +1 ;
            end
        end
    end
end

VCVSTLIndex = strmatch('AVT', char(NLMatrix(:,1)));

NLMatrixBeforeVCVS=NLMatrix;

for j=1:length(InterconnectNodeHandler(:,1))
   
    node1  =    InterconnectNodeHandler{j,5};
        for i=1:length(VCVSTLIndex)
            if node1 > (InterconnectNodeHandler{j,4}+4)
                node1=InterconnectNodeHandler{j,5};
            end
            
        if (NLMatrix{VCVSTLIndex(i),4} == j) && (NLMatrix{VCVSTLIndex(i),5} == j)
          
            if node1 <= (InterconnectNodeHandler{j,4}+4)
            NLMatrix{VCVSTLIndex(i),4} = node1;
            NLMatrix{VCVSTLIndex(i),5} = node1+1;
            node1=node1+4;
            end
         end
        end
end

