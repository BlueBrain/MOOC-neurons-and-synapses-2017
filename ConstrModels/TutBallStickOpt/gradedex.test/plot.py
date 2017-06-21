"""Plot gradex results"""

import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D  # noqa

import json
with open('results.json') as json_file:
    results = json.load(json_file)

gnabars = [result['params']['gnabar_hh'] for result in results]
gkbars = [result['params']['gkbar_hh'] for result in results]
gls = [result['params']['gl_hh'] for result in results]
st1sc = [result['scores']['step1.Spikecount'] for result in results]
st2sc = [result['scores']['step2.Spikecount'] for result in results]
st3ssv = [result['scores']['step3.steady_state_voltage_stimend']
          for result in results]

for c_label, c_axis in [('Step1 spikecount', st1sc), ('Step2 spikecount', st2sc), ('Step3 steady state voltage', st3ssv)]:
    c_axis = [0 if x < 3 else 1 for x in c_axis]
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    scat = ax.scatter(gnabars, gkbars, gls, c=c_axis, marker='o')
    ax.set_xlabel('g_na')
    ax.set_ylabel('g_k')
    ax.set_zlabel('g_leak')
    fig.colorbar(scat, label='%s: 0 is good, 1 is bad' % c_label)
    plt.show()
'''

for x, y in ((gnabars, gkbars), (gnabars, gls), (gkbars, gls)):
    for c_axis, marker in ((st1sc, 'o'), (st2sc, 'x'), (st3ssv, '^')):
        fig = plt.figure()
        ax = fig.add_subplot(111)
        scat = ax.scatter(x, y, c=c_axis, marker=marker)
        fig.colorbar(scat)
    plt.show()
'''
