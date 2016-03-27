%A script to set up the fitness function testing environment.


%%

%Set up any test we desire. We can control The field dimensions, the 
%providing capacity of each UAV, and the demand in each sector.

%The estimated amount of demand in each sector. 
sectorDemand=[3 10 2; 4 0 1; 0 0 2];
rowLength=3;
columnLength=3;
dimensions =[rowLength columnLength];
CAP=8;
numberOfBlimps=3;
GPSMap=[[0;2] [1;2] [2;2] [0;1] [1;1] [2;1] [0;0] [1;0] [2;0]]; %Use this to assign each sector a Lat/Long Location. (1xn format)
initializing=false; %is this the fist time we call the optimizer or not
penaltyGain=1; %Increase this to make moving less likely


%%

%Reshape the demand array to work with the fitness function
demandTemp=[];
for i=1:rowLength
demandTemp=[demandTemp sectorDemand(i,:)];
end


%Set generate the parameters to be sent to the GA
fitnessfcn=@FitnessFunction;
min=ones(1,numberOfBlimps);
max=length(demandTemp)*ones(1,numberOfBlimps);
integerConstraint=[1:numberOfBlimps];

if initializing == true
    
    currentL=[];
    
else
    
    currentLocation=open('locInfo.mat');
    currentLocation=currentLocation.currentL;
end
    
%Save the data of sectorDemand to work space to be able to open it up
%in the fitness function
save('passedFile.mat','demandTemp','dimensions','CAP','currentL','GPSMap','penaltyGain');

[Locations, fitnessOfSolution]=ga(fitnessfcn,numberOfBlimps,[],[],[],[],min,max,[],integerConstraint)

currentL=Locations;
save('locInfo.mat','currentL');

% %%
% %Plot an xyz plane with the original demand estimate in each sector.
% 
X=[1:rowLength];
Y=[1:columnLength];

% 
% 
% %%
% %Overlay the blimps in their proper positions on this surface plot

lookupTable=[1 1; 1 2; 1 3; 2 1; 2 2; 2 3; 3 1; 3 2; 3 3];
surf(X,Y,sectorDemand);
xlabel('x-position');
ylabel('y-position');
zlabel('Total Demand');
% 

hold on;
scatter3(lookupTable(Locations(1),2),lookupTable(Locations(1),1),10,'filled');
scatter3(lookupTable(Locations(2),2),lookupTable(Locations(2),1),10,'filled');
scatter3(lookupTable(Locations(3),2),lookupTable(Locations(3),1),10,'filled');


hold off;

