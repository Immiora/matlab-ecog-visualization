# matlab-esurface-visualization
Toolbox for visualizing ECoG electrodes on brain surface. In our examples we use lectrode localization output from [Hermes et al., 2010](https://www.sciencedirect.com/science/article/pii/S0165027009005408) ([Git](https://github.com/dorahermes/Paper_Hermes_2010_JNeuroMeth)) and [Branco et al., 2018](https://www.sciencedirect.com/science/article/pii/S0165027017303783)

fMRI t-map projections are done using toolbox by [Dora Hermes](https://scholar.google.com/citations?user=d33Z2KEAAAAJ&hl=en).

![fmri-ecog-overlap](https://github.com/Immiora/matlab-esurface-visualization/blob/master/examples/vis0.png?raw=true)

```
load('mean_MNI_mesh_cortex.mat')
load('fmri_t-map.mat')
load('electrodes.mat')
load('ecog_r-map.mat')
eb_visualizer(surface, fmri_tmap, electrodes, ecog_rmap)
```
# see alternatives:
- [ ] [iELVis: An open source MATLAB toolbox for localizing and visualizing human intracranial electrode data](https://www.sciencedirect.com/science/article/pii/S0165027017300365?via%3Dihub)
- [ ] [NeuralAct: A Tool to Visualize Electrocortical (ECoG) Activity on a Three-Dimensional Model of the Cortex](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5580037/)
- [ ] [FieldTrip](http://www.fieldtriptoolbox.org/tutorial/human_ecog/)
- [ ] [Electrode Localization Toolbox by Hugh Wang](https://github.com/HughWXY/ntools_elec)
- [ ] [Electrocorticography / intracranial EEG visualizer by Matthew Davidson](https://www.mathworks.com/matlabcentral/fileexchange/35496-electrocorticography-intracranial-eeg-visualizer)
