% MATLAB multithreaded server

%% Import required java packages and setup
import java.net.*
import java.io.*

%start measuring time.
tic

% create required tables
rios = [];
users = [];
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
    
    % Compute update locations every 10 minutes
    difference = toc;
    if difference > 600
        OptimizationSetup;
    end
    try
        %% Open input and output datastreams
        newConnection = serverSocket.accept;
        display('accepted connection from client, opening new thread...');
        newThread = ServerThread(newConnection);
        Thread(st).start;
        display('Client connected');
        
        % Create input buffer
        inFromClient = newThread.getInputStream;
        inFromClient = InputStreamReader(inFromClient);
        inFromClient = BufferedReader(inFromClient);

        %% Read data from client and processit
        clientMessage = inFromClient.readline;
        
        % if client is a myRio, then send it updated locations.
        if clientMessage(1) == 'L'
                    
            display('Connected client is a myRio');
            % Create output buffer
            outToClient = newThread.getOutputStream;
            outToClient = DataOutputStream(outToClient);
            
            % Send updated locations
            display(strcat('Writing', int2str(length(message)),'bytes'));   
            outToClient.writeBytes(char(message));
            outToClient.flush;   
        elseif clientMessage(1) == 'U'
            display('Connected client is a user');
            
        end

        % clean up
        server_socket.close;
        output_socket.close;
    catch
        display('Server accept failed');
    end
    
end