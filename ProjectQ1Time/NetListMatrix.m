% Most of the code to derive values from netlist and populating the needed
% matrices is from the code for Assignment 1 devoid of Frequeny Logic

function NLMatrix = NetListMatrix(filename)

if isempty(filename) 
filename = 'netlist.txt' ; 
end

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
  SplitNL{k}(L+1:12) = {'0'}; 
end

%%Converting input into a Netlist in the form of Matrix for easy aces of
%%elements
for n = 1:12  % 8 is max no fo columns in netlist
    NLMatrix(:, n) = cellfun(@(x) strtrim(x(n)), SplitNL);
end

%%Numbers are stores as strings in this matrix.The below converts number strings to
%%numeric
a=1;
for i=1:size(NLMatrix,1)
    for j=1:12
        a=a+1;
      array{a}=str2double(NLMatrix(i,j));  
if  isnan(str2double(NLMatrix(i,j)))
    NLMatrix(i,j)=NLMatrix(i,j);
 else
     NLMatrix{i,j}=str2double(NLMatrix(i,j));
 end
    end
end
    
