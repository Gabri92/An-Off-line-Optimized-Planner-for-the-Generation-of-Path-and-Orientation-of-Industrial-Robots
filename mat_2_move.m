function mat_2_move(Crv,Ang)

% 'mat_2_move' - Take as input the positions and the orientations
% and write the binary file and the PDL program to run the traectories 
% on the robot

% INPUT
%   Crv - Buffer containing the positions
%   Ang - Buffer containing the orientations

Ts=2;           % Expressed in ms
crv.Ts=Ts;
if (Crv == 0) 
    bspline = zeros(3,length(Ang));
    bspline(2,:) = 100*ones(1,length(Ang));
    bspline(3,:) = 400*ones(1,length(Ang));
    crv.Traj(:,1)=bspline(1,:);
    crv.Traj(:,2)=bspline(2,:);
    crv.Traj(:,3)=bspline(3,:);
    n=length(euler);
else
    n=length(bspline);
    crv.Traj(:,1)=bspline(1,:);
    crv.Traj(:,2)=bspline(2,:);
    crv.Traj(:,3)=bspline(3,:);
end
if (Ang == 0)
    E1=zeros(n,1);
    E2=1.5*ones(n,1);
    E3=zeros(n,1);
else
    E1 = euler(1,:);
    E2 = euler(2,:);
    E3 = euler(3,:);
end

%-----------------------------------
n = length(bspline);
crv.Traj(:,1)=bspline(1,:);
crv.Traj(:,2)=bspline(2,:);
crv.Traj(:,3)=bspline(3,:);
%-------------------------------------------------
crv.E(:,1)=E1;
crv.E(:,2)=E2;
crv.E(:,3)=E3;

for k=2:n
dX(k) =(crv.Traj(k,1)-crv.Traj(k-1,1))/Ts;
dY(k) =(crv.Traj(k,2)-crv.Traj(k-1,2))/Ts;
dZ(k) =(crv.Traj(k,3)-crv.Traj(k-1,3))/Ts;
end
CurVel = sqrt( dX.^2 +dY.^2 +dZ.^2); % m/s
CurVel(1)   = 0.0;
CurVel(end) = 0.0;
VEL        = 1;
Spd_Max = VEL;
%
% ================================================================
%
Gen_OVR = 1.0;
if exist('checsum.dat'),
   delete('checsum.dat'); 
end
fileID = fopen('checsum.dat','w');
for i=1:round( length( crv.Traj )),
    fwrite(fileID, single( crv.Traj(i,1)),'single');
    fwrite(fileID, single( crv.Traj(i,2) ),'single');
    fwrite(fileID, single( crv.Traj(i,3)),'single');
    fwrite(fileID, single( E1(i) ),'single');
    fwrite(fileID, single( E2(i) ),'single');
    fwrite(fileID, single( E3(i) ),'single');
    fwrite(fileID, 0,'int32');
    %
    fwrite(fileID, 0,'int8');
    fwrite(fileID, 0,'int8');
    fwrite(fileID, 0,'int8');
    fwrite(fileID, 0,'int8');
    %
    fwrite(fileID, Gen_OVR,'single');
    fwrite(fileID, single(CurVel(i)),'single'); % m/s
end
fclose(fileID);
%
CHECKSUM = uint32(0);
%
file = fopen('checsum.dat','r');
%
for j=1:round( length( crv.Traj )),
    %
    % calcolo checksum
    %
    for i = 1:40,
        data     = uint8( fread(file,1,'uint8') );
        CHECKSUM = Calc_Checksum( CHECKSUM, data );
    end
end
%
fclose(file);
%
%%
LOG_file_name = 'moni_2';
LOG_file_name = parinput(LOG_file_name,'Nome del file contenente il percorso?');
%
PDL_prog_name = 'Test_2';
PDL_prog_name = parinput(PDL_prog_name,'Nome del programma PDL?');
%
if exist([LOG_file_name,'.log']),
   delete([LOG_file_name,'.log']); 
end
%
fileID = fopen([LOG_file_name,'.log'],'w');
fwrite(fileID,  2, 'int8');    % period
fwrite(fileID, 63, 'int16');   % maschera assi
fwrite(fileID, 32, 'int16');   % modalita' moni
fwrite(fileID,  1, 'int16');   % decampionamento ---> ?????
fwrite(fileID, 25, 'int8');    % indice di versione
%
fwrite(fileID,488, 'int16');   % Dimensione dell'header
fwrite(fileID,  1, 'int8');    % Vers. head
fwrite(fileID,  1, 'int8');    % Vers. SLJ
fwrite(fileID,  3, 'int8');    % Ver SW
fwrite(fileID,  1, 'int8');    % Ver SW
fwrite(fileID,  1, 'int8');    % Ver SW
fwrite(fileID,  0, 'int8');    % Ver SW
%
fwrite(fileID,  18, 'int8');   % Data
fwrite(fileID,  10, 'int8');   % Data
fwrite(fileID,   1, 'int8');   % Data
fwrite(fileID,   0, 'int8');   % Data
%
fwrite(fileID,  9, 'int8');    % Ora Start
fwrite(fileID,  0, 'int8');    % Ora Start
fwrite(fileID,  0, 'int8');    % Ora Start
fwrite(fileID,  0, 'int8');    % Ora Start
%
fwrite(fileID, 10, 'int8');    % Ora Stop
fwrite(fileID,  0, 'int8');    % Ora Stop
fwrite(fileID,  0, 'int8');    % Ora Stop
fwrite(fileID,  0, 'int8');    % Ora Stop
% 
%BASE   := POS(0)
% TOOL   = [629.59998, 0.28, 389.5, 0, 90, 180]
% UFRAME =  [1987.9, 556.87, 1693.0, -89.800003, 171, -180]
TOOL   = [629.599975586,0.280000001192,389.5,0, 90, 180]
UFRAME =  [2187.94995117,556.869995117,1693.0300293,-89.8000030518,171,-180]
% UFRAME = [0,0,0,0,0,0];

%
%BASE
fwrite(fileID, 0,'single');
fwrite(fileID, 0,'single');
fwrite(fileID, 0,'single');
fwrite(fileID, 0,'single');
fwrite(fileID, 0,'single');
fwrite(fileID, 0,'single');
fwrite(fileID, 0,'int32');
%UFRAME
%UFRAME = [ 0, 0, 0, 0, 0, 0 ];
% UFRAME = crv.UFRAME;
fwrite(fileID, single( UFRAME(1) ),'single');
fwrite(fileID, single( UFRAME(2) ),'single');
fwrite(fileID, single( UFRAME(3) ),'single');
fwrite(fileID, single( UFRAME(4) ),'single');
fwrite(fileID, single( UFRAME(5) ),'single');
fwrite(fileID, single( UFRAME(6) ),'single');
fwrite(fileID, 0,'int32');
%TOOL
% TOOL = [ 0, 0, 0, 0, 0, 0 ];
% TOOL = crv.TOOL;
fwrite(fileID, single( TOOL(1) ),'single');
fwrite(fileID, single( TOOL(2) ),'single');
fwrite(fileID, single( TOOL(3) ),'single');
fwrite(fileID, single( TOOL(4) ),'single');
fwrite(fileID, single( TOOL(5) ),'single');
fwrite(fileID, single( TOOL(6) ),'single');
fwrite(fileID, 0,'int32');
%POS_INI
fwrite(fileID, single( crv.Traj(1,1) ),'single');
fwrite(fileID, single( crv.Traj(1,2) ),'single');
fwrite(fileID, single( crv.Traj(1,3) ),'single');
fwrite(fileID, single( E1(1) ),'single');
fwrite(fileID, single( E2(1) ),'single');
fwrite(fileID, single( E3(1) ),'single');
fwrite(fileID, 0,'int32');
%POS_FIN
fwrite(fileID, single( crv.Traj(end,1) ),'single');
fwrite(fileID, single( crv.Traj(end,2) ),'single');
fwrite(fileID, single( crv.Traj(end,3) ),'single');
fwrite(fileID, single( E1(end) ),'single');
fwrite(fileID, single( E2(end) ),'single');
fwrite(fileID, single( E3(end) ),'single');
fwrite(fileID, 0,'int32');
%
fwrite(fileID, 0,'single');                         % Spd Ini
fwrite(fileID, single(Spd_Max),'single');           % Spd Max
fwrite(fileID, 0,'single');                         % Spd Fin
%
fwrite(fileID, round( length( crv.Traj )),'int32'); % Num Record 
fwrite(fileID, CHECKSUM,'int32');                   % Checksum
%file name
fwrite(fileID, 256,'int32');
fwrite(fileID, 9,'int32');
RobotFileName = 'NJ1_06016';
RobotFileName = parinput(RobotFileName,'Nome del file di configurazione del robot');
%
for i=1:length(RobotFileName),
    fwrite(fileID, char(RobotFileName(i)),'int8');
end
%
for i=length(RobotFileName)+1:260
    fwrite(fileID, 0,'int8');
end
%
for i=1:10
    fwrite(fileID, 0,'int32');
end
%
% RECORD
% 
% typedef struct  mndw_monRecTrjRecord
% {
%   GBSW_POS_VAL   sx_pos_val       ; 6 float + intero  .x .y .z .a .e .t .cnfg(intero a 32)
%   unsigned char  ac_DIN[4]        ; 4 char 
%   float          sf_gen_override  ; 1 float
%   float          sf_curvel        ; 1 float
% } 
% 
CHECK = [];
for i=1:round( length( crv.Traj )),
    fwrite(fileID, single( crv.Traj(i,1) ),'single');
    fwrite(fileID, single( crv.Traj(i,2) ),'single');
    fwrite(fileID, single( crv.Traj(i,3) ),'single');
    fwrite(fileID, single( E1(i) ),'single');
    fwrite(fileID, single( E2(i) ),'single');
    fwrite(fileID, single( E3(i) ),'single');
    fwrite(fileID, 0,'int32');                         % .cnfg(intero a 32)
    %
    fwrite(fileID, 0,'int8');
    fwrite(fileID, 0,'int8');
    fwrite(fileID, 0,'int8');
    fwrite(fileID, 0,'int8');
    %
    fwrite(fileID, Gen_OVR,'single');
    fwrite(fileID, single(CurVel(i)),'single'); % m/s
end
%
fclose(fileID);
%
%% =============
%
filename = [PDL_prog_name,'.pdl'];
if exist(filename,'file'),
   delete(filename);
end
%
diary(filename)
disp(['PROGRAM ',PDL_prog_name]);
disp(['VAR p1 : POSITION']);
disp(['BEGIN']);
disp(['  $RPL_DIR_PATH := ''UD:\\usr\\Prova_2''']);
disp(['  $RPL_SPD_OVR := 100']);
disp(['  $BASE   := POS(0)']);
disp(['  $TOOL   := POS(',num2str(single(TOOL(1)),12),',',num2str(single(TOOL(2)),12),',',num2str(single(TOOL(3)),12),',',num2str(single(TOOL(4)),12),',',num2str(single(TOOL(5)),12),',',num2str(single(TOOL(6)),12),')']);
disp(['  $UFRAME := POS(',num2str(single(UFRAME(1)),12),',',num2str(single(UFRAME(2)),12),',',num2str(single(UFRAME(3)),12),',',num2str(single(UFRAME(4)),12),',',num2str(single(UFRAME(5)),12),',',num2str(single(UFRAME(6)),12),')']);
%
P1X = num2str( single( crv.Traj(1,1) ), 12 );
P1Y = num2str( single( crv.Traj(1,2) ), 12 );
P1Z = num2str( single( crv.Traj(1,3) ), 12 );
a1  = num2str( single(  E1(1)*180/pi ), 12 );
e1  = num2str( single(  E2(1)*180/pi ), 12 );
r1  = num2str( single(  E3(1)*180/pi ), 12 );
%
disp(['  p1 := POS(',P1X,', ',P1Y,', ',P1Z,', ',a1,', ',e1,', ',r1,', '''' )']);
disp(['  ']);
disp(['  MOVE TO {0, 0, -90, 0, 90, 0}']);
disp(['  delay 1000']);
disp(['CYCLE']);
disp(['  MOVE TO p1']);
disp(['  delay 1000']);
disp(['  MOVE FROM p1 REPLAY ''',LOG_file_name,'.log''']);
disp(['  delay 1000']);
disp(['END ',PDL_prog_name]);
diary off
%
%%
%
[ out_getmoni ] = GetMoniSLJ([LOG_file_name,'.log']);
char(out_getmoni.rb_name_str(1:out_getmoni.rb_name_cur_len+2)');

end