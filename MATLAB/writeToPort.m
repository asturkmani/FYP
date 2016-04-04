function [status] = writeToPort(output_port,data_to_send)

    import java.net.ServerSocket
    import java.io.*
    import java.net.Socket
    
    %MAX SIZE OF DATA TO SEND = 256 BYTES
    data_char = mat2str(data_to_send);
    size_data = num2str(numel(data_char));
    
    if numel(size_data) == 1
        size_data = strcat('00',size_data);
    elseif numel(size_data) == 2
        size_data = strcat('0',size_data); 
    end
    % wait for samplingrate for client to connect server socket
        server_socket = ServerSocket(output_port);
%             server_socket.setSoTimeout(samplingrate*1);

        output_socket = server_socket.accept;

        fprintf(1, 'Client connected\n');

        output_stream   = output_socket.getOutputStream;
        d_output_stream = DataOutputStream(output_stream);

        % output the data over the DataOutputStream
        % Convert to stream of bytes
        fprintf(1, 'Writing %d bytes\n', length(message));
        d_output_stream.writeBytes(size_data);
        d_output_stream.flush;

        d_output_stream.writeBytes(data_char);
        d_output_stream.flush;
        
        % clean up
        server_socket.close;
        output_socket.close;
        
        status = true;
end

