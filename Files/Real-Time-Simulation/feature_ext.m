% -------------------------------------------------------------------------
% Autor: José Pablo Muñoz 
% Descripción: Función para extraer características en tiempo real para la
% simulación 
% -------------------------------------------------------------------------
function Input_Net = feature_ext(Raw)
  feat = 2; 
  Input_Net = zeros(feat,1);

  
  Input_Net(1,1) = mean(abs(Raw(:,1)));
  Input_Net(2,1) = ZC_v2(Raw(:,1),0.01);
