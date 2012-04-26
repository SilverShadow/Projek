classdef ReceiverNode_H < handle
    %ReceiverNode_H Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    NodeID
    end
    
    methods
        function obj = ReceiverNode_H(NodeID)
            obj.NodeID = NodeID;
        end
    
        function obj = receivePacket(obj, Packet)


        end
    
    
    end
end

