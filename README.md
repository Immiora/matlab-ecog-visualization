# matlab-esurface-visualization
Toolbox for visualizing ECoG electrodes on brain surface

Uses [newcolorbar](https://nl.mathworks.com/matlabcentral/fileexchange/52505-newcolorbar--multiple-colormaps-in-the-same-axes?focused=3893317&tab=function&requestedDomain=true )

```
load('mean_MNI_mesh_cortex.mat')
load('electrodes.mat')
eb_visualizer(surface, [], electrodes)
```
