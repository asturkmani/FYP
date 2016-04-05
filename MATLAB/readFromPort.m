function [status,data] = readFromPort(input_socket)
import java.io.*
import java.net.*
data = '';
    try
        % get a buffered data input stream from the socket
        input_stream   = input_socket.getInputStream;
        d_input_stream = DataInputStream(input_stream);

        %fprintf(1, 'Connected to server\n');

        % read data from the socket - wait a short time first
        pause(0.1);
        bytes_available = input_stream.available;
       %fprintf(1, 'Reading %d bytes\n', bytes_available);

        data = zeros(1, bytes_available, 'uint8');
        for i = 1:bytes_available
            data(i) = d_input_stream.readByte;
        end

        data = char(data);
        status = true;
    catch e
        e.message
        status = false;
    end
end

