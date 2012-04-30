classdef Node_H < handle
    %NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(GetAccess='public', SetAccess='private')
        timer1 = 0;
        threshold;  
        NodeID;
        PacketStore = 0; % store 1 packet - debug
        timer1Active = false;
        queueUnVer;
        
        
    end
    
    methods
        
        function obj = Node_H( NodeID, thresh)
        % class constructor
            obj.timer1 = 0;
            obj.threshold = thresh;
            obj.NodeID = NodeID;
            obj.queueUnVer = Queue(10);
            
        end
               
        function set.timer1(obj, value) 
            if (value < 0)
                error('Property value must be positive')
            else
                obj.timer1 = value;
            end
        end
        
        function t1 = get.timer1(obj)
            t1 = obj.timer1;
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
            str = [obj.NodeID, ' Received Packet --', Packet,'--'];
            disp(str);
            %obj.PacketStore = Packet;% store 1 packet - debug
            obj.queueUnVer.enqueue(Packet);
            obj.timer1Active = true;
        end
        
        function obj = sendPacket(obj, Packet)
            str = [obj.NodeID, ' sending packet --', Packet, '--'];
            disp(str);
            %pack = Packet;
        end
        
    end
    
end


