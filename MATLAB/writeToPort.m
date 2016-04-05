function [status] = writeToPort(output_socket,data_to_send)
import java.io.*
import java.net.*
 %MAX SIZE OF DATA TO SEND = 256 BYTES
    data_char = mat2str(data_to_send);
    size_data = num2str(numel(data_char));
    
    if numel(size_data) == 1
        size_data = strcat('00',size_data);
    elseif numel(size_data) == 2
        size_data = strcat('0',size_data); 
    end
    
    try
        output_stream   = output_socket.getOutputStream;
        d_output_stream = DataOutputStream(output_stream);

        % output the data over the DataOutputStream
        % Convert to stream of bytes
        fprintf(1, 'Writing %d bytes\n', size_data);
        d_output_stream.writeBytes(size_data);
        d_output_stream.flush;

        d_output_stream.writeBytes(data_char);
        d_output_stream.flush;
        status = true;
    catch e
        e.message
        status = false;
    end
end

