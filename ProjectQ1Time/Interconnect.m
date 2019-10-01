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

[NLMatrix] = InterconnectAnalyser(NLMatrix,MaxFrquency);

% 
%  [G_Matrix C_Matrix B_Matrix B_MatrixAC X_Matrix maxPassiveNode] = GCXBgenerator(NLMatrix);
% r 
% 
% filename = 'testQ1.mat';
% save(filename);



