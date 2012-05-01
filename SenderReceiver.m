%SenderReceiver test
% setup workspace
clc;
clear;

pktSize = 100;
genSize = 32;

s1 = SourceNode_H('source1', genSize, pktSize);
r1 = ReceiverNode_H('receiver1', genSize, pktSize);

s1.sendFile('smiley.jpg');
 
for i = 1:100
    if (r1.ACK)
        x = r1.sendPacket();
        s1.receivePacket(x);
    else
        x = s1.sendPacket();
        r1.receivePacket(x);    
    end
end