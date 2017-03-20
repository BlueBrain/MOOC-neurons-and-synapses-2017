"""Plot gradex results"""

import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D  # noqa

import numpy
import scipy.spatial as sp


import json
with open('results.json') as json_file:
    results = json.load(json_file)

gnabars = numpy.array([result['params']['gnabar_hh'] for result in results])
gkbars = numpy.array([result['params']['gkbar_hh'] for result in results])
gls = numpy.array([result['params']['gl_hh'] for result in results])
st1sc = [result['scores']['step1.Spikecount'] for result in results]
st2sc = [result['scores']['step2.Spikecount'] for result in results]
st3ssv = [result['scores']['step3.steady_state_voltage_stimend']
          for result in results]

for c_label, c_axis in [('Step1 spikecount', st1sc), ('Step2 spikecount', st2sc), ('Step3 steady state voltage', st3ssv)]:
    c_axis = numpy.array([0 if x < 3 else 1 for x in c_axis])
    gnabars_good = gnabars[numpy.where(c_axis == 0)]
    gkbars_good = gkbars[numpy.where(c_axis == 0)]
    gls_good = gls[numpy.where(c_axis == 0)]

    verts = numpy.array(zip(gnabars_good, gkbars_good, gls_good))
    edges = list(zip(verts))

    hull = sp.ConvexHull(verts)
    print hull

    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')

    # print hull.simplices
    # simpl = verts[hull.simplices, :]
    # print simpl
    # ax.plot_trisurf(simpl[:, 0], simpl[:, 1], simpl[:, 2])

    for i in hull.simplices:
        print verts[i, 0],  verts[i, 1]
        ax.plot(verts[i, 0], verts[i, 1], verts[i, 2], 'r-')
        # ax.plot(verts[i, 0], verts[i, 1], verts[i, 2], 'r-')

    # ax.plot(edges[0],edges[1],edges[2],'bo')

    plt.show()

    '''

    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    scat = ax.scatter(gnabars, gkbars, gls, c=c_axis, marker='o')
    ax.set_xlabel('g_na')
    ax.set_ylabel('g_k')
    ax.set_zlabel('g_leak')
    fig.colorbar(scat, label='%s: 0 is good, 1 is bad' % c_label)
    plt.show()

    '''
'''

for x, y in ((gnabars, gkbars), (gnabars, gls), (gkbars, gls)):
    for c_axis, marker in ((st1sc, 'o'), (st2sc, 'x'), (st3ssv, '^')):
        fig = plt.figure()
        ax = fig.add_subplot(111)
        scat = ax.scatter(x, y, c=c_axis, marker=marker)
        fig.colorbar(scat)
    plt.show()
'''
