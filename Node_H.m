classdef Node_H < handle
    %NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(GetAccess='public', SetAccess='private')
        NodeID;
        threshold; 
        PacketStore  = 0;             % store 1 packet - debug
        timer1Active = false;
        queueUnVer;
        OUTQueue;
        ACKQueue;
        HavePacket = false;
        timer1 = 0;
        ACK = false;
        
        tickCounter = 0;
        packetRCounter = 0;
        packetSCounter = 0;
        droppedPacketCounter = 0;
        ACKPacketSCounter = 0;
        ACKPacketRCounter = 0;
        % delayT = false;
        
    end
    
    methods
        
        function obj = Node_H( NodeID, thresh)
        % class constructor
            obj.timer1 = 0;
            obj.threshold = thresh;
            obj.NodeID = NodeID;
            obj.queueUnVer = Queue(10);
            obj.OUTQueue = Queue(10);
            obj.ACKQueue = Queue(3);
            
        end
               
               
        function obj = tick(obj)
            
            if (obj.timer1Active)
                
                obj.timer1 = obj.timer1 + 1;
              %  obj.delayT = true;
                
                if (obj.timer1 >= obj.threshold || obj.queueUnVer.isFull()==true)
                    obj.timer1 = 0;
                    str =[obj.NodeID,' Threshold reached', ' getting packet --']; % ,obj.PacketStore]; debug
                    disp(str);
                    if(obj.queueUnVer.isFull())
                        disp('Queue was full');
                    end
                    %for i = 1:obj.queueUnVer.counter
                        pakkieNode = obj.queueUnVer.dequeue();
                        %encoding operation
                        obj.OUTQueue.enqueue(pakkieNode.data);
                    %end
                    obj.HavePacket = true;
                    %obj.sendPacket(obj.PacketStore); debug 
                    %obj.PacketStore = 0; % clear packetstore debug
                    obj.timer1Active = false;
                else
                    str = [obj.NodeID, ' waiting ', '.'];
                    disp(str);
                end
                obj.HavePacket = true;
                
            else
                obj.timer1 = 0;
            end
            
        end
        
        function obj = receivePacket(obj, Packet)
                        
            if (Packet.Type ==99)
            
            else
                if (Packet.Type == 0)
                    str = [obj.NodeID, ' Received ACK Packet -----'];
                    disp(str);
                    disp(Packet);
                    obj.ACK = true;
                    obj.ACKQueue.enqueue(Packet);
                    obj.ACKPacketRCounter = obj.ACKPacketRCounter +1;
                    
                else
                    if (Packet.Type == 1)
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

                    if (obj.queueUnVer.isFull() == false) 
                        % if queue is not full enqueue
                        obj.queueUnVer.enqueue(Packet);
                        obj.packetRCounter = obj.packetRCounter + 1;
                    else
                        % is queue id full drop packet
                        str =[obj.NodeID , 'Queue was full and packet was dropped ddddddddddddddddddddddddddddddddddddddd'];
                        disp(str);
                        obj.droppedPacketCounter = obj.droppedPacketCounter + 1;
                    end

                    obj.timer1Active = true;
              
                end
                %obj.HavePacket = true;
                %obj.PacketStore = Packet;% store 1 packet - debug
            end
        end
        
        function sPacket = sendPacket(obj)
            %if (obj.delayT == false)
            %    sPacket = struct('Type', 99);
            %else
            pakkieNode = obj.OUTQueue.dequeue();
            sPacket = pakkieNode.data;
            str = [obj.NodeID, ' sending packet >>>>>'];
            disp(str);
            obj.HavePacket = false;
            obj.packetSCounter = obj.packetSCounter + 1;
            %end
        end
        
        function sPacket = sendACKPacket(obj)
            
            pakkieNode = obj.ACKQueue.dequeue();
            sPacket = pakkieNode.data;
            str = [obj.NodeID, ' sending ACK packet >>>>>'];
            disp(str);
            obj.ACK = false;
            obj.ACKPacketSCounter = obj.ACKPacketSCounter + 1;
            
        end
        
    end
    
end


