# matlab-esurface-visualization
Toolbox for visualizing ECoG electrodes on brain surface. In our examples we use lectrode localization output from [Hermes et al., 2010](https://www.sciencedirect.com/science/article/pii/S0165027009005408) ([Git](https://github.com/dorahermes/Paper_Hermes_2010_JNeuroMeth)) and [Branco et al., 2018](https://www.sciencedirect.com/science/article/pii/S0165027017303783)

fMRI t-map projections are done using toolbox by 

Uses [newcolorbar](https://nl.mathworks.com/matlabcentral/fileexchange/52505-newcolorbar--multiple-colormaps-in-the-same-axes?focused=3893317&tab=function&requestedDomain=true )

```
load('mean_MNI_mesh_cortex.mat')
load('electrodes.mat')
eb_visualizer(surface, [], electrodes)
```

# see alternatives:
- [ ] [iELVis: An open source MATLAB toolbox for localizing and visualizing human intracranial electrode data](https://www.sciencedirect.com/science/article/pii/S0165027017300365?via%3Dihub)
- [ ] [NeuralAct: A Tool to Visualize Electrocortical (ECoG) Activity on a Three-Dimensional Model of the Cortex](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5580037/)
- [ ] [FieldTrip](http://www.fieldtriptoolbox.org/tutorial/human_ecog/)
- [ ] [Electrode Localization Toolbox by Hugh Wang](https://github.com/HughWXY/ntools_elec)
- [ ] [Electrocorticography / intracranial EEG visualizer by Matthew Davidson](https://www.mathworks.com/matlabcentral/fileexchange/35496-electrocorticography-intracranial-eeg-visualizer)
