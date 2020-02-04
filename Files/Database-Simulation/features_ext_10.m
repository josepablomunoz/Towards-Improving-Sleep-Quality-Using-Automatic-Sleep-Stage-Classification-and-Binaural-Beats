% -------------------------------------------------------------------------
% Autor: José Pablo Muñoz 
% Descripción: Función para extraer características en tiempo real para la
% simulación 
% -------------------------------------------------------------------------
function Input_Net = features_ext_10(Live_Raw)
  L = 3000;
  feat = 10; 
  Input_Net = zeros(feat,1);
  cont = 0;
  
for c = 1:4
    if (c < 4)
        Input_Net(c + 2*cont) = mean(abs(Live_Raw(1:L,c)));
        Input_Net(2*c + cont) = ZC_v2(Live_Raw(1:L,c),0.01);
        Input_Net(3*c) = MMD(Live_Raw(1:L,c));
        cont = cont + 1;
    else
        Input_Net(10) = mean(abs(Live_Raw(1,c)));  
    end 
end
    