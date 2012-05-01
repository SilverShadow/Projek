classdef Node_H < handle
    %NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(GetAccess='public', SetAccess='private')
        
        threshold;  
        NodeID;
        PacketStore  = 0;             % store 1 packet - debug
        timer1Active = false;
        queueUnVer;
        HavePacket = false;
        timer1 = 0;
        NodeState; % 0 for FWD  1 for ENCODE
        
    end
    
    methods
        
        function obj = Node_H( NodeID, thresh)
        % class constructor
            obj.timer1 = 0;
            obj.threshold = thresh;
            obj.NodeID = NodeID;
            obj.queueUnVer = Queue(10);
            obj.NodeState = 0; % FWD
            
        end
               
               
        function obj = tick(obj)
            
            if (obj.timer1Active)
                
                obj.timer1 = obj.timer1 + 1;
                
                if (obj.timer1 >= obj.threshold)
                    obj.timer1 = 0;
                    str =[obj.NodeID,' Threshold reached', ' getting packet --']; % ,obj.PacketStore]; debug
                    disp(str);
                    
                    for i = 1:obj.queueUnVer.counter
                        pakkieNode = obj.queueUnVer.dequeue();
                        obj.sendPacket(pakkieNode.data);
                    end
                    obj.HavePacket = true;
                    %obj.sendPacket(obj.PacketStore); debug 
                    %obj.PacketStore = 0; % clear packetstore debug
                    obj.timer1Active = false;
                else
                    str = [obj.NodeID, ' waiting ', '.'];
                    disp(str);
                end
                
            else
                obj.timer1 = 0;
            end
            
        end
        
        function obj = receivePacket(obj, Packet)
                        
            if (Packet.Type == 0)
                str = [obj.NodeID, ' Received ACK Packet -----'];
                disp(str);
                disp(Packet);
            elseif (Packet.Type == 1)
                str = [obj.NodeID, ' Received an Un/Encoded Packet -----'];
                disp(str);
                %disp(Packet);    
            elseif(Packet.Type == 2)
                str = [obj.NodeID, ' Received Checksum Packet -----'];
                disp(str);
                %disp(Packet); %debug
            else
                str = [obj.NodeID, ' Received Unknown Packet Type !!!!!'];
                disp(str);
                disp(Packet);
            end

            obj.queueUnVer.enqueue(Packet);
            obj.HavePacket = true;
            
            %obj.PacketStore = Packet;% store 1 packet - debug
            %obj.timer1Active = true;
            
        end
        
        function sPacket = sendPacket(obj)
            pakkieNode = obj.queueUnVer.dequeue();
            sPacket = pakkieNode.data;
            str = [obj.NodeID, ' sending packet >>>>>'];
            disp(str);
            obj.HavePacket = false;
        end
        
    end
    
end


