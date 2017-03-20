import os

import efel


meanfrequency1_url = 'file://%s/mean_frequency_1.txt' % os.path.abspath(
    os.path.dirname(__file__))

time = efel.io.load_fragment(
    '%s#col=1' %
    meanfrequency1_url)
voltage = efel.io.load_fragment(
    '%s#col=2' %
    meanfrequency1_url)

trace = {}
trace['T'] = time
trace['V'] = voltage
trace['stim_start'] = [700]
trace['stim_end'] = [2700]

feature_names = ['mean_frequency', 'AP_amplitude', 'AP_width']


print efel.getFeatureValues([trace], feature_names)
meanfrequency1_url


