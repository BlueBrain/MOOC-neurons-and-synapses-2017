## Registration of single cell electrophysiology and morphology reconstruction into the Blue Brain Nexus Platform using the Provenance Editor

#### Description of the task

One of the greatest challenges in neuroscience is to make the data available to the scientific community using data standards and ontologies to make data searchable and promote its reusability.  The complexity of neuroscience data comes not only from the different scales of the data produced, ranging from single cell to organ, but also from the lack of a consensus in the use and production of data standards and ontologies. 
In this task, we would like that you place yourself into the role of the scientist who wants to submit some of the data produced by the Laboratory of Neural Microcircuitry (LNMC) into the Blue Brain Nexus Platform where it can be shared with other scientists.
You will be provided with a description of the methods that were used to generate electrophysiological traces and a morphology reconstruction from a pyramidal cell of the somatosensory cortex of a rat (see below under ‘Methods section’). This experiment has been carried out to define the morphological and electrical type of the neuron. You will have to register the corresponding data through the Provenance Editor using the domain, ontologies and provenance model that were outlined in the last video lecture of week 2.

#### Instructions

A – Read the methods section
B – Fill in the required information using the Provenance Editor
C – Submit your curated data for grading

#### A – Methods section

**Disclaimer**: The information in this section is derived from the protocols being currently used at LNMC of the EPFL to generate their electrophysiology traces and morphology reconstructions (refs 1-3). The cell ontology used has been directly derived from the work done at the LNMC and Blue Brain Project (ref. 4). 

__Summary__:
In-vitro experiments performed on neurons require the use of a brain sample that is extracted from an animal. In this experiment, the brain slice was obtained from a rat brain. A neuron is chosen in the brain slice to perform electrophysiology and morphology reconstruction experiments. For electrophysiology experiments, an electrode is used to inject current into the neuron to evoke action potentials. These experiments are useful to define the electrical properties of the neuron. The morphology reconstruction experiments require the staining of the neuron, in this protocol biocytin is used for staining. It is used to reveal what form the neuron has, where the soma is located and to characterize the dendritic and axonal arborisation.

__Introduction__:
Pyramidal cells (PCs) are key neurons providing output signals from the neocortex. The superficial cortical layers 2/3 PCs project to the contralateral hemisphere via the corpus callosum while the deeper layer 5 PCs project mainly to subcortical targets. Layer 5 thick tufted PCs (TTPCs) are a subtype of PCs, they have a big soma and a thick apical dendrite forming tuft dendrites in layer 1 and their axons project to the tectum, brainstem and the spinal cord. They are the most extensively studied neuron type in the mammalian neocortex and have become a benchmark for understanding information processing in excitatory neurons. 

__Specimen__:
Male rats of the strain Wistar Han and aged postnatal day 14 (P14) were used for the morphological and electrophysiology analysis of layer 5 TTPC neurons. The output of this study will help us define what the morphology-type and the electrical-type of one neuron is. 

__Protocol: Slice extraction and neuron selection for electrophysiology experiments__ 
After extraction from the rat skull, brains were quickly dissected and sliced into 300 µm-thick coronal slices (HR2 vibratome, Sigmann Elektronik, Germany) in ice-cold artificial cerebrospinal fluid (ACSF), followed by a 15 minute incubation at 34°C in standard ACSF.
Neurons in the slices were visualized using infrared __differential interference contrast microscopy__ (VX55 camera, Till Photonics, Germany and BX51WI microscope, Olympus, Japan) and a neuron was selected for further experiments. 

__Protocol: Electrophysiology recording of single neuron__
__Whole-cell patch__ clamp recordings were performed at 32 +/- 1°C in a standard ACSF solution with an Axon Multiclamp 700B Amplifier (Molecular Devices, USA) using 2 – 10 MOhm borosilicate pipettes, containing (in mM): K+-gluconate 110.00, KCl 10.00, ATP-Mg2+ 4.00, Na2-phosphocreatine 10.00, GTP-Na+ 0.30, HEPES 10.00, biocytin 3.00 mg/ml; pH 7.30, 300 mOsm. The patched neuron was submitted to an __IDRest__ current injection protocol (see fig 1). After analysis of the traces, the electrical type (__e-type__) was determined.

The following file contains the electrophysiology traces that were produced:

| Cell name | Cell e-type | File |
| ------ | ------ | ------ |
| C060109A1-SR | Classical accommodating cell | C060109A1-SR-C1_IDrest.zip

![alt text][logo]

[logo]: http://www.the-scientist.com/Nov2013/foundations.jpg "Example of current and voltage traces"

>_fig 1. Example of current and voltage traces using the IDRest protocol
In the IDRest protocol the experimenter determines a hyperpolarizing offset current to keep the cell at -70 mV (before liquid junction potential correction) and applies this current during the entire protocol. After an initial period of 700 ms, a step current was applied for 2000 ms, and after the step, a final period of 300 ms is recorded. This protocol is repeated with different step currents normalized to the threshold current (i.e. the lowest current that generates one AP during the step) (4)._

__Protocol: Morphological reconstruction of a single cell__

After the electrophysiological recording and overnight fixation of the slice in 2% PFA + 0.3% picric acid + 1% glutaraldehyde, the __biocytin-filled__ neuron was revealed with __3,3′-diaminobenzidine (DAB)__ staining. Next, each cell was reconstructed in 3D under an Olympus BX51W microscope with an oil-immersion 100x (NA 1.35) objective using Neurolucida software (MicroBrightField, Magdeburg, Germany).  The reconstructed neuron underwent quantitative analysis using NeuroExplorer (MicroBrightField). The quantitative morphometric analysis is based on multiple parameters derived from the dendrites and axons of reconstructed neuron. The staining procedure results in ~25% shrinkage of the slice thickness and ~10% anisotropic shrinkage along the x and y axes. After analysis of the morphologies, the morphology type (__m-type__) was determined.

The following file containing the single cell morphology reconstruction was produced:

| Cell name | Cell m-type | File |
| ------ | ------ | ------ |
| C060109A1-SR | Layer V early bifurcating thick tufted pyramidal cell | C060109A1.ASC

![alt text][logo]

[logo]: http://www.the-scientist.com/Nov2013/foundations.jpg "Morphology reconstruction"

>fig 2. Morphology reconstruction of cell C060109A1-SR. Axon is shown in blue, basal dendrites in red and apical dendrites in pink. 

__Contributors:__

Prof. Henry Markram
Role: Principal investigator 
Affiliation: Blue Brain Project, École polytechnique fédérale de Lausanne

Julie Meystre
Role: technical assistant
Contribution: worked on the visualisation of the neuron using differential interference contrast video microscopy and on the cell biocytin staining for morphological cell reconstruction
Affiliation: Laboratory of Neural Microcircuitry, École polytechnique fédérale de Lausanne

Ying Shi
Role: cell morphology reconstruction expert
Contribution: worked on the morphological reconstruction of the neuron
Affiliation: Blue Brain Project, École polytechnique fédérale de Lausanne

Dr. Sandrine Romand
Role: researcher
Contribution: worked on generating the electrophysiological recordings
Affiliation: Laboratory of Neural Microcircuitry,  École polytechnique fédérale de Lausanne

__References:__

1) Le Bé JV, Silberberg G, Wang Y, Markram H. Morphological, electrophysiological, and synaptic properties of corticocallosal pyramidal cells in the neonatal rat neocortex. Cereb Cortex. 2007 Sep;17(9):2204-13. Epub 2006 Nov 23. PubMed PMID: 17124287.
(https://goo.gl/YE9jUU)

2) Ramaswamy S, Markram H. Anatomy and physiology of the thick-tufted layer 5 pyramidal neuron. Frontiers in Cellular Neuroscience. 2015;9:233. doi:10.3389/fncel.2015.00233.
(https://goo.gl/yr3Qm9)

3) De Schutter E, Computational Neuroscience: Realistic Modeling for Experimentalists, 2000 CRC Press, ISBN 9780849320682.

4) Markram H, et al., Reconstruction and Simulation of Neocortical Microcircuitry. Cell. 2015 Oct 8;163(2):456-92. doi: 10.1016/j.cell.2015.09.029. PubMed PMID: 26451489.
(https://goo.gl/o5fpFD)

#### B – Using the Provenance Editor to register your data

##### B.1 Opening the Provenance Editor: To open the editor please follow this link:

 https://bbp-nexus.epfl.ch/dev/provenance-editor/ and login using your HBP credentials (to confirm). 

##### B.2 Template: 
Choose the “Single Neuron, Electrophysiology and Morphology” template and 
follow the instructions below to fill each of the entities’ form.

##### B.3 Status: 
There is a progress status text to the right of the screen that will remain 

![alt text](http://thumbs4.ebaystatic.com/m/mc3ltik5rdlmA4Qt9Nknzrg/140.jpg)

until you have finished filling and saving all the requested information. Once you have finished it will change to:

![alt text](http://www.mmcentras.lt/media/images/ico/success_ticker.png)

##### B.4 Filling the entities’ forms: 
Click on each one of the entities provided (1-7) following the instructions below. To fill the activity (3) you must first fill in the specimen (1) and neuron (2) requested information. To fill the activities (5, 7) you must first fill the datasets (4, 6) respectively. 

##### B.5 ID field: 
The __ID__ field at the top of each of the entities __will be automatically updated__ once you finish filling the required fields and save your work clicking on the ‘SAVE’ button for each of the entities.

![alt text][logo]

[logo]: http://www.the-scientist.com/Nov2013/foundations.jpg "Provenance pattern"

>Fig.3 Provenance for the generation of electrophysiology and morphology experimental information generated from a single neuron.

1) Specimen
Find what is the specimen (the organism) used in this experiment. You will need the following information:
- species that was used and add the official taxonomy description (i.e. rat = Rattus norvegicus)
- strain (variant or subtype) of the specimen
- sex of the specimen
- age of the specimen and the age unit

2) Neuron 
Find the information which describes the neuron that was characterized during the experiment:
- name of the neuron as given by the researcher (cell name)
- morphology and electrical type (also called m-type and e-type).

3) Activity between specimen and neuron
This screen captures the experimental protocol that was used to generate the brain slice and visualize the entity ‘neuron’.
- find the activity type 
- find the protocol corresponding to the generation of the brain slices and the method used for visualization and add them in the “protocol” and “method” fields respectively
- add the contributors and their roles in the “agents” field

4) Electrophysiology dataset
- select the file corresponding to the electrophysiological recording and upload it
- give a meaningful name to your dataset
- find the right category for your dataset
- choose a license considering that we want to allow commercial use of the data.

5) Activity between neuron and electrophysiology dataset
This screen captures the experimental protocol that was used to generate electrophysiology recordings. 
- find the activity type 
- find the protocol corresponding to the generation of the electrophysiology recording and the method used for the recording and add them in the “protocol” and “method” fields respectively
- add the contributors and their roles in the “agents” field
Note: The __IDRest__ current injection protocol is very important and would normally be recordedbut we do not request you to add it in this activity.

6) Morphology reconstruction dataset
- select the file corresponding to the morphology reconstruction and upload it
- give a meaningful name to your dataset
- find the right category for your dataset
- Choose a license considering that we want to allow commercial use of the data.


7) Activity between neuron and morphology reconstruction dataset
This screen captures the experimental protocol that was used to generate the single cell morphology reconstruction.
- find the activity type 
- find the protocol corresponding to the generation of the single cell morphology reconstruction and the method used for visualization and add them in the “protocol” and “method” fields respectively
- add the contributors and their roles in the “agents” field

#### C - Submitting your curated data for grading

Once you have finished filling and saving all the fields the progress status will change to 

![alt text](http://www.mmcentras.lt/media/images/ico/success_ticker.png)

This indicates that your data has been saved for grading. 
Please provide the generated specimen ID (you can find it in the ID field at the top of the specimen entity and it will have the following format: __bbp/specimen/1.0.0/<id>__). 

How the grading works: For the grading, the provenance chain will be traversed starting with the specimen. If the chain of provenance is broken at any point (i.e. wrong information is provided), the grading will stop and your score will be returned. The score range is 0 – 1. As the grading starts with the specimen ID please do not forget to provide it. 
