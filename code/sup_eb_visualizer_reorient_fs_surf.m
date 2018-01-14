function [faces, new_verts, curv] = sup_eb_visualizer_reorient_fs_surf(fsdir, surfname, hemi)
% fsdir = '/home/julia/Documents/chill/data/anatomies/surf_recon/07_habe';
% surfname = 'pial';
% hemi = 'lh';
%

if exist('MRIread', 'file') == 0, 
    addpath(genpath('/usr/local/freesurfer/matlab'))
end

%% surface
surffile = [fsdir, '/surf/', hemi, '.', surfname];
vol      = MRIread([fsdir, '/mri/orig.mgz']);
torig    = vol.tkrvox2ras;
norig    = vol.vox2ras0;

[vertex_coords, faces] = read_surf(surffile);
new_verts              = zeros(4, length(vertex_coords));

for i = 1:length(vertex_coords)
    new_verts(:, i) = norig/torig*[vertex_coords(i, :) 1]';
end

new_verts = new_verts';
new_verts = new_verts(:, 1:3);
faces     = faces(:, [1 3 2]) + 1;

%% curvature
curv      = read_curv(strrep(surffile, surfname, 'curv'));
% curv(curv > 0) = 0.8;
% curv(curv < 0) = 0.4;

end

