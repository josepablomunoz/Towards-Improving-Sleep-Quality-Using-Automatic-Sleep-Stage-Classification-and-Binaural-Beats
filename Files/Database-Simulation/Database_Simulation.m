% -------------------------------------------------------------------------
% Autor: José Pablo Muñoz 
% Descripción: Simulación final que clasifica los datos de las grabaciones
% en tiempo real
% -------------------------------------------------------------------------

%% Opciones de simulación

run_new = 1; % 1 para simular con una nueva red, 0 para simular con red existente
prepared_vector = 1; %1 para simular con un vector preparado, 0 para simular convencionalmente

%% Prepare data
if run_new == 1 
    load('data_5')
    run Ext_caract_4ch_13.m
    run Neural_Network.m
end

if prepared_vector == 1
    fpz = muestra{1,1};
    pz = muestra{2,1};
    eog = muestra{3,1};
    emg = muestra{4,1};
    hypnogram = muestra_hypno;
end

%% Start simulation
labels = {'Awake','Stage 1','Stage 2','Stage 3','REM','Detecting...'};
audios = ["Binaural1.wav","Binaural2.wav","Binaural3.wav","Binaural4.wav"];
audios = char(audios);
execution = true;
little_buf = zeros(3000,4);
x = linspace(1,3000,3000);
clase_asign = 6;
clase_real = 6;
font =  'Oswald';

h = figure('Name','Sleep Simulator','NumberTitle','off','Color','w', 'Menu','none'); clf;
set(gcf, 'Position', get(0, 'Screensize'));
hold on;
grid

pointPerUpt = 50; %Velocidad de simulación

str = '#21A19F';
color = sscanf(str(2:end),'%2x%2x%2x',[1 3])/255;
cont = 0;
msg =  sprintf('Sleep \nSimulation');

m = text(0.5, 0.5, msg, 'FontSize',90, 'Color',color, ...
    'HorizontalAlignment','Center', 'VerticalAlignment','Middle','FontName',font);
    axis off
pause(2);
delete(m);

n = text(0.47, 0.5,'Starting', 'FontSize',90, 'Color',color, ...
    'HorizontalAlignment','Center', 'VerticalAlignment','Middle','FontName',font);
    axis off
pause(2);
delete(n);

display_accuracy = num2str(accuracy);
porcentage = strcat(display_accuracy,'%');
p = circle(0.4,0.45,0.6);

c = text(0.45,0.45,porcentage, 'FontSize',130, 'Color',color, ...
    'HorizontalAlignment','Center', 'VerticalAlignment','Middle','FontName',font);
    axis off

g = text(0.40, 1.2,'Network Accuracy', 'FontSize',60, 'Color',color, ...
    'HorizontalAlignment','Center', 'VerticalAlignment','Middle','FontName',font);
    axis off
    
pause(3);


for i = 1:(3000/pointPerUpt)*10000
    
    if i > ((3000/pointPerUpt)*10)+59 && prepared_vector == 1
        delete(h);
        break;
    end 
    
    little_buf(3000-pointPerUpt+1:3000) = fpz(((i-1)*pointPerUpt+1):i*pointPerUpt);
    little_buf(3000-pointPerUpt+1:3000,2) = pz(((i-1)*pointPerUpt+1):i*pointPerUpt);
    little_buf(3000-pointPerUpt+1:3000,3) = eog(((i-1)*pointPerUpt+1):i*pointPerUpt);
    little_buf(3000-pointPerUpt+1:3000,4) = emg(((i-1)*pointPerUpt+1):i*pointPerUpt);
    
    subplot(3,2,1);
    a = line(x,little_buf(:,1),'Color',color);
    xlim([0 3000]);
    ylim([-200 200]);
    title('EEG Fpz-Cz','Color','k')
    xlabel("Time (s)"+newline+"   ")
    xticklabels({'0' '5' '10' '15' '20' '25' '30'});
    ylabel('Amplitude (uV)','Color','k')

    subplot(3,2,2);
    d = line(x,little_buf(:,2),'Color',color);
    xlim([0 3000]);
    ylim([-200 200]);
    title('EEG Pz-Oz','Color','k')
    xlabel('Time (s)','Color','k')
    xticklabels({'0' '5' '10' '15' '20' '25' '30'});
    ylabel('Amplitude (uV)','Color','k')
  
    subplot(3,2,3);
    e = line(x,little_buf(:,3),'Color',color);
    xlim([0 3000]);
    ylim([-400 400]);
    title('EOG Horizontal','Color','k')
    xlabel('Time (s)','Color','k')
    xticklabels({'0' '5' '10' '15' '20' '25' '30'});
    ylabel('Amplitude (uV)','Color','k')
    
    subplot(3,2,4);
    f = line(x,little_buf(:,4),'Color',color);
    xlim([0 3000]);
    ylim([0 5]);
    
    title('EMG Submental','Color','k')
    xlabel('Time (s)','Color','k')
    xticklabels({'0' '5' '10' '15' '20' '25' '30'});
    ylabel('Amplitude (uV)','Color','k')
    drawnow limitrate;
   
    b = ishghandle(a);
    delete(a);
    delete(c);
    delete(d);
    delete(e);
    delete(f);
    delete(g);
    delete(m);
    delete(n);
    delete(p);
   
    if (mod(i,3000/pointPerUpt) ~= 0)
        little_buf = circshift(little_buf,-pointPerUpt);
        
    elseif (mod(i,3000/pointPerUpt) == 0)
        
        cont = cont + 1;
        %Input_Net = features_ext_21(little_buf);
        Input_Net = features_ext_10(little_buf); 
        little_buf = circshift(little_buf,-pointPerUpt);
        out = net(Input_Net);
        [~, clase_asign] = max(out,[],1);
        
        if hypnogram(cont) == 'W'
            clase_real = 1;
        elseif hypnogram(cont) == '1' 
            clase_real = 2;
        elseif hypnogram(cont) == '2' 
            clase_real = 3;
        elseif hypnogram(cont) == '3' 
           clase_real = 4;  
        elseif hypnogram(cont) == 'R' 
           clase_real = 5;    
        end
        
        if (clase_asign < 5)
             playbinaural(audios(:,:,clase_asign));
        end

    end
    
    if ~b
        break
    end
   
    subplot(3,2,5);
    c = text(0.5, 0.5, labels(clase_real), 'FontSize',75, 'Color',color, ...
    'HorizontalAlignment','Center', 'VerticalAlignment','Middle','FontName',font);
    axis off
   
    g = text(0.5, 1.0, 'Real Stage:', 'FontSize',20, 'Color','k', ...
    'HorizontalAlignment','Center', 'VerticalAlignment','Middle','FontName',font);
    axis off

    subplot(3,2,6);
    m = text(0.5, 0.5, labels(clase_asign), 'FontSize',75, 'Color',color, ...
    'HorizontalAlignment','Center', 'VerticalAlignment','Middle','FontName',font);
    axis off
   
    n = text(0.5, 1.0, 'Prediction:', 'FontSize',20, 'Color','k', ...
    'HorizontalAlignment','Center', 'VerticalAlignment','Middle','FontName',font);
    axis off
     
    cont_tostring = num2str(cont);
    msg = 'Epoch Count: ';
    epoch_count = strcat(msg,cont_tostring);
                   
    p = text(-0.15, -0.1, epoch_count, 'FontSize',20, 'Color',color, ...
    'HorizontalAlignment','Center', 'VerticalAlignment','Middle','FontName',font);
    axis off
  
end


 