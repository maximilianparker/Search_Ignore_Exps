clear
%% SET UP PSYCHTOOLBOX AND KEYBOARD
rand('state',sum(100*clock));
Screen('Preference','SkipSynctests',1);

ErrorDelay=1; interTrialInterval = .5; ntrials = 144; % groups of 30

KbName('UnifyKeyNames');
Key1=KbName('UpArrow');     % 38
Key2=KbName('RightArrow');  % 39 right
Key3=KbName('DownArrow');   % 40
Key4=KbName('LeftArrow');   % 37 left key

spaceKey=KbName('space'); Esckey=KbName('ESCAPE');
% corrkey=[37,38,39,40];
grey=[128 128 128]; white=[255 255 255]; black=[0 0 0];
bgColour=white; textColour=white;

prompt={'outputfie','Subject','Age','Gender'};
defaults={'Exp1','1','26','M','1'};
answer=inputdlg(prompt,'Exp1',2,defaults');
[output,subid,subage,subgender]=deal(answer{:});

%% LOAD IMAGE LISTS AND IMAGES
cd stim
clocks_list=dir(fullfile('clocks', '*.png'));
keys_list=dir(fullfile('keys', '*.png'));
neutral_list=dir(fullfile('neutral', '*.png'));

numfiles = length(clocks_list);
mydata = cell(1, numfiles);
for k = 1:ntrials    % numfiles 
        cd clocks
        NT{k} = imread(clocks_list(k).name); 
        cd ../
end
numfiles = length(neutral_list);
mydata = cell(1, numfiles);
for k=1:ntrials      % numfiles 
        cd neutral
        T{k}= imread(neutral_list(k).name);
        cd ../
end
numfiles = length(keys_list);
mydata = cell(1, numfiles);
for k=1:ntrials      % numfiles 
        cd keys
        P{k}= imread(keys_list(k).name);
        cd ../
end

cd ../
%% SET PARAMS: images and duration combinations and randomization
combinations=[1,2;1,3;1,4;2,3;2,4;3,4];
neachcomb=ntrials/length(combinations);

poslist=repmat(combinations,neachcomb,1);
a=randperm(ntrials);
for i=1:length(a)
    TNTlist(i,1:2)=poslist(a(i),:);
end
prime_locs(1:ntrials/4)=1;prime_locs(ntrials/4+1:(2*ntrials)/4)=2;prime_locs((2*ntrials)/4+1 ... 
    :(3*ntrials)/4)=3; prime_locs((3*ntrials)/4+1:(4*ntrials)/4)=4;
b=randperm(ntrials);
for i=1:length(b)
    Plist(i,1)=prime_locs(b(i));
end

durations=[.25;.5;.75;1];
comb=ntrials/length(durations);
dur=repmat(durations,comb,1);
a=randperm(ntrials);
for i=1:length(a)
    Gap_durations(i,1)=dur(a(i),:);
end

%% GENERATE A RANDOMISED LIST OF POSITIONS FOR T, NT and P, OR LOAD A PRE-SAVED SET
% TNTlist=load('TNTlist.mat');
% Plist=load('Plist.mat');
Tpos=TNTlist(:,1);
NTpos=TNTlist(:,2);
Ppos=Plist(:,1);

%% PARAMETERS OF SCREEN/IMAGE
screen_size=[1920,1080];
central_area=[1080,1080];
outer_area=[screen_size(1)-central_area(1),screen_size(2)-central_area(2)];
centre=[central_area(1)/2,central_area(2)/2];
picture_size=[274,274];
offset=50;

%% PICTURE LOCATIONS
Top=[offset,centre(2)-(picture_size(1)/2)];
Left=[centre(1)-picture_size(1)/2,offset];
Right=[centre(2)-picture_size(2)/2,central_area(1)-offset-picture_size(1)];
Bottom=[central_area(1)-offset-picture_size(2),centre(2)-picture_size(1)/2,];

[win,screenrect]=Screen(0,'OpenWindow');
Screen('FillRect',win,bgColour);
centre=[screenrect(3)/2 screenrect(4)/2];
Screen(win,'Flip');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%           EXPERIMENT             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%   Experimental instructions
Screen('FillRect', win ,bgColour);
Screen('TextSize', win, 24);
Screen('DrawText',win,'Ignore the image presented alone. When the display with two images comes on, respond to the location of the Target (not clock or key)',centre(1)-820,centre(2)-20,[0,0,0]);
Screen('DrawText',win,'Respond with the direction buttons: UP arrow, Down arrow, left arrow or right arrow)',centre(1)-500,centre(2),[0,0,0]);
Screen('DrawText',win,'When you are ready to start the experiment, please press Space to continue',centre(1)-500,centre(2)+20,[0,0,0]);
Screen('Flip',win);

keyIsDown=0;
while 1
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(spaceKey)
            break ;
        elseif keyCode(escKey)
            ShowCursor;
            fclose(outfile);
            Screen('CloseAll');
            return;
        end
    end
end
WaitSecs(0.1);

Screen('DrawText', win, ['Click to start'], centre(1)-100, centre(2), [0,0,0]);
Screen('Flip', win);
GetClicks;
WaitSecs(.1);

%% Actual experiment
% trial loop
for i = 1:ntrials
    %         cellindex = Shuffle(1:nrow.*ncolumn); % randomize the position of the star within the grid specified earlier
    %         itemloc = [cellcentre(cellindex(1),1)-cellsize/2, cellcentre(cellindex(1),2)-cellsize/2, cellcentre(cellindex(1),1)+cellsize/2, cellcentre(cellindex(1),2)+cellsize/2];
    Screen('FillRect', win ,bgColour); 
    
    
%% Draw prime screen
    prime1(1:central_area(1),1:central_area(2),1:3)=255;
    prime1=uint8(prime1);
    
if Ppos(i)==1
    prime1(Top(1):Top(1)+picture_size(1),Top(2):Top(2)+picture_size(2),:)=P{i};
elseif Ppos(i)==2
    prime1(Right(1):Right(1)+picture_size(1),Right(2):Right(2)+picture_size(2),:)=P{i};
elseif Ppos(i)==3
    prime1(Bottom(1):Bottom(1)+picture_size(1),Bottom(2):Bottom(2)+picture_size(2),:)=P{i};
elseif Ppos(i)==4
    prime1(Left(1):Left(1)+picture_size(1),Left(2):Left(2)+picture_size(2),:)=P{i};
end
    prime_texture=Screen('MakeTexture',win,prime1);
    

    Screen('DrawTexture',win,prime_texture,[],[],0)
    DrawFormattedText(win, '+','center','center', [0,0,0]);
    Screen('Flip',win)
     WaitSecs(.25)
%     WaitSecs(Gap_durations(i))

    %% Draw screen inbetween prime and array
    Screen('FillRect', win ,bgColour); 
    DrawFormattedText(win, '+','center','center', [0,0,0]);
    Screen('Flip', win);
%     WaitSecs(.5)
     WaitSecs(Gap_durations(i))
    
    %% Draw search array
    % SET BACKGROUND
    img(1:central_area(1),1:central_area(2),1:3)=255;
    img=uint8(img);
    if Tpos(i)==1
        img(Top(1):Top(1)+picture_size(1),Top(2):Top(2)+picture_size(2),:)=T{i};
    elseif  Tpos(i)==2
        img(Right(1):Right(1)+picture_size(1),Right(2):Right(2)+picture_size(2),:)=T{i};
    elseif  Tpos(i)==3
        img(Bottom(1):Bottom(1)+picture_size(1),Bottom(2):Bottom(2)+picture_size(2),:)=T{i};
    elseif Tpos(i)==4
        img(Left(1):Left(1)+picture_size(1),Left(2):Left(2)+picture_size(2),:)=T{i};
    end
    if NTpos(i)==1
        img(Top(1):Top(1)+picture_size(1),Top(2):Top(2)+picture_size(2),:)=NT{i};
    elseif NTpos(i)==2
        img(Right(1):Right(1)+picture_size(1),Right(2):Right(2)+picture_size(2),:)=NT{i};
    elseif NTpos(i)==3
        img(Bottom(1):Bottom(1)+picture_size(1),Bottom(2):Bottom(2)+picture_size(2),:)=NT{i};
    elseif NTpos(i)==4
        img(Left(1):Left(1)+picture_size(1),Left(2):Left(2)+picture_size(2),:)=NT{i};
    end
    img_texture=Screen('MakeTexture',win,img);  
    Screen('DrawTexture',win,img_texture,[],[],0)
    DrawFormattedText(win, '+','center','center', [0,0,0]);
    
    if Tpos(i)==1
        corrKey=Key1;
    elseif Tpos(i)==2
        corrKey=Key2;
    elseif Tpos(i)==3
        corrKey=Key3;
    elseif Tpos(i)==4
        corrKey=Key4;
    end
    
    % present the stimulus
    Screen('Flip',win)
    timeStart = GetSecs;keyIsDown=0; correct=0; rt=0;  

  %% LOG RESPONSE
    while 1
        [keyIsDown, secs, keyCode] = KbCheck;
        FlushEvents('keyDown');
        if keyIsDown
            nKeys = sum(keyCode);
            if nKeys==1
                if keyCode(Key1)||keyCode(Key2)||keyCode(Key3)||keyCode(Key4)
                    rt = 1000.*(GetSecs-timeStart);
                    keypressed=find(keyCode);
                    Screen('Flip', win);
                    break;
                elseif keyCode(escKey)
                    ShowCursor; fclose(outfile);  Screen('CloseAll'); return
                end
                keyIsDown=0; keyCode=0;
            end
        end
    end
    if keypressed==corrKey
        correct=1;
    else
        correct=0; 
    end

    
    Screen('FillRect', win ,bgColour); Screen('Flip', win);
    
    %% RECORD DATA
    sub=str2num(subid);
    if subgender=='M'
        gender=1;
    else
        gender=2;
    end
    
    m(i,1)=sub;
    m(i,2)=gender;
    m(i,3)=str2num(subage);
    m(i,4)=i;
    m(i,5)=Tpos(i);
    m(i,6)=NTpos(i);
    m(i,7)=Ppos(i);
    m(i,8)=keypressed;
    m(i,9)=correct;
    m(i,10)=rt;
    m(i,11)=Gap_durations(i);
    
    WaitSecs(interTrialInterval);
    
    clear bg img prime1
end  % end of trial loopend %
% end %of block loop
fprintf('\n\n\n\n\nFINISHED this part! PLEASE GET THE EXPERIMENTER...\n\n');
Screen('CloseAll');
% fclose(outfile);

%% WRITE TO FILE
filename=sprintf('%d.xlsx',sub);
titles={'p','gender','age','trial','Tpos','NTpos','Ppos','keypress','correct','rt','Gap'};
xlswrite(filename,titles,1,'A1');
xlswrite(filename,m,1,'A2');