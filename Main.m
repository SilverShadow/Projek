% setup workspace
clc;
clear;

ACKPacket = struct('Type', 0, 'GenID', 1);
ACKPacket2 = struct('Type', 0, 'GenID', 2);
pktSize = 1500;

TestCodeVectorMatrix_gf = gf(zeros(32,32,3),8);
TestCodedPacketMatrix_gf = gf(zeros(pktSize,32,3),8);


thershold1 = 10;
threshold2 = 20;

n1 = Node_H('num1', 10);
n2 = Node_H('hello', 20);
s1 = SourceNode_H('source1', 32, pktSize);
r1 = ReceiverNode_H('receiver1', 32, pktSize);

s1.sendFile('smiley.jpg');
 
for i = 1:32
    x = s1.sendPacket();
    r1.receivePacket(x);
end


% 
% for i =1:32
%      x = s1.sendPacket();
%      TestCodeVectorMatrix_gf(i,:,1) = x.CodeVector_c;
%      TestCodedPacketMatrix_gf(:,i,1) = x.CodedData_e;
% end
% s1.receivePacket(ACKPacket);
% for i =1:32
%      x = s1.sendPacket();
%      TestCodeVectorMatrix_gf(i,:,2) = x.CodeVector_c;
%      TestCodedPacketMatrix_gf(:,i,2) = x.CodedData_e;
% end
% s1.receivePacket(ACKPacket2);
% for i =1:32
%      x = s1.sendPacket();
%      TestCodeVectorMatrix_gf(i,:,3) = x.CodeVector_c;
%      TestCodedPacketMatrix_gf(:,i,3) = x.CodedData_e;
% end
% % 
% for tel=1:1
%     tempTCVM = r1.CodeVectorMatrix_gf %TestCodeVectorMatrix_gf(:,:,tel);
%     tempTCPM =  r1.CodedPacketMatrix_gf%TestCodedPacketMatrix_gf(:,:,tel);
%     DecodedGMatrix = (tempTCVM\(tempTCPM'))';
%     fwid2 = fopen('smiley2.jpg', 'a+');
%     fwrite(fwid2, DecodedGMatrix.x);
%     fclose(fwid2);
% end
 
% 
% 
% for i= 1:60
%    disp(i);
%    n1.tick();
%    n2.tick();
%    if (i ==5)
%    n1.receivePacket('pakkie');
%    end
%    
%    if ( i ==7)
%        n2.receivePacket('random');
%    end
%    
%    if ( i == 8)
%        n1.receivePacket('vraat');
%    end
%    
%    if ( i == 28)
%        n2.receivePacket('ewekansig');
%    end
%    
% end

