% MATLAB multithreaded server

% TODO LIST:
% 
% 1) make script for initialisations
% 2) create data structures to store latest data from users and clients
%% Import required java packages and setup
import java.io.*
import java.net.*

%start measuring time.
tic
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
%OptimizationSetup
% create required tables
% [name newlocation newdata]
myRios = cell(0);
% [name last location]
users = cell(0);
%% Create Server on socket

port = 60000;
%Open socket
try 
    serverSocket = ServerSocket(port);
catch
    display(strcat('cannot open server on port:',int2str(port)))
end

% run server infinitely
while true
    
    % Compute updated locations every 10 minutes
    difference = toc;
    if difference > 600
        OptimizationSetup;
    end
    try
        %% Open input and output datastreams
        newConnection = serverSocket.accept;
%         display('accepted connection from client, opening new thread...');
%         newThread = ServerThread(newConnection);
%         Thread(st).start;
        display('Client connected');
        [status,clientMessage] = readFromPort(newConnection);
        clientMessage = strsplit(clientMessage);
        % if client is a myRio, then send it updated locations.
        if clientMessage{1} == 'L'      
            myRios = addRowToCell(myRios,clientMessage);
            display('Connected client is a myRio');
            status = writeToPort(newConnection,currentL);
        elseif clientMessage(1) == 'U'
            display('Connected client is a user');
            users = addRowToCell(users,clientMessage);
        end

        % clean up
        serverSocket.close;
        newConnection.close;
%         break;
    catch
        display('Server accept failed');
    end
    
end