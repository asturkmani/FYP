
import java.net.ServerSocket
import java.io.*
import java.net.Socket
input_port = 2058;
output_port = 2057;

%keep looping until you get some data
while(true)
    try

        % throws if unable to connect
        input_socket = Socket(host,input_port);

        % get a buffered data input stream from the socket
        input_stream   = input_socket.getInputStream;
        d_input_stream = DataInputStream(input_stream);

        %fprintf(1, 'Connected to server\n');

        % read data from the socket - wait a short time first
        pause(0.1);
        bytes_available = input_stream.available;
       %fprintf(1, 'Reading %d bytes\n', bytes_available);

        message_in = zeros(1, bytes_available, 'uint8');
        for i = 1:bytes_available
            message_in(i) = d_input_stream.readByte;
        end

        message_in = char(message_in);

        % cleanup

        OptimizationSetup;
        writeToPort(output_port,currentL);
        input_socket.close;
    catch
        if ~isempty(input_socket)
            input_socket.close;
            fprintf(1, 'NO CONNECTION\n');
        end
    end
end

