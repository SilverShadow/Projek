classdef Queue<handle
    %% Queue Class
    % 
    % properties:
    %
    %       link- doubly lined list for storing data
    % 
    % methods:
    % 
    %       Queue- constructor for Queue class
    % 
    %       enqueue(queue,x)- method for inserting new element x into the
    %       queue. x may be of any data type.
    % 
    %       x=dequeue(queue)- method for getting the next element x in the
    %       queue
    %  
    %       isempty- returns true if the queue is empty and false otherwise
    %
    % exemple:
    % 
    %       queue=Queue;
    % 
    %       queue.enqueue('12');
    % 
    %       n=queue.dequeue;
    
    properties(Access=private)
        link
    end
    properties(Access=public)
        counter = 0;
        capacity;
    end
    
    methods
        function queue=Queue(cap)
            queue.link=DoublyLinkedList([]);
            queue.capacity = cap;
        end
        
        function enqueue(queue,x)
           if(queue.counter < queue.capacity)
                if isa(x,'Node')
                   insert(queue.link,x);
                   queue.counter = queue.counter +1;
               else
                   insert(queue.link,Node(x));
                   queue.counter = queue.counter +1;
               end
               if isempty(queue.link.tail)
                   queue.link.tail=queue.link.head;
               end
           else
               error ('The queue is full');
           end
        end
        
        function x=dequeue(queue)
            if ~isempty(queue.link.tail)
                x=queue.link.tail;
                delete(queue.link,queue.link.tail);
                if (queue.counter > 0)
                    queue.counter = queue.counter - 1;
                else
                    error('counter was negativeand not correct');
                end
            else 
                error('The queue is empty');
            end
            
        end
        
        % check whether this queue is empty
        function tf=isempty(queue)
            tf=isempty(queue.link.tail);
            
        end
        
        % get/set functions
        function set.link(queue,link)
            queue.link=link;
        end
        
        function link=get.link(queue)
            link=queue.link;
        end
               
        function tf = isFull(queue)
            if(queue.counter < queue.capacity)
                tf = false;
            else
                tf = true;
            end 
        end
    end
    
end

