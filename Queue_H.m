classdef Queue_H < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        buffer;
        beginning = 0;
        rear = 0;
        capacity;
        pointer = 0;
    end
    
    methods
        function obj = Queue_H(cap)
            obj.buffer = cell(cap);
            obj.capacity = cap;
        end
        
        function obj = insertIntoQueue(Packet)
            
        end
        
        function f = sizeOfQueue(obj)
            if (obj.rear >= obj.beginning)
                f = obj.rear - obj.beginning;
            else
                f = -1; % error is size is -1
                disp('ERROR size of the queue cant be negative')
            end
        end
        
        function b = isempty(obj)
            if (obj.sizeOfQueue() == 0 )
                b = true;
            elseif (obj.sizeOfQueue() == -1)
                b = true;
                disp('ERROR Queue cannot be negative and is empty');
            else
                b = false;
            end
        end
    end
    
end

