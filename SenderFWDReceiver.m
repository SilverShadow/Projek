%Source - FWD - REceiver
% setup workspace
clc;
clear;

pktSize = 1500;


n1 = Node_H('num1', 1);

s1 = SourceNode_H('source1', 32, pktSize);
r1 = ReceiverNode_H('receiver1', 32, pktSize);

s1.sendFile('smiley.jpg');


for i = 1: 70
    i
    x = s1.sendPacket();
    n1.receivePacket(x);
    if (n1.HavePacket == true)
        x2 = n1.sendPacket(); 
        r1.receivePacket(x2);
    end
    if(r1.ACK == true)
        a = r1.sendPacket();
        n1.receivePacket(a);
        if (n1.HavePacket == true)
            a1 = n1.sendPacket();
            s1.receivePacket(a1);
        end
     end
    
    
    
end