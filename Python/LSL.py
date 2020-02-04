# -*- coding: utf-8 -*-
"""
Created on Wed Nov 27 22:26:57 2019

@author: MAX AOKLAND
"""

# -*- coding: utf-8 -*-
"""
Created on Sun Jun 16 19:24:15 2019

@author: José Pablo Muñoz
"""
"""
*Lectura de datos crudos con nueva librería de OpenBCI
*Se recomienda imlementar este código si se quiere seguir utilizando Python
*Para aplicaciones con la Cyton Board 
"""

from pyOpenBCI import OpenBCICyton
from pylsl import StreamInfo, StreamOutlet
import numpy as np
import time 

Vref = 4.5
gain = 24
scale_factor = Vref *1000000 / (gain * ((2 ** 23) - 1))
SCALE_FACTOR_AUX = 0.002 / (2**4)


print("Creating LSL stream for EEG. \nName: OpenBCIEEG\nID: OpenBCItestEEG\n")

info_eeg = StreamInfo('OpenBCIEEG', 'EEG', 8, 250, 'float32', 'OpenBCItestEEG')

print("Creating LSL stream for AUX. \nName: OpenBCIAUX\nID: OpenBCItestEEG\n")

info_aux = StreamInfo('OpenBCIAUX', 'AUX', 3, 250, 'float32', 'OpenBCItestAUX')

outlet_eeg = StreamOutlet(info_eeg)
outlet_aux = StreamOutlet(info_aux)


def lsl_streamers(sample):
    
    outlet_eeg.push_sample(np.array(sample.channels_data)*scale_factor)
    outlet_aux.push_sample(np.array(sample.aux_data)*SCALE_FACTOR_AUX)

board = OpenBCICyton(port='COM3', daisy=False)


while(True):
    try:
        board.start_stream(lsl_streamers)
    except:
        board.stop_stream()
        time.sleep(0.5)
        board.disconnect()
        break
