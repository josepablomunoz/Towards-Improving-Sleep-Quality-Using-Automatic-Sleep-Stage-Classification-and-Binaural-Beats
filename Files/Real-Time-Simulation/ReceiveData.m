%%Filters
fs_Hz = 250;

bpf = [5.0, 50.0];

[b,a] = butter(2,bpf/(fs_Hz / 2.0), 'bandpass');

notch = [59.0, 61.0];
[b2, a2] = butter(2,notch/(fs_Hz / 2.0), 'stop');

%Buffers
little_buff = zeros(2,10);
display_buff = zeros(2,5000);
display_buff_filt = zeros(2,5000);
cont = 1;

%Audios
labels = {'Awake','Stage 1','Stage 2','Stage 3','REM','Detecting...'};
audios = ["Binaural0.wav","Binaural1.wav","Binaural2.wav","Binaural3.wav"];
audios = char(audios);
font =  'Oswald';
clase_asign = 6;
%% Graph
h = figure('Name','Sleep Simulator','NumberTitle','off','Color','w', 'Menu','none'); clf;
set(gcf, 'Position', get(0, 'Screensize'));
x = linspace(1,5000,5000);

% msg =  sprintf('Sleep \nSimulation');
% 
% m = text(0.5, 0.5, msg, 'FontSize',90, 'Color','k', ...
%     'HorizontalAlignment','Center', 'VerticalAlignment','Middle','FontName',font);
%     axis off
% pause(2);
% 
% delete(m);

%% instantiate the library
disp('Loading the library...');
lib = lsl_loadlib();

% resolve a stream...
disp('Resolving an EEG stream...');
result = {};
while isempty(result)
    result = lsl_resolve_byprop(lib,'type','EEG'); end

% create a new inlet
disp('Opening an inlet...');
inlet = lsl_inlet(result{1});

disp('Now receiving data...');

while true
    % get data from the inlet
    [vec,ts] = inlet.pull_sample();
    little_buff(1,cont) = vec(1);
    little_buff(2,cont) = vec(2);
    
    if cont == 10
        cont = 1;
        display_buff(1,:) = AppendandShift(display_buff(1,:),little_buff(1,:));
        display_buff(2,:) = AppendandShift(display_buff(2,:),little_buff(2,:));
        display_buff_filt(1,:) = filter(b2,a2,display_buff(1,:));
        display_buff_filt(2,:) = filter(b2,a2,display_buff(2,:));
        display_buff_filt(1,:) = filter(b,a,display_buff_filt(1,:));
        display_buff_filt(2,:) = filter(b,a,display_buff_filt(2,:));
        
        subplot(3,1,1);
        c = line(x,display_buff_filt(1,:),'Color','k');
        xlim([3000 5000]);
        ylim([-200 200]);
        title('EEG Fpz','Color','k')
        xlabel("Time (s)"+newline+"   ")
        ylabel('Amplitude (uV)','Color','k')
        
        subplot(3,1,2);
        d = line(x,display_buff_filt(2,:),'Color','k');
        xlim([3000 5000]);
        ylim([-200 200]);
        title('EEG Pz','Color','k')
        xlabel("Time (s)"+newline+"   ")
        ylabel('Amplitude (uV)','Color','k')
        
        subplot(3,1,3);
        e = text(0.5, 0.5, labels(clase_asign), 'FontSize',75, 'Color','k', ...
        'HorizontalAlignment','Center', 'VerticalAlignment','Middle','FontName',font);
        axis off
           
        close = ishghandle(c); 
        pause(0.0005)
        delete(c);
        delete(d)
        delete(e)
        
    else 
        cont = cont + 1;    
    end
    if ~close
        break
    end
    
    % and display it
%     fprintf('%.2f\t',vec);
%     fprintf('%.5f\n',ts);
end