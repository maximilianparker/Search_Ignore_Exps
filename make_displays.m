clear
cd stim
%% LOAD IMAGE LISTS AND IMAGES
clocks_list=dir(fullfile('clocks', '*.png'));
keys_list=dir(fullfile('keys', '*.png'));
neutral_list=dir(fullfile('neutral', '*.png'));

numfiles = length(clocks_list);
mydata = cell(1, numfiles);
for k = 1:10    % numfiles 
        cd clocks
        NT{k} = imread(clocks_list(k).name); 
        cd ../
end
numfiles = length(neutral_list);
mydata = cell(1, numfiles);
for k=1:10      % numfiles 
        cd neutral
        T{k}= imread(neutral_list(k).name);
        cd ../
end
numfiles = length(keys_list);
mydata = cell(1, numfiles);
for k=1:10      % numfiles 
        cd keys
        P{k}= imread(keys_list(k).name);
        cd ../
end

cd ../
%% SET PARAMS
combinations=[1,2;1,3;1,4;2,3;2,4;3,4];
ntrials=144;
neachcomb=ntrials/length(combinations);

%% GENERATE A RANDOMISED LIST OF POSITIONS FOR T, NT and P, OR LOAD A PRE-SAVED SET
TNTlist=load('TNTlist.mat')
Plist=load('Plist.mat')

% poslist=repmat(combinations,neachcomb,1);
% a=randperm(ntrials);
% for i=1:length(a)
%     TNTlist(i,1:2)=poslist(a(i),:);
% end
% prime_locs(1:ntrials/4)=1;prime_locs(ntrials/4+1:(2*ntrials)/4)=2;prime_locs((2*ntrials)/4+1 ... 
%     :(3*ntrials)/4)=3; prime_locs((3*ntrials)/4+1:(4*ntrials)/4)=4;
% b=randperm(ntrials);
% for i=1:length(b)
%     Plist(i,1)=prime_locs(b(i));
% end


%% PARAMETERS OF SCREEN/IMAGE
screen_size=[1920,1080];
central_area=[1080,1080];
outer_area=[screen_size(1)-central_area(1),screen_size(2)-central_area(2)];
centre=[central_area(1)/2,central_area(2)/2];
picture_size=[274,274];
offset=50;

% PICTURE LOCATIONS
Top=[offset,centre(2)-(picture_size(1)/2)];
Left=[centre(1)-picture_size(1)/2,offset];
Right=[centre(2)-picture_size(2)/2,central_area(1)-offset-picture_size(1)];
Bottom=[central_area(1)-offset-picture_size(2),centre(2)-picture_size(1)/2,];

%% MAKE SEARCH ARRAYS
for i=1:ntrials

% SET BACKGROUND
img(1:central_area(1),1:central_area(2),1:3)=255;
img=uint8(img);

if TNTlist.TNTlist(i,1)==1
    img(Top(1):Top(1)+picture_size(1),Top(2):Top(2)+picture_size(2),:)=T{i};
elseif TNTlist.TNTlist(i,1)==2
    img(Right(1):Right(1)+picture_size(1),Right(2):Right(2)+picture_size(2),:)=T{i};
elseif TNTlist.TNTlist(i,1)==3
    img(Bottom(1):Bottom(1)+picture_size(1),Bottom(2):Bottom(2)+picture_size(2),:)=T{i};
elseif TNTlist.TNTlist(i,1)==4
    img(Left(1):Left(1)+picture_size(1),Left(2):Left(2)+picture_size(2),:)=T{i};
end
if TNTlist.TNTlist(i,2)==1
    img(Top(1):Top(1)+picture_size(1),Top(2):Top(2)+picture_size(2),:)=NT{i};
elseif TNTlist.TNTlist(i,2)==2
    img(Right(1):Right(1)+picture_size(1),Right(2):Right(2)+picture_size(2),:)=NT{i};
elseif TNTlist.TNTlist(i,2)==3
    img(Bottom(1):Bottom(1)+picture_size(1),Bottom(2):Bottom(2)+picture_size(2),:)=NT{i};
elseif TNTlist.TNTlist(i,2)==4
    img(Left(1):Left(1)+picture_size(1),Left(2):Left(2)+picture_size(2),:)=NT{i};
end
% imshow(img)
bg(1:screen_size(2),1:screen_size(1),1:3)=255;
bg=uint8(bg);
bg(1:screen_size(2),(outer_area(1)/2)+1:screen_size(1)-(outer_area(1)/2),:)=img;
% imshow(bg)
% waitforbuttonpress

cd Displays
imwrite(bg,sprintf('%d.bmp',i));
cd ../
clear bg img
end

%% MAKE PRIME ARRAYS
for i=1:ntrials

% SET BACKGROUND
img(1:central_area(1),1:central_area(2),1:3)=255;
img=uint8(img);

if Plist.Plist(i,1)==1
    img(Top(1):Top(1)+picture_size(1),Top(2):Top(2)+picture_size(2),:)=P{i};
elseif Plist.Plist(i,1)==2
    img(Right(1):Right(1)+picture_size(1),Right(2):Right(2)+picture_size(2),:)=P{i};
elseif Plist.Plist(i,1)==3
    img(Bottom(1):Bottom(1)+picture_size(1),Bottom(2):Bottom(2)+picture_size(2),:)=P{i};
elseif Plist.Plist(i,1)==4
    img(Left(1):Left(1)+picture_size(1),Left(2):Left(2)+picture_size(2),:)=P{i};
end
% imshow(img)
bg(1:screen_size(2),1:screen_size(1),1:3)=255;
bg=uint8(bg);
bg(1:screen_size(2),(outer_area(1)/2)+1:screen_size(1)-(outer_area(1)/2),:)=img;
imshow(bg)
% waitforbuttonpress

cd Prime_displays
imwrite(bg,sprintf('P_%d.bmp',i));
cd ../
clear bg img
end     

%% STORE RELEVANT DATA IN XLS
% xls(:,1)=Plist.Plist;   % PRIME POS
% xls(:,2)=keys_list.name;       % PRIMES FOR NOW
% xls(:,[3,5])=TNTlist.TNTlist;
% xls(:,4)=neutral_list.name;
% xls(:,6)=clocks_list.name;



