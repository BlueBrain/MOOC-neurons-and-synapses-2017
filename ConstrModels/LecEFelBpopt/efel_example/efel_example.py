import os

import efel


meanfrequency1_url = 'file://%s/C14010092-MT-C1.V.50.1.txt' % os.path.abspath(
    os.path.dirname(__file__))


time = efel.io.load_fragment(
    '%s#col=1' %
    meanfrequency1_url)
voltage = efel.io.load_fragment(
    '%s#col=2' %
    meanfrequency1_url)

import matplotlib.pyplot as plt
plt.plot(time, voltage)
plt.xlabel('Time (ms)')
plt.ylabel('Membrane voltage (mV)')
plt.show()

trace = {}
trace['T'] = time
trace['V'] = voltage
trace['stim_start'] = [700]
trace['stim_end'] = [2700]

feature_names = ['mean_frequency', 'AP_amplitude', 'AP_width']


print efel.getFeatureValues([trace], feature_names)
meanfrequency1_url


