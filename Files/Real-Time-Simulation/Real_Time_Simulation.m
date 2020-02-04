%% Opciones de simulación

run_new = 1; % 1 para simular con una nueva red, 0 para simular con red existente

%% Prepare NETWORK
if run_new == 1 
    run Ext_caract_13.m
    run Neural_Network.m
end

%Filters
fs_Hz = 250;

bpf = [5.0, 50.0];

[b,a] = butter(2,bpf/(fs_Hz / 2.0), 'bandpass');

notch = [59.0, 61.0];
[b2, a2] = butter(2,notch/(fs_Hz / 2.0), 'stop');

%Buffers
little_buff = zeros(1,10);
display_buff = zeros(1,5000);
display_buff_filt = zeros(1,5000);
cont = 1;

%Audios
labels = {'Awake','Stage 1','Stage 2','Stage 3','REM','Detecting...'};
audios = ["Binaural1.wav","Binaural2.wav","Binaural3.wav","Binaural4.wav"];
audios = char(audios);

%Initialize vars
font =  'Oswald';
clase_asign = 6;
enable = 0;
g = 1;
str = '#21A19F';
color = sscanf(str(2:end),'%2x%2x%2x',[1 3])/255;
cont2 = 0;
cont3 = 0;
u = 0;
%% Graph
h = figure('Name','Sleep Simulator','NumberTitle','off','Color','w', 'Menu','none'); clf;
set(gcf, 'Position', get(0, 'Screensize'));
x = linspace(1,5000,5000);

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
    
    if cont == 10
        enable = true; 
        cont = 1;
        cont2 = cont2 + 1;
        display_buff = AppendandShift(display_buff,little_buff);
        display_buff_filt = filter(b2,a2,display_buff);
        display_buff_filt = filter(b,a,display_buff_filt);

        subplot(2,1,1);
        c = line(x,display_buff_filt(1,:),'Color',color);
        xlim([2000 5000]);
        ylim([-200 200]);
        title('EEG','Color','k')
        xlabel("Samples")
        ylabel('Amplitude (uV)','Color','k')
       
        subplot(2,1,2);
        e = text(0.5, 0.5, labels(clase_asign), 'FontSize',80, 'Color',color, ...
        'HorizontalAlignment','Center', 'VerticalAlignment','Middle','FontName',font);
        axis off
           
        pause(0.019);
        g = ishandle(c);
        delete(c);
        delete(e);
        
        if (mod(cont2,300) == 0)
            Input_Net = feature_ext(display_buff_filt(2000:5000));
            out = net(Input_Net);
            [~, clase_asign] = max(out,[],1);
            cont3 = cont3 +1;
            if (clase_asign < 5)
                playbinaural(audios(:,:,clase_asign));
            end
        end
          
    else 
        cont = cont + 1; 
    end
    
    if cont > 2 && g == 0 && enable == 1
        break;
    end
%     
    % and display it
    fprintf('%.2f\t',vec);
    fprintf('%.5f\n',ts);
end