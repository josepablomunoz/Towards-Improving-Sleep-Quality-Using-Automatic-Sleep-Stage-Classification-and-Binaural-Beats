% -------------------------------------------------------------------------
% Autor: Jos� Pablo Mu�oz 
% Descripci�n: Funci�n para extraer caracter�sticas en tiempo real para la
% simulaci�n 
% -------------------------------------------------------------------------
function Input_Net = feature_ext(Raw)
  feat = 2; 
  Input_Net = zeros(feat,1);

  
  Input_Net(1,1) = mean(abs(Raw(:,1)));
  Input_Net(2,1) = ZC_v2(Raw(:,1),0.01);
