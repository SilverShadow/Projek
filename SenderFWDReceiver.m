%Source - FWD - REceiver
% setup workspace
clc;
clear;
for hoev = 1: 5


rowx = ['A', int2str(hoev)]
genSize = 32;
pktSize = 1500;
tick = 0;
ackFlag = false;
ackFlag1 = false;
fileName = 'foto.jpg'; 

tStart = tic;
n1 = Node_H('num1', 1);
%n2 = Node_H('num2', 1);

s1 = SourceNode_H('source1', genSize, pktSize);
r1 = ReceiverNode_H('receiver1', genSize, pktSize);

s1.sendFile(fileName);





tick = tick +1; 
x = s1.sendPacket();

tick = tick +1;
x2 = s1.sendPacket();
n1.receivePacket(x);

tick = tick +1;
x = s1.sendPacket();
n1.receivePacket(x2);
n1.tick();
f0 = n1.sendPacket();

tick = tick +1;
x2 = s1.sendPacket();
n1.receivePacket(x);
n1.tick();
f = n1.sendPacket();
r1.receivePacket(f0);

while(~s1.noMoreGen)
    tick = tick +1
    
    r1.receivePacket(f);
    
    n1.receivePacket(x2);
    n1.tick();
    f = n1.sendPacket();
    
    
    if(ackFlag1)
        s1.receivePacket(a);
        ackFlag1= false;
    end
    if(n1.ACK)
        n1.sendACKPacket();
        ackFlag1 =true;
    end
    if(ackFlag)
        n1.receivePacket(a);
        ackFlag= false;
    end
    if(r1.ACK)
       a = r1.sendPacket();
       ackFlag = true;
    end
    
    x2 = s1.sendPacket();
        
end
tElapsed = toc(tStart)


disp(fileName);
disp('was sent. size: ');
disp('number of generations');
disp(s1.numGenerations);


disp('Total ticks to send file: ');
disp(tick);

disp('s1 packets sent: ');
disp(s1.packetCounter);

disp('s1 ACK packets received: ');
disp(s1.ACKPacketRCounter);

disp('n1 total data packets received: ');
disp(n1.packetRCounter);

disp('n1 total data packets sent: ');
disp(n1.packetSCounter);

disp('n1 ACK packets received: ');
disp(n1.ACKPacketRCounter);

disp('r1 all packets received: ');
disp(r1.packetCounter);

disp('r1 relative gen packets received: ');
disp( r1.relGenPacketCounter);

disp('r1 non relative gen packets received: ');
disp( r1.NonrelGenPacketCounter);

%d={'Filename', simulationtime', 'Packetsize', 'GenSize',  'numGen',           'Total ticks to send file', 's1 packets sent', 's1 ACK packets received', 'n1 total data packets received',  'n1 total data packets sent',  'n1 ACK packets received', 'r1 all packets received', 'r1 relative gen packets received', 'r1 non relative gen packets received';
d={  fileName,   tElapsed,        pktSize,      genSize ,   s1.numGenerations,  tick ,                      s1.packetCounter,  s1.ACKPacketRCounter,      n1.packetRCounter,                 n1.packetSCounter,             n1.ACKPacketRCounter,      r1.packetCounter,         r1.relGenPacketCounter ,             r1.NonrelGenPacketCounter };

fff = xlswrite('testdata.xls', d, 'foto1500', rowx);

end

% 
% 
% for i = 2: 70
%     i
%     x = s1.sendPacket();
%     n1.receivePacket(x);
%     n1.tick();
%     if (n1.HavePacket == true)
%         x2 = n1.sendPacket(); 
%         n2.receivePacket(x2);
%     end
%     n2.tick();
%     if (n2.HavePacket == true)
%         x3 = n2.sendPacket(); 
%         r1.receivePacket(x3);
%     end
%     
%     if(r1.ACK == true)
%         a = r1.sendPacket();
%         n2.receivePacket(a);
%         n2.tick();
%         if (n2.HavePacket == true)
%             a1 = n2.sendPacket();
%             n1.receivePacket(a1);
%             n1.tick();
%         end
%         if (n1.HavePacket == true)
%             a2 = n1.sendPacket();
%             s1.receivePacket(a2);
%         end
%      end
%     
%     
%     
% end