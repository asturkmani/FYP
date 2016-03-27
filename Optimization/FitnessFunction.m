function [fitness] = FitnessFunction(blimpsLocations)
%%
%Complete variable description:

%sectorDemand: An estimate of bandwidth not being serviced in each sector.
%              This is an array of size 1 x (number of sectors)
%              This is an INPUT to our system. A measured quantity.

%blimpsLocations: The locations of each blimp in the fleet.
%                 This is an array of size 1 x (number of blimps).
%                 This is an INPUT to our system. A measured quantity.

%blimpCapacity: Max amount of bandwidth a blimp can provide at any given 
%               time. All blimps start the process with capacities of
%               CAP.

%sectorCovered: An array indicating if all sectors are serviced.
%               This is an array of size 1 x (number of sectors)

%%
%Hard code some of the variables that are pre-determined constants
%Also, open the file 'demand.mat' in order to extract sectorDemand data
%that has been saved. 
openTemp=open('passedFile.mat');
sectorDemand=openTemp.demandTemp;
rowLength=openTemp.dimensions(1);
columnLength=openTemp.dimensions(2);
CAP=openTemp.CAP;
currentLocation=openTemp.currentL;
map=openTemp.GPSMap;
penaltyGain=openTemp.penaltyGain;



%%

%The number of blimps (b) afloat is the number of iterations of all
%computations.

b = length(blimpsLocations);

%The number of sectors (s) is the size of the sectorDemand array.

s = rowLength*columnLength;

%%
%First check if the suggest configuration allows for total coverage of 
%the sectors. If not, do not waste time computing. Fitness = 0.

sectorCovered = zeros(1,s);
blimpsCapacity = CAP*ones(1,b);

for i = 1:b
 
    %What sector is the i'th blimp in
    sector = blimpsLocations(i);
    
    %Mark all adjacent sectors to blimp as covered
    
    if sector == 1
           
        sectorCovered(sector)=1;
        sectorCovered(sector+1)=1;
        sectorCovered(sector+rowLength)=1;
    
    elseif sector == rowLength
           
        sectorCovered(sector)=1;
        sectorCovered(sector+rowLength)=1;
        sectorCovered(sector-1)=1;
       
    elseif sector == s
           
        sectorCovered(sector)=1;
        sectorCovered(sector-1)=1;
        sectorCovered(sector-rowLength)=1; 
       
    elseif sector == [(rowLength*(columnLength - 1)) + 1]
           
        sectorCovered(sector)=1;
        sectorCovered(sector+1)=1;
        sectorCovered(sector-rowLength)=1;           
        
    elseif sector > 1 && sector < rowLength
        
        sectorCovered(sector)=1;
        sectorCovered(sector+1)=1;
        sectorCovered(sector+rowLength)=1; 
        sectorCovered(sector-1)=1; 
        
    elseif sector > [(rowLength*(columnLength - 1))] + 1 && sector < s
        
        sectorCovered(sector)=1;
        sectorCovered(sector+1)=1;
        sectorCovered(sector-1)=1;
        sectorCovered(sector-rowLength)=1;      
        
    elseif rem(sector,columnLength) == 0;

        sectorCovered(sector)=1;
        sectorCovered(sector-rowLength)=1; 
        sectorCovered(sector-1)=1;
        sectorCovered(sector+rowLength)=1; 
        
    elseif rem(sector-1,columnLength) == 0
        
        sectorCovered(sector)=1;
        sectorCovered(sector+1)=1;
        sectorCovered(sector+rowLength)=1; 
        sectorCovered(sector-rowLength)=1;
        
    else

        sectorCovered(sector)=1;
        sectorCovered(sector+1)=1;
        sectorCovered(sector+rowLength)=1; 
        sectorCovered(sector-1)=1;
        sectorCovered(sector-rowLength)=1;
        
        
    end
    
    i = i + 1;
    
end
    
%If there are any uncovered sectors, this configuration receives a fitness
%of very low.

for i = 1:s
   
    if sectorCovered(i) == 0
        
        fitness = 0;
        return
        
    end
        
    i = i + 1;
    
end
    
%%

%If all sectors covered, compute demands and capacities of all sectots 
%and blimps.
%A blimp can provide service UP TO its capacity. As a blimp provides
%service, the sectorDemand must be reduced so that two blimps don't attempt
%to service the same sector needlessly.
%We adopt the convention that a blimp services first its sector, and then
%services additional sectors in a clockwise order until it no longer can.

for i = 1:b
 
    %What sector is the i'th blimp in
        
    sector = blimpsLocations(i);
    
    %Update sectorDemand based on blimp location. Also update how much
    %capacity each blimp has left.
    
    if sector == 1
        
        if sectorDemand(sector)>blimpsCapacity(i)
            
            sectorDemand(sector)=sectorDemand(sector)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector);
            sectorDemand(sector)=0;
            
        end
        
        if sectorDemand(sector+1)>blimpsCapacity(i)
            
            sectorDemand(sector+1)=sectorDemand(sector+1)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector+1);
            sectorDemand(sector+1)=0;
            
        end 
        
        if sectorDemand(sector+columnLength)>blimpsCapacity(i)
            
            sectorDemand(sector+columnLength)=sectorDemand(sector+columnLength)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector+columnLength);
            sectorDemand(sector+columnLength)=0;
            
        end        
    
    elseif sector == rowLength
           
        if sectorDemand(sector)>blimpsCapacity(i)
            
            sectorDemand(sector)=sectorDemand(sector)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector);
            sectorDemand(sector)=0;
            
        end
        
        if sectorDemand(sector+columnLength)>blimpsCapacity(i)
            
            sectorDemand(sector+columnLength)=sectorDemand(sector+columnLength)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector+columnLength);
            sectorDemand(sector+columnLength)=0;
            
        end 
        
        if sectorDemand(sector-1)>blimpsCapacity(i)
            
            sectorDemand(sector-1)=sectorDemand(sector-1)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector-1);
            sectorDemand(sector-1)=0;
            
        end  
       
    elseif sector == s
           
        if sectorDemand(sector)>blimpsCapacity(i)
            
            sectorDemand(sector)=sectorDemand(sector)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector);
            sectorDemand(sector)=0;
            
        end
        
        if sectorDemand(sector-1)>blimpsCapacity(i)
            
            sectorDemand(sector-1)=sectorDemand(sector-1)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector-1);
            sectorDemand(sector-1)=0;
            
        end
        
        if sectorDemand(sector-columnLength)>blimpsCapacity(i)
            
            sectorDemand(sector-columnLength)=sectorDemand(sector-columnLength)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector-columnLength);
            sectorDemand(sector-columnLength)=0;
            
        end 
       
    elseif sector == [(rowLength*(columnLength - 1)) + 1]
           
        if sectorDemand(sector)>blimpsCapacity(i)
            
            sectorDemand(sector)=sectorDemand(sector)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector);
            sectorDemand(sector)=0;
            
        end
        
        if sectorDemand(sector+1)>blimpsCapacity(i)
            
            sectorDemand(sector+1)=sectorDemand(sector+1)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector+1);
            sectorDemand(sector+1)=0;
            
        end
        
        if sectorDemand(sector-columnLength)>blimpsCapacity(i)
            
            sectorDemand(sector-columnLength)=sectorDemand(sector-columnLength)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector-columnLength);
            sectorDemand(sector-columnLength)=0;
            
        end 
        
    elseif sector > 1 && sector < rowLength
        
        if sectorDemand(sector)>blimpsCapacity(i)
            
            sectorDemand(sector)=sectorDemand(sector)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector);
            sectorDemand(sector)=0;
            
        end
        
        if sectorDemand(sector+1)>blimpsCapacity(i)
            
            sectorDemand(sector+1)=sectorDemand(sector+1)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector+1);
            sectorDemand(sector+1)=0;
            
        end
        
        if sectorDemand(sector+columnLength)>blimpsCapacity(i)
            
            sectorDemand(sector+columnLength)=sectorDemand(sector+columnLength)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector+columnLength);
            sectorDemand(sector+columnLength)=0;
            
        end 
        
        if sectorDemand(sector-1)>blimpsCapacity(i)
            
            sectorDemand(sector-1)=sectorDemand(sector-1)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector-1);
            sectorDemand(sector-1)=0;
            
        end        
        
    elseif sector > [(rowLength*(columnLength - 1))] + 1 && sector < s
        
        if sectorDemand(sector)>blimpsCapacity(i)
            
            sectorDemand(sector)=sectorDemand(sector)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector);
            sectorDemand(sector)=0;
            
        end
        
        if sectorDemand(sector+1)>blimpsCapacity(i)
            
            sectorDemand(sector+1)=sectorDemand(sector+1)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector+1);
            sectorDemand(sector+1)=0;
            
        end
        
        if sectorDemand(sector-1)>blimpsCapacity(i)
            
            sectorDemand(sector-1)=sectorDemand(sector-1)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector-1);
            sectorDemand(sector-1)=0;
            
        end        
        
        if sectorDemand(sector-columnLength)>blimpsCapacity(i)
            
            sectorDemand(sector-columnLength)=sectorDemand(sector-columnLength)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector-columnLength);
            sectorDemand(sector-columnLength)=0;
            
        end     
        
    elseif rem(sector,columnLength) == 0;

        if sectorDemand(sector)>blimpsCapacity(i)
            
            sectorDemand(sector)=sectorDemand(sector)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector);
            sectorDemand(sector)=0;
            
        end
        
        if sectorDemand(sector+columnLength)>blimpsCapacity(i)
            
            sectorDemand(sector+columnLength)=sectorDemand(sector+columnLength)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector+columnLength);
            sectorDemand(sector+columnLength)=0;
            
        end        
        
        if sectorDemand(sector-1)>blimpsCapacity(i)
            
            sectorDemand(sector-1)=sectorDemand(sector-1)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector-1);
            sectorDemand(sector-1)=0;
            
        end        
        
        if sectorDemand(sector-columnLength)>blimpsCapacity(i)
            
            sectorDemand(sector-columnLength)=sectorDemand(sector-columnLength)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector-columnLength);
            sectorDemand(sector-columnLength)=0;
            
        end         

        
    elseif rem(sector-1,columnLength) == 0
        
        if sectorDemand(sector)>blimpsCapacity(i)
            
            sectorDemand(sector)=sectorDemand(sector)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector);
            sectorDemand(sector)=0;
            
        end
        
        if sectorDemand(sector+1)>blimpsCapacity(i)
            
            sectorDemand(sector+1)=sectorDemand(sector+1)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector+1);
            sectorDemand(sector+1)=0;
            
        end        
        
        if sectorDemand(sector+columnLength)>blimpsCapacity(i)
            
            sectorDemand(sector+columnLength)=sectorDemand(sector+columnLength)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector+columnLength);
            sectorDemand(sector+columnLength)=0;
            
        end                
        
        if sectorDemand(sector-columnLength)>blimpsCapacity(i)
            
            sectorDemand(sector-columnLength)=sectorDemand(sector-columnLength)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector-columnLength);
            sectorDemand(sector-columnLength)=0;
            
        end 
        
    else

        if sectorDemand(sector)>blimpsCapacity(i)
            
            sectorDemand(sector)=sectorDemand(sector)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector);
            sectorDemand(sector)=0;
            
        end
        
        if sectorDemand(sector+1)>blimpsCapacity(i)
            
            sectorDemand(sector+1)=sectorDemand(sector+1)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector+1);
            sectorDemand(sector+1)=0;
            
        end
        
        if sectorDemand(sector+columnLength)>blimpsCapacity(i)
            
            sectorDemand(sector+columnLength)=sectorDemand(sector+columnLength)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector+columnLength);
            sectorDemand(sector+columnLength)=0;
            
        end 
        
        if sectorDemand(sector-1)>blimpsCapacity(i)
            
            sectorDemand(sector-1)=sectorDemand(sector-1)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector-1);
            sectorDemand(sector-1)=0;
            
        end

        if sectorDemand(sector-columnLength)>blimpsCapacity(i)
            
            sectorDemand(sector-columnLength)=sectorDemand(sector-columnLength)-blimpsCapacity(i);
            blimpsCapacity(i)=0;
            continue; %No more can be done by this blimp
            
        else
            
            blimpsCapacity(i)=blimpsCapacity(i)-sectorDemand(sector-columnLength);
            sectorDemand(sector-columnLength)=0;
            
        end
       
    end
    
    i = i + 1;
    
end




%%
    
%Now compute the fitness of the configuration.
%This is how much bandwidth is being provided by the blimp network.
fitness=-1*((b*CAP)-sum(blimpsCapacity));

%The more the configuration must change, the less fit the solution is.
movementPenalty=0;

if isempty(currentLocation) == false

    for i=1:b
        
        %compute the total distances moved
        movementPenalty=movementPenalty+computeDistance(blimpsLocations(i),currentLocation(i), map);
        i=i+1;
    
    end
   
elseif isempty(currentLocation) == true
   
    %do nothing
    
end

fitness = fitness+(penaltyGain*movementPenalty);

end
