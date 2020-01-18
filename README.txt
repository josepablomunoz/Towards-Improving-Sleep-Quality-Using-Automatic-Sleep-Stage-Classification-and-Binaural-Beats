If you have read "Towards-Improving-Sleep-Quality-Using-Automatic-Sleep-Stage-Classification-and-Binaural-Beats"
and want to understand more of what was done in this proyect please follow the following instructions:

1. There are two simulations available: DataBase_Simulation and Real_Time_Simulation, watch both mp4 to fully understand 
what is described in the article.

2. If you want to run the simulation in your computer do the following:

For the DataBase_Simulation download and extract the DataBase_Simulation.zip file. You must also download, Neural_Network.m, 
Ext_caract_4ch_32.m and ZC_v2.m. Make you sure all of these files are in the MATLAB path. 
The file you must run is Simulacion_Base_Datos.m. However you will still need the PhysioNet recordings for it to work, in this 
case data_5.zip already contains the .mat file from the recording SC4021E0. Download it and extract it for a quick demonstration.
If you want to try different recordings follow the guidelines in the following work DOI: 10.1109/EMBC.2015.7319762
The simulation has two options, the first one is to run the simulation with a new neural network or with anexisting one 
The second one is if you want to run the simulation with a prepared input vector to make the simulation shorter
with specific epochs. If you want to change what epochs form part of this vector, go to the bottom part of the 
code Ext_caract_4ch_32.m. 

For the Real_Time_Simulation download and extract Real_Time_Simulation.zip. You must run the file named SimulaciónFinalCyton.m and 
the LSL.py  file in the Python folder. 
 
