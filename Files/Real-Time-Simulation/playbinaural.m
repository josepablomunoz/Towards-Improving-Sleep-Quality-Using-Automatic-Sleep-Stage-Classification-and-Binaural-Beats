% -------------------------------------------------------------------------
% Autor: Jos� Pablo Mu�oz 
% Descripci�n: Funci�n para reproducir pulsos binaurales 
% -------------------------------------------------------------------------
function playbinaural(x)

[y,fs] = audioread(x);
soundsc(y,fs);


