import java.net.ServerSocket
import java.io.*
import java.net.Socket
input_port = 2058;
output_port = 2057;

%% Initialising
CAP=8;
% MUST COME FROM LABVIEW 
numberOfBlimps=3;
GPSMap=[[0;2] [1;2] [2;2] [0;1] [1;1] [2;1] [0;0] [1;0] [2;0]]; %Use this to assign each sector a Lat/Long Location. (1xn format)
penaltyGain=1; %Increase this to make moving less likely
host='localhost';   
initializing=1;
input_socket = [];
message_in = [];
sectorDemand=ones(3);
%% keep looping until you get some data
while(true)
   
            OptimizationSetup;
            initializing = 0;
            % Send optimized blimp positions to blimps
            writeToPort(output_port,currentL);
end