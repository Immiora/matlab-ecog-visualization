function VM = sup_eb_visualizer_plot_make_fun_overlay(C, V, opts)
% Function create a CData overlay for faces and vertices of brain mesh
% based on curvature (C) and functional map (V) in both hemisheres.
% Output is a cell VM, which contains CData for both hemisheres.
%
% Defaults: 
%           [0.4, 0.8] for curvature contrast
%           modified jet colormap
%           [-3 3] threshold in functional overlay
%           [-8 8] range for colormap 
%           'custom_hot' or 'custom_jet' colormap

if nargin < 3, opts = struct; end


if size(C, 2) > 1 && size(V, 2) > 1,
    curv = vertcat(C{:}); 
    vol = vertcat(V{:});
    size_ori = cell2mat(cellfun(@(x)size(x, 1), C, 'un', 0));
else
    curv = C{1};
    vol = V{1};
end

if ~isfield(opts, 'curv_colors'), opts.curv_colors = [0.4 0.8]; end
if ~isfield(opts, 'thresh_vol'), opts.thresh_vol = [0 0]; end
if ~isfield(opts, 'data_range'), opts.data_range = [min(vol) max(vol)]; end
if ~isfield(opts, 'cmap'), opts.cmap = 'custom_hot'; end % custom_jet

curv_colors = opts.curv_colors;
thresh_vol  = opts.thresh_map;
data_range  = opts.data_range;
cmap        = opts.cmap;

curv(curv > 0) = curv_colors(2);
curv(curv < 0) = curv_colors(1);

v = curv;
t1 = thresh_vol(2); t2 = thresh_vol(1);
v(vol > t1 | vol < t2) = vol(vol > t1 | vol < t2);

% add curvature
vol_map = zeros(length(v), 3);
temp = size(vol_map(v == 0, :), 1);
vol_map(v == 0, :) = repmat(curv_colors(2), temp, 3);
temp = size(vol_map(v == curv_colors(1), :), 1);
vol_map(v == curv_colors(1), :) = repmat(curv_colors(1), temp, 3);
temp = size(vol_map(v == curv_colors(2), :), 1);
vol_map(v == curv_colors(2), :) = repmat(curv_colors(2), temp, 3);

% % scale overlay
d = vol(v ~= 0 & v ~= curv_colors(1) & v ~= curv_colors(2));

% data_map = round((d - min(d)) ./ rngM * 63 + 1);
% vol_map_fun = zeros(size(d, 1), 3);
% data_map(data_map > 64) = 64;
% 
% for i =  1:64
%     temp = size(vol_map_fun(data_map == i, :), 1);
%     vol_map_fun(data_map == i, :) = repmat(m(i, :), temp, 1);
% end

cust_cmap = eb_visualizer_make_colormap(cmap, 64);
vol_map_fun = eb_visualizer_x_data2triplets(d, cust_cmap, data_range, thresh_vol, 0.45);
vol_map(v ~= 0 & v ~= curv_colors(1) & v ~= curv_colors(2), :) = vol_map_fun;

% save
if size(C, 2) > 1 && size(V, 2) > 1,
    st = 0;
    for i = 1:size(C, 2)
        en = st + size_ori(i);
        st = st + 1;
        VM{i} = vol_map(st:en, :);
        st = en;
    end
else
    VM{1} = vol_map;
end
