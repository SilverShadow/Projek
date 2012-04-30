classdef SourceNode_H < handle
    %SourceNode_H Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(GetAccess='public', SetAccess='private')
        generationSize; %num packets in generation
        packetSize;     %size of the packets in Bytes
        NodeID;
        OUT = 0;
        counter1 = 0; 
        counter2 = 1;
        seedCodeV = 3;  %seed for the coding vector
        
        GF_Field = 8;   % Galois field2^8
        b = 2;
        genCounter = 1;
        numGenerations;
        chunk;
        GenerationMatrix_gf;
        s;
        
        
    end
    
    methods
        function obj = SourceNode_H(NodeID, genSize, packSize)
            obj.NodeID = NodeID;
            obj.generationSize = genSize;
            obj.packetSize = packSize;
        end
        
        function obj = sendFile(obj, fileName)
            
            obj.s = RandStream('mt19937ar','Seed',3);
            
            % open file and read data into matrix
            fid = fopen(fileName);
            imageData = fread(fid,'uint8');
            fclose(fid);
            
            obj.numGenerations = ceil(length(imageData)/(obj.packetSize*obj.generationSize));
            obj.chunk = zeros(obj.packetSize, obj.generationSize, obj.numGenerations);
            
            for chunkCounter = 1: obj.numGenerations
                %put data into a chunk
                for i= 1:obj.generationSize
                    for j= 1:obj.packetSize
                        if (obj.counter2 < length(imageData));
                            obj.chunk(j,i,chunkCounter)= imageData((j + obj.counter1),1);
                        else
                            obj.chunk(j,i,chunkCounter)= 0;
                        end
                        obj.counter2 = obj.counter2 + 1;
                    end
                     obj.counter1 = obj.counter1 + obj.packetSize; 
                end
            end
            
            %create generation matrix and put in field GF8
            GenerationMatrix = obj.chunk;
            obj.GenerationMatrix_gf = gf(GenerationMatrix,obj.GF_Field); % makes galois field of generation matrix 
                
        end
        
        function codedPacket = sendPacket(obj)
            
            codeVector = createCodeVector(obj.s, obj.generationSize, obj.GF_Field);
            codeVector_gf = gf(codeVector,obj.GF_Field);
            
            % Coded Data vector e = c(1)*p(1) + c(2)*p(2)....
            codedData = zeros(obj.packetSize,1);
            codedData_gf = gf(codedData, obj.GF_Field);
            
            % multiply coded vector with each packet and add them together
            for i = 1:obj.generationSize
                codedData_gf(:,1) = codedData_gf(:,1) + codeVector_gf(1,i)* obj.GenerationMatrix_gf(:,i,obj.genCounter);
            end
            codedPacket = struct('Type', 1, 'GenID', obj.genCounter, 'CodeVector_c', codeVector_gf, 'CodedData_e', codedData_gf );
            str =[obj.NodeID, ' Encoded a packet']; 
            disp(str);
            
        end
        
        function obj = receivePacket(obj, Packet)
            
            if (Packet.Type == 0)
                str = [obj.NodeID, ' Received ACK Packet --'];
                disp(str);
                disp(Packet);
                
                if (obj.genCounter >= obj.numGenerations)
                    str = [obj.NodeID, ' no more generations'];
                    disp(str);
                else
                    obj.genCounter = obj.genCounter +1 ;
                end
                
            elseif (Packet.Type == 1)
                str = [obj.NodeID, ' Received an Un/Encoded Packet --'];
                disp(str);
                disp(Packet); 
                
            elseif (Packet.Type == 2)
                str = [obj.NodeID, ' Received Checksum Packet --'];
                disp(str);
                disp(Packet);
            
            else
                str = [obj.NodeID, ' Unknown Packet Type'];
                disp(str);
                disp(Packet);
            
            end
                
            
        end
        
    end
    
end

