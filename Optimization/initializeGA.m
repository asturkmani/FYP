function [ Locations ] = initializeGA( sectorDemand,CAP,numberOfBlimps, GPSMap, initializing, penaltyGain )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if initializing == 1
    initializing = true;
else
    initializing = false;
    
dimensions = size(sectorDemand);
rowLength = dimensions(1);
columnLength=dimensions(2);

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
end

