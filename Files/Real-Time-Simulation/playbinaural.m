% -------------------------------------------------------------------------
% Autor: José Pablo Muñoz 
% Descripción: Función para reproducir pulsos binaurales 
% -------------------------------------------------------------------------
function playbinaural(x)

[y,fs] = audioread(x);
soundsc(y,fs);


