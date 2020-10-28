%%%%%%%%%%%%%%%%%%%%%%%%% New Addition on Top %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
 
%%%%%%%%%%%%%%% Read Input Graph Data for removal from computed graph.%%%%%
Data1= importdata('D:\01. Research\04. Physics A Journal Paper\01.Verion-11_June 2019\Datasets\emails.csv'); %Full Dataset
Data1Uniq = unique(Data1, 'rows');  

Data1Max = max(Data1Uniq(:));
%exnn=Data1Max;

Data1Length = sparse(Data1Uniq(:,1), Data1Uniq(:,2), 1, Data1Max, Data1Max);

%Seperate input Table rows 
 Data1C1=Data1Uniq(:, 1);
 Data1C2=Data1Uniq(:, 2);
% Special Graph 'GG3' for 
GData1 = graph(Data1C1,Data1C2);   %Graph with 100% edges
CNs=zeros(size(Data1Length));   %Initialize empty matrix 
%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%   CN-1   %%%%%%%%%%%%%%%%%%%%%%%%%%%%
tnodes=numnodes(GData1);
for iii=1:length(Data1Length)
    for jjj=iii+1:length(Data1Length)   
      
        tempo1= ((numel(intersect(neighbors(GData1,iii),neighbors(GData1,jjj)))+1)/2);
        if ((numel(intersect(neighbors(GData1,iii),neighbors(GData1,jjj)))))<=0
           tempo1=1/distances(GData1,iii,jjj); 
        end     
        CNs(iii,jjj)=tempo1; 
        tempo1=0;%again reset to zero
  
    end
end

%%%%%%
for dl1=1:length(Data1C1)
    CNs(Data1C1(dl1),Data1C2(dl1))=-1;   %FP %Replacing the input graph from CN computed graph
end
%%%%%%%%%%%% Convert the matrix to array ignoring input graph %%%%%%%%%%%%%
var1=1;
for cyc1=1:length(Data1Length)
    for cyc2=cyc1+1:length(Data1Length)
        if CNs(cyc1,cyc2)>-1
             fp(var1)=CNs(cyc1,cyc2); %Contains FP scored CN's in array.
           var1=var1+1;
        end
    end
end
fp=sort(fp,'descend'); % FP 
r1=randperm(length(fp),15);
fp=fp(r1);
%fp=fp(1:10);
%%%%%%%%%%%%%%%%%%%%%%%%% New Addition on Top END %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Data2= importdata('D:\01. Research\04. Physics A Journal Paper\01.Verion-11_June 2019\Datasets\emails.csv');                  %%Full Dataset
Data2Uniq = unique(Data2, 'rows');  

Data2Max = max(Data2Uniq(:));
Data2Uni=Data2Max;

Data2Uni = sparse(Data2Uniq(:,1), Data2Uniq(:,2), 1, Data2Max, Data2Max);

%%% Importing Probe-Set EP %%%
Data2Probe= importdata('D:\01. Research\04. Physics A Journal Paper\01.Verion-11_June 2019\Testing & Training_Datasets 80%\emails\emailsEP14.csv'); % import EP
%Seperate input Table rows 
 D2ProbeMC1=Data2Probe(:, 1);
 D2ProbeMiC2=Data2Probe(:, 2);
 
 %%% Importing Training-Set ET %%%
Data2Train= importdata('D:\01. Research\04. Physics A Journal Paper\01.Verion-11_June 2019\Testing & Training_Datasets 80%\emails\emailsET14.csv'); % import ET
%Seperate input Table rows 
 D2TrainMC1=Data2Train(:, 1);
 D2TrainMiC2=Data2Train(:, 2);
 
 % Special Graph 'GG2' for 
GData2 = graph(D2TrainMC1,D2TrainMiC2);   %Graph with 90% edges
CNData2=zeros(size(Data2Uni));   %Initialize empty matrix for jaccord coefficient.
%%%%%%%%%%%%%%%%%%%%%%%   CN-2    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iii=1:length(Data2Uni)
    for jjj=iii+1:length(Data2Uni)   
       tempo1= ((numel(intersect(neighbors(GData2,iii),neighbors(GData2,jjj)))+1)/2);
        if ((numel(intersect(neighbors(GData2,iii),neighbors(GData2,jjj)))))<=0
           tempo1=1/distances(GData2,iii,jjj); 
        end     
        CNData2(iii,jjj)=tempo1; 
        tempo1=0;%again reset to zero
    end
end

   %%%%%%%% Missing 20%/10% values in Matrix %%% TP
 inc1=1;
  for rer=1:length(D2ProbeMC1)
     tp(rer)=CNData2(D2ProbeMiC2(rer),D2ProbeMC1(rer));  %%% TP
 end
%%%
tp=sort(tp,'descend'); % FP 
r2=randperm(length(tp),15);
tp=tp(r2);
%%%
%tp=sort(tp,'descend'); %%TP
%tp=tp(1:10);
%%%%%%%%%%%%%%%%%%% AUC %%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 0;
   n1=0;n2=0;
   for i=1:length(tp)
      for j=1:length(fp)
          n = n +1;
          %fprintf("%i \t %i \n", Jacc3(i), Jacs(j));
          if tp(i)>fp(j)
              n1=n1+1;
          end
          
          if tp(i)==fp(j)
               n2=n2+1;
          end
      end
   end

AUC=((n1)+((0.5)*n2))/(n)   