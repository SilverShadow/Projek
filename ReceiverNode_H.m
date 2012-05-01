classdef ReceiverNode_H < handle
    %ReceiverNode_H Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (GetAccess='public', SetAccess='private')
     generationSize;       %num packets in generation
     packetSize;           %size of the packets in Bytes
     NodeID;
     GF_Field = 8;         % Galois field2^8
     CodeVectorMatrix_gf;
     CodedPacketMatrix_gf;
     counter = 1;          % packet counter
     currentGen = 1;       % generation being collected and decoded
     ACK = false;


    end
    
    methods
        function obj = ReceiverNode_H(NodeID, genSize, packSize)
            obj.NodeID = NodeID;
            obj.generationSize = genSize;
            obj.packetSize = packSize;
            obj.CodeVectorMatrix_gf = gf(zeros(genSize,genSize),obj.GF_Field);
            obj.CodedPacketMatrix_gf = gf(zeros(packSize,genSize),obj.GF_Field);
       
        end
    
        function obj = receivePacket(obj, Packet)
            
            if (Packet.GenID == obj.currentGen)
               
                if (Packet.Type == 0)
                    str = [obj.NodeID, ' Received ACK Packet -----'];
                    disp(str);
                    disp(Packet);
                elseif(Packet.Type == 1)
                    str = [obj.NodeID, ' Received Un/Encoded Packet -----'];
                    disp(str);
                    %disp(Packet); %debug
                    
                    if ( obj.counter < obj.generationSize )
                        
                        %put in decode matrix
                        str = [obj.NodeID, ' Putting into Decoding Matrix'];
                        disp(str); 
                        obj.CodeVectorMatrix_gf(obj.counter, :) = Packet.CodeVector_c;
                        obj.CodedPacketMatrix_gf(:, obj.counter) = Packet.CodedData_e;
                        obj.counter = obj.counter +1;

                    elseif( obj.counter == obj.generationSize )
                        
                        %put in decode matrix
                        str = [obj.NodeID, ' Putting into Decoding Matrix'];
                        disp(str);  
                        obj.CodeVectorMatrix_gf(obj.counter, :) = Packet.CodeVector_c;
                        obj.CodedPacketMatrix_gf(:, obj.counter) = Packet.CodedData_e;

                        str2 = [obj.NodeID,' Ack packet = true']; 
                        disp(str2); 
                        obj.ACK = true;

                        % decode generation
                        obj.decodeGen();

                        obj.currentGen = obj.currentGen + 1;
                    end
                   
                elseif(Packet.Type == 2)
                    str = [obj.NodeID, ' Received Checksum Packet -----'];
                    disp(str);
                    disp(Packet);
                else
                    str = [obj.NodeID, ' Received Unknown Packet Type !!!!!'];
                    disp(str);
                    disp(Packet);
                end
                
            else
                str = [obj.NodeID, ' not current gen packet'];
                disp(str);
            end
        end
    
        function obj = decodeGen(obj)
            str = [obj.NodeID, ' Decoding Generation'];
            disp(str);
            DecodedGMatrix = (obj.CodeVectorMatrix_gf\(obj.CodedPacketMatrix_gf'))';
            fwid2 = fopen('smiley2.jpg', 'a+');
            fwrite(fwid2, DecodedGMatrix.x);
            fclose(fwid2);
            obj.reset();
        end
        
        function obj = reset(obj)
            obj.CodeVectorMatrix_gf = gf(zeros(obj.generationSize,obj.generationSize),obj.GF_Field);
            obj.CodedPacketMatrix_gf = gf(zeros(obj.packetSize,obj.generationSize),obj.GF_Field);
            obj.counter = 1;
        end
        
        function sPacket = sendPacket(obj)
            
            if (obj.ACK)% is true
                str = [obj.NodeID,' Ack packet sent >>>>>']; 
                disp(str); 
                sPacket = struct('Type', 0, 'GenID', (obj.currentGen-1));
                obj.ACK = false;
            else
                sPacket = 'empty';
            end
                
            
        end
    
    end
    
end
    

   