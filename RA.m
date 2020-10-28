%%%%%%%%%%%%%%%%%%%%%%%%% New Addition on Top %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
%%%%%%%%%%%%%%% Read Input Graph Data for removal from computed graph.%%%%%
ex1da= importdata('D:\01. Research\01. Missing Link Prediciton Research Paper (Published)\Implementation\V_10\Datasets\USAir.csv'); %Full Dataset
ex11daa = unique(ex1da, 'rows');  

ex1sz = max(ex11daa(:));
exnn=ex1sz;

exnn = sparse(ex11daa(:,1), ex11daa(:,2), 1, ex1sz, ex1sz);

%Seperate input Table rows 
 ex11=ex11daa(:, 1);
 ex22=ex11daa(:, 2);
% Special Graph 'GG3' for 
GG3 = graph(ex11,ex22);   %Graph with 100% edges
Jacc=zeros(size(exnn));   %Initialize empty matrix 
%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%   CN    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iii=1:length(exnn)
    for jjj=iii+1:length(exnn)   
           tempo1=intersect(neighbors(GG3,iii),neighbors(GG3,jjj));
           tempo2=degree(GG3,tempo1);   
           tempo3=sum(tempo2); 
           tempo4=(1/(tempo3));
        if tempo1~=0
            Jacc(iii,jjj)=tempo4;
        end
            tempo1=0;tempo2=0;tempo3=0;tempo4=0;%again reset to zero
    end
end
%%%%%%
for lopp1=1:length(ex11)
    Jacc(ex11(lopp1),ex22(lopp1))=-1;   %Replacing the input graph from CN computed graph
end
fps=Jacc; %False positive score matrix
%%%%%%%%%%%% Convert the matrix to array ignoring input graph %%%%%%%%%%%%%
raise1=1;
for cyc1=1:length(exnn)
    for cyc2=1:length(exnn)
        if fps(cyc1,cyc2)>-1
            Jacs(raise1)=fps(cyc1,cyc2); %Contains FP scored CN's in array.
           raise1=raise1+1;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%% New Addition on Top END %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
da= importdata('D:\01. Research\01. Missing Link Prediciton Research Paper (Published)\Implementation\V_10\Datasets\USAir.csv');                  %%Full Dataset
da = unique(da, 'rows');  

sz = max(da(:));
nn=sz;

nn = sparse(da(:,1), da(:,2), 1, sz, sz);

%%% Importing Probe-Set EP %%%
ex101ex102= importdata('D:\01. Research\04. Physics A Journal Paper\01.Verion-11_June 2019\Testing & Training_Datasets 80%\USAir\USAirEP1.csv'); % import EP
%Seperate input Table rows 
 ex101=ex101ex102(:, 1);
 ex102=ex101ex102(:, 2);
 
 %%% Importing Training-Set ET %%%
ex1ex2= importdata('D:\01. Research\04. Physics A Journal Paper\01.Verion-11_June 2019\Testing & Training_Datasets 80%\USAir\USAirET1.csv'); % import ET
%Seperate input Table rows 
 ex1=ex1ex2(:, 1);
 ex2=ex1ex2(:, 2);
 
 % Special Graph 'GG2' for 
GG2 = graph(ex1,ex2);   %Graph with 90% edges
Jacc=zeros(size(nn));   %Initialize empty matrix for jaccord coefficient.
%%%%%%%%%%%%%%%%%%%%%%%   CN    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iii=1:length(nn)
    for jjj=iii+1:length(nn)   
        Jacc(iii,jjj)=numel(intersect(neighbors(GG2,iii),neighbors(GG2,jjj)));
    end
end
Jacc2=Jacc;
 %%%%% Removing edges between 80%/90% that are already present: TO SIMPLYFY
 for re=1:length(ex1)
    % thc(re)=Jacc(ex2(re),ex1(re));
     Jacc2(ex2(re),ex1(re))=0;
 end
   %%%%%%%% Missing 20%/10% values in Matrix %%% TP
 inc1=1;
  for rer=1:length(ex101)
     %mis(rer)=Jacc(ex102(rer),ex101(rer));
     Jacc3(rer)=Jacc2(ex102(rer),ex101(rer));  %%% TP
 end

%%%%% New part
%%%%%%%%%%%%%%%%%%% AUC %%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = min(length(Jacc3),length(Jacs));

   n1=0;n2=0;
   p1=randperm(n);
  for cur=1:n
     if ((Jacc3(p1(cur)))>(Jacs(p1(cur))))
     %if ((Jacc3(randperm(length(Jacc3))))>(Jacs(randperm(length(Jacs)))))
         n1=n1+1;
     end
     if((Jacc3(p1(cur)))==(Jacs(p1(cur))))
     %if((Jacc3((cur)))==(Jacs((cur))))
         n2=n2+1;
    end
  end
AUC=((n1)+((0.5)*n2))/(n);
AUC=round(AUC,3)