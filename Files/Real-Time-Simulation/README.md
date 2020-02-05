For the DataBase_Simulation download all the files in this folder and make sure all of them are in the MATLAB path.  
Then run Database_Simulation.m

To run the simulation the PhysioNet database is needed: https://alpha.physionet.org/content/sleep-edfx/1.0.0/. The file named data_5.zip 
contains the .mat file from the recording SC4021E0. Download it and extract it for a quick demonstration. If you want to try different 
recordings follow the guidelines in the following work DOI: 10.1109/EMBC.2015.7319762

The simulation has the option to run with a test input vector. If you want to change what epochs make up this vector
go to the bottom part of the code Ext_caract_4ch_13.m.

All the binaural beats have a central frequency of 250 Hz
Binaural1: 8 Hz binaraul beat
Binaural2: 6 Hz binaraul beat
Binaural3: 4 Hz binaraul beat
Binaural4: 2 Hz binaraul beat
