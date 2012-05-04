%Sender - Receiver test
% setup workspace
clc;
clear;

pktSize = 1500;
genSize = 32;

s1 = SourceNode_H('source1', genSize, pktSize);
r1 = ReceiverNode_H('receiver1', genSize, pktSize);

s1.sendFile('smiley.jpg');
 
for i = 1:38
    if (r1.ACK)
        x = r1.sendPacket();
        s1.receivePacket(x);
    else
        if(s1.noMoreGen == false)
        x = s1.sendPacket();
        r1.receivePacket(x);
        end
    end
end