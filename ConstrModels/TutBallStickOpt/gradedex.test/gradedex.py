# %matplotlib inline
import numpy
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
# %load_ext autoreload
#%autoreload


# import bluepyopt as bpop
import bluepyopt.ephys as ephys

morph = ephys.morphologies.NrnFileMorphology('ballandstick.swc')

somatic_loc = ephys.locations.NrnSeclistLocation(
    'somatic',
    seclist_name='somatic')
basal_loc = ephys.locations.NrnSeclistLocation('basal', seclist_name='basal')

hh_mech = ephys.mechanisms.NrnMODMechanism(
    name='hh',
    suffix='hh',
    locations=[somatic_loc])

cm_param = ephys.parameters.NrnSectionParameter(
    name='cm',
    param_name='cm',
    value=1.0,
    locations=[somatic_loc],
    frozen=True)

gnabar_bounds = [0.05, 0.125]
gnabar_param = ephys.parameters.NrnSectionParameter(
    name='gnabar_hh',
    param_name='gnabar_hh',
    locations=[somatic_loc],
    bounds=gnabar_bounds,
    frozen=False)

gkbar_bounds = [0.01, 0.05]
gkbar_param = ephys.parameters.NrnSectionParameter(
    name='gkbar_hh',
    param_name='gkbar_hh',
    bounds=gkbar_bounds,
    locations=[somatic_loc],
    frozen=False)

gl_bounds = [1e-4, 5e-4]
gl_param = ephys.parameters.NrnSectionParameter(
    name='gl_hh',
    param_name='gl_hh',
    bounds=gl_bounds,
    locations=[somatic_loc],
    frozen=False)

ballandstick_cell = ephys.models.CellModel(
    name='simple_cell',
    morph=morph,
    mechs=[hh_mech],
    params=[cm_param, gnabar_param, gkbar_param, gl_param])

soma_loc = ephys.locations.NrnSeclistCompLocation(
    name='soma',
    seclist_name='somatic',
    sec_index=0,
    comp_x=0.5)

nrn = ephys.simulators.NrnSimulator()

sweep_protocols = []
for protocol_name, amplitude in [('step1', 0.1), ('step2', 0.5), ('step3', -0.3)]:
    stim = ephys.stimuli.NrnSquarePulse(
        step_amplitude=amplitude,
        step_delay=100,
        step_duration=50,
        location=soma_loc,
        total_duration=200)
    rec = ephys.recordings.CompRecording(
        name='%s.soma.v' % protocol_name,
        location=soma_loc,
        variable='v')
    protocol = ephys.protocols.SweepProtocol(protocol_name, [stim], [rec])
    sweep_protocols.append(protocol)
twostep_protocol = ephys.protocols.SequenceProtocol(
    'twostep',
    protocols=sweep_protocols)


def plot_responses(responses):
    plt.subplot(3, 1, 1)
    plt.plot(
        responses['step1.soma.v']['time'],
        responses['step1.soma.v']['voltage'],
        label='step1')
    plt.subplot(3, 1, 2)
    plt.plot(
        responses['step2.soma.v']['time'],
        responses['step2.soma.v']['voltage'],
        label='step2')
    plt.subplot(3, 1, 3)
    plt.plot(
        responses['step3.soma.v']['time'],
        responses['step3.soma.v']['voltage'],
        label='step3')
    plt.legend()
    plt.tight_layout()

default_params = {'gnabar_hh': 0.1, 'gkbar_hh': 0.03, 'gl_hh': 0.0002}
responses = twostep_protocol.run(
    cell_model=ballandstick_cell,
    param_values=default_params,
    sim=nrn)
# plot_responses(responses)

efel_feature_means = {
    'step1': {
        'Spikecount': 1}, 'step2': {
        'Spikecount': 5}, 'step3': {
        'steady_state_voltage_stimend': -100}}
# efel_feature_means = {'step1': {'AP_width': 1.3}, 'step2':
# {'AP_width': 1.6}} # solution
objectives = []
features = []

for protocol in sweep_protocols:
    stim_start = protocol.stimuli[0].step_delay
    stim_end = stim_start + protocol.stimuli[0].step_duration
    for efel_feature_name, mean in efel_feature_means[protocol.name].items():
        feature_name = '%s.%s' % (protocol.name, efel_feature_name)
        feature = ephys.efeatures.eFELFeature(
            feature_name,
            efel_feature_name=efel_feature_name,
            recording_names={'': '%s.soma.v' % protocol.name},
            stim_start=stim_start,
            stim_end=stim_end,
            exp_mean=mean,
            exp_std=0.05 * abs(mean))
        features.append(feature)
        objective = ephys.objectives.SingletonObjective(
            feature_name,
            feature)
        objectives.append(objective)

score_calc = ephys.objectivescalculators.ObjectivesCalculator(objectives)

cell_evaluator = ephys.evaluators.CellEvaluator(
    cell_model=ballandstick_cell,
    param_names=['gnabar_hh', 'gkbar_hh', 'gl_hh'],
    fitness_protocols={twostep_protocol.name: twostep_protocol},
    fitness_calculator=score_calc,
    sim=nrn)

mesh_size = 5

results = []
for gnabar in numpy.linspace(gnabar_bounds[0], gnabar_bounds[1], mesh_size):
    for gkbar in numpy.linspace(gkbar_bounds[0], gkbar_bounds[1], mesh_size):
        for gl in numpy.linspace(gl_bounds[0], gl_bounds[1], mesh_size):
            params = {'gnabar_hh': gnabar, 'gkbar_hh': gkbar, 'gl_hh': gl}
            scores = cell_evaluator.evaluate_with_dicts(params)
            print scores
            results.append({'params': params, 'scores': scores})

import json
with open('results.json', 'w') as json_file:
    json.dump(
        results,
        json_file,
        sort_keys=True,
        indent=4,
        separators=(
            ',',
            ': '))

gnabars = [result['params']['gnabar_hh'] for result in results]
gkbars = [result['params']['gkbar_hh'] for result in results]
gls = [result['params']['gl_hh'] for result in results]
st1sc = [result['scores']['step1.Spikecount'] for result in results]
st2sc = [result['scores']['step2.Spikecount'] for result in results]
st3ssv = [result['scores']['step3.steady_state_voltage_stimend']
          for result in results]


fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.scatter(gnabars, gkbars, gls, c=st3ssv, marker='o')
plt.show()


'''
optimisation_algorithm = bpop.deapext.optimisations.IBEADEAPOptimisation(
    evaluator=cell_evaluator,
    offspring_size=10)

final_pop, hall_of_fame, logs, hist = optimisation_algorithm.run(
    max_ngen=10)

best_ind_dict = cell_evaluator.param_dict(hall_of_fame[0])
print('Best individual: ', best_ind_dict)
print('Score: ', cell_evaluator.evaluate_with_dicts(best_ind_dict))

plot_responses(
    twostep_protocol.run(
        cell_model=ballandstick_cell,
        param_values=best_ind_dict,
        sim=nrn))
'''
