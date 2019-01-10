function eb_visualizer(surface, surface_data, electrodes, electrode_data, opts)
% 
% DESCRIPTION
% Function for plotting ECoG and fMRI results on the cortical mesh. The
% mesh can be standard MNI or the individual cortex output by the
% ctmr/ALICE electrode localization. It can also be loaded from FreeSurfer
% but in this case the necessary RAS to VOL transformations might be
% necessary for the correct display of electrode coordinates or fMRI
% overlays in the volume space (not produced by FreeSurfer).
%
%
% INPUT ARGUMENTS: 
%   surface: structure with fields $tri$ and $vert$, which contain
%   triangles and vertices for dislaying the mesh. This is a standad output
%   format of the ctmr/ALICE elecrtode localization software
%  
%   surface_data: 1d vector of length equal to number of vertices in the
%   surface mesh. 2d matrix with second dim containing color triplets for
%   visualization can be fed in but might exhibit unexpected behavior
%
%   electrode: 2d matrix containing electrode coordinates as standard
%   pit[it of the ctmr/ALICE elecrtode localization software. Thus, these
%   are mm coordinates
%
%   electrode_data: 1d vectore of length equal to number of electrodes. 2d
%   matrix with second dim containing color triplets can be fed in but
%   might exhibit unexpected behavior
%
%   opts: structure with visualization options. All options and their 
%   default values can be looked up by running eb_get_options.m
%
%
% USAGE:
%   eb_visualizer(surface, surface_data, electrodes, electrode_data, opts)
% 
% For surface visualization:
%   eb_visualizer(surface)
% 
% For electrode localization visualization:
%   eb_visualizer(surface, [], electrodes)
%
% For fMRI/angiogram/other whole_brain visualization:
%   eb_visualizer(surface, surface_data)
%
% For simple visualization of electrode statistics:
%   eb_visualizer(surface, [], electrodes, electrode_data)
%
% For visualization of electrode statistics interpolated on the cortical
% surface:
%   eb_visualizer(surface, electrode_data, electrodes)
%
% For simultaneous display of electrode statistics and fMRI/angiogram/
% other whole_brain overlay:
%   eb_visualizer(surface, surface_data, electrodes, electrode_data)
%
%
% Typically, the following options should be tailored to the data:
%   show_hemi_default: hemisphere to display (default: 'l')
%   e_data_plot_form: 'color', 'size' or 'size_color' (default: 'color')
%   e_mkr_sise_default: int (default: 10)
%   e_data_cmap: colormap for electrode_data (default: 'hot')
%   e_data_span: min and max values to display in electrode_data (default:
%                               min(electrode_data), max(electrode_data))
%   s_data_cmap: colormap for surface_data (default: 'cold')
%   s_data_span: min and max values to display in surface_data (default:
%                               min(surface_data), max(surface_data))
%   fig_handle: figure handle (default: new figure)
%
%
% All options and their default values can be looked up by calling 
% eb_get_options

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% check input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 1, error('eb_visualizer:input', 'No input was specified'); end
if nargin < 2, surface_data = []; electrodes = []; electrode_data = []; end
if nargin < 3, electrodes = []; electrode_data = []; end
if nargin < 4, electrode_data = []; end
if nargin < 5, opts = struct; end

eb_visualizer_set_defauts(opts);

cp = mfilename('fullpath');
if exist('cbrewer', 'file') == 0
    if exist([cp(1:find(ismember(cp,'/'), 1, 'last')), ...
                                        '_external/cbrewer/'], 'dir') > 0
        addpath(genpath([cp(1:find(ismember(cp,'/'), 1, 'last')), ...
                                                '_external/cbrewer/']))
    else
        error(['External libraries could not be loaded. ', ...
                                'Check contents'' of _external folder'])
    end
end

[plot_surface, plot_electrodes, plot_s_data, plot_e_data] = deal(true);

if ischar(surface),         surface = load_from_file(surface); end
if ischar(electrodes),      surface = load_from_file(electrodes); end
if ischar(surface_data)
    surface_data = load_from_file(surface_data); 
end
if ischar(electrode_data)
    electrode_data = load_from_file(electrode_data); 
end

if isempty(surface),        plot_surface = false; end
if isempty(electrodes),     plot_electrodes = false; end
if isempty(surface_data)  
    plot_s_data = false; s_data_colorbar_show = false; 
end   
if isempty(electrode_data)
    plot_e_data = false; e_data_colorbar_show = false;  
end   

if plot_surface
    try
        faces    = surface.tri;
        vertices = surface.vert;
    catch
        error('ebvis_error:input', ['Surface should be ', ...
                            'a structure with $tri$ and $vert$ fields'])
    end
end

if plot_s_data
    assert(plot_surface, 'ebvis_error:input', ...
            'Cannot plot surface data without surface vertices and faces')
   if size(surface_data, 1) ~= size(vertices, 1)
       if size(surface_data, 2) == size(vertices, 1)
           surface_data = surface_data';
           warning('ebvis_warn:input', ...
               ['Reshaped surface_data to match number of vertices: ', ...
               num2str(size(vertices, 1)), '\n'])
       else
           error('ebvis_error:input', ...
           'Length of surface_data should be equal to number of vertices')
       end
   end
end

if plot_e_data
    assert(plot_electrodes, 'ebvis_error:input', ...
            'Cannot plot electrode data without electrode coordinates')
   if size(electrode_data, 1) ~= size(electrodes, 1)
       if size(electrode_data, 2) == size(electrodes, 1)
           electrode_data = electrode_data';
           warning('ebvis_warn:input', ...
           ['Reshaped electrode_data to match number of electrodes: ', ...
           num2str(size(electrodes, 1)), '\n'])
       else
           error('ebvis_error:input', ...
       'Length of electrode_data should be equal to number of electrodes')
       end
   end
end   

%%%%%%%%%%%%%%%%%%%%%%%%%%%% prepare for plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if plot_e_data
    fprintf('Electrode data:\n')
    
    if size(electrode_data, 2) == 1   
        if isempty(e_data_span)
            e_data_span = [min(electrode_data), max(electrode_data)];
            assert(e_data_span(1) ~= e_data_span(2), ...
                                        'Range of electrode_data is 0')
            fprintf(['\tno range was specified -> ', ...
            'calculated from data: min = ', num2str(e_data_span(1)), ...
            ', max = ', num2str(e_data_span(2)), '\n'])
        else
            fprintf(['\tspecified range: min = ', ...
                num2str(e_data_span(1)), ', max = ', ...
                num2str(e_data_span(2)), '\n'])
        end
        if isempty(e_data_thresh)
            e_data_thresh = [0, 0];
            fprintf(['\tno min and max thresholds were specified ', ...
                            '-> thresholds are set to 0\n'])
        else
            fprintf(['\tspecified thresholds: min = ', ...
                num2str(e_data_thresh(1)), ', max = ', ...
                num2str(e_data_thresh(2)), '\n'])
        end
        [e_cmap, e_cmap_type] = ...
            eb_visualizer_make_colormap(e_data_cmap, surf_color_default);
        [e_data, e_data_norm] = ...
            eb_visualizer_x_data2triplets(electrode_data, ...
            e_cmap, e_data_span, e_data_thresh, surf_color_default);
        fprintf(['\tcolormap: ', e_data_cmap, ', type: ', ...
                                                    e_cmap_type, '\n'])
        
    elseif size(electrode_data, 2) == 3
        warning('ebvis_warn:input', ...
            ['Electrode data are read as color triplets, ', ...
                                'there might be unexpected behavior'])
        assert(all(min(electrode_data,[],1) >= 0), ...
            'ebvis_error:input', ['Each value in color triplets ', ...
                                    'should be within range [0, 1]'])
        assert(all(max(electrode_data,[],1) <= 1), ...
            'ebvis_error:input', ['Each value in color triplets ', ...
            'should be within range [0, 1]'])
        e_data                = electrode_data;
    end
    
    e_data_nans = isnan(e_data_norm);

    switch e_data_plot_form
        case 'size'
            e_mkr_size = zeros(size(e_data_norm)); 
            e_mkr_size(~e_data_nans) = ...
                            e_data_scale(e_data_norm(~e_data_nans));
            e_color = repmat(e_data_color_default, length(e_data), 1);

        case 'color'
            e_mkr_size = repmat(e_mkr_sise_default, 1, length(e_data));
            e_color = e_data;

        case 'size_color'
            e_mkr_size = zeros(size(e_data_norm));           
            e_mkr_size(~e_data_nans) = ...
                            e_data_scale(e_data_norm(~e_data_nans));
            e_color = e_data;
    end
end

if plot_s_data
    fprintf('Surface data:\n')
    surface_data = double(surface_data);
    
    if size(surface_data, 1) == size(electrodes, 1)
        s_data_span    = e_data_span;
        s_data_thresh  = e_data_thresh;
        s_data_cmap    = e_data_cmap;
        if isempty(s_data_span)
            s_data_span = [min(surface_data), max(surface_data)];
            fprintf(['\tno range was specified -> ', ...
              'calculated from data: min = ', num2str(s_data_span(1)), ...
              ', max = ', num2str(s_data_span(2)), '\n'])
        else
            fprintf(['\tspecified range: min = ', ...
              num2str(s_data_span(1)), ', max = ', ...
              num2str(s_data_span(2)), '\n'])
        end
        if isempty(s_data_thresh)
            s_data_thresh = [0, 0];
            fprintf(['\tno min and max thresholds were specified ', ...
                                    '-> thresholds are set to 0\n'])
        else
            fprintf(['\tspecified thresholds: min = ', ...
                num2str(s_data_thresh(1)), ', max = ', ...
                num2str(s_data_thresh(2)), '\n'])
        end
        s_data  = eb_visualizer_e_data2s_data(vertices, electrodes, ...
                        surface_data, show_hemi_default, e_data_fade);
       
        [s_cmap, s_cmap_type] = ...
            eb_visualizer_make_colormap(s_data_cmap, surf_color_default);
        s_cmap = adjust_s_cmap(s_cmap, s_cmap_type, surf_color_default);
        
    elseif size(surface_data, 2) == 1  
        if isempty(s_data_span)
            s_data_span = [min(surface_data), max(surface_data)];
            fprintf(['\tno range was specified -> ', ...
             'calculated from data: min = ', num2str(s_data_span(1)), ...
             ', max = ', num2str(s_data_span(2)), '\n'])
        else
            fprintf(['\tspecified range: min = ', ...
                num2str(s_data_span(1)), ', max = ', ...
                num2str(s_data_span(2)), '\n'])
        end
        if isempty(s_data_thresh)
            s_data_thresh = [0, 0];
            fprintf(['\tno min and max thresholds were ', ...
                            'specified -> thresholds are set to 0\n'])
        else
            fprintf(['\tspecified thresholds: min = ', ...
                num2str(s_data_thresh(1)), ', max = ', ...
                num2str(s_data_thresh(2)), '\n'])
        end
        [s_cmap, s_cmap_type] = ...
            eb_visualizer_make_colormap(s_data_cmap, surf_color_default);
        s_cmap = adjust_s_cmap(s_cmap, s_cmap_type, surf_color_default);
        s_data = surface_data;
        
    elseif size(surface_data, 2) == 3
        warning('ebvis_warn:input', ...
            ['Surface data are read as color triplets, ', ...
            'there might be unexpected behavior'])
        assert(all(min(surface_data,[],1) >= 0), 'ebvis_error:input', ...
            'Each value in color triplets should be within range [0, 1]')
        assert(all(max(surface_data,[],1) <= 1), 'ebvis_error:input', ...
            'Each value in color triplets should be within range [0, 1]')
        s_data = surface_data;
    end
    fprintf(['\tcolormap: ', s_data_cmap, ', type: ', s_cmap_type, '\n'])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h = gcf();
set(h, 'visible', 'on')
set(h, 'color', 'w')
view(show_view_pos)

if plot_surface
    
    P = patch('faces', faces, 'vertices', vertices, ...
    'facecolor', surf_color_default, 'edgecolor', 'none', 'facealpha', ...
                                                surf_alpha_default);
    
    if plot_s_data
        set(P, 'facevertexcdata', s_data);
        set(P, 'facecolor', 'interp');
        colormap(gca, s_cmap)
        caxis(s_data_span)
        % set(gca, 'clim', s_data_span)
    end
end

if plot_electrodes && ~plot_e_data
    hold on
    e_data_color_default = [0 0 0];
    switch els_form
        case 'filled'
            eM = '.';
            e_mkr_size = e_mkr_sise_default;
            plot3(electrodes(:, 1) + els_bringup(1), ...
                  electrodes(:, 2) + els_bringup(2), ...
                  electrodes(:, 3) + els_bringup(3), ...
                        'marker', eM,'color', e_data_color_default, ...
                        'linestyle', 'none', 'markersize', e_mkr_size + 5);
            plot3(electrodes(:, 1) + els_bringup(1), ...
                  electrodes(:, 2) + els_bringup(2), ...
                  electrodes(:, 3) + els_bringup(3), ...
                        'marker', eM, 'color', e_data_color_default, ...
                        'linestyle', 'none', 'markersize', e_mkr_size);
        
        case 'empty'
            eM = 'o';
            e_mkr_size = e_mkr_sise_default * 0.2;
            plot3(electrodes(:, 1) + els_bringup(1), ...
                  electrodes(:, 2) + els_bringup(2), ...
                  electrodes(:, 3) + els_bringup(3), ...
                        'marker', eM,'color', e_data_color_default, ...
                        'linestyle', 'none', 'markersize', e_mkr_size, ...
                        'linewidth', e_data_line_width);
    end
    if ~isempty(els_labels)
        text(electrodes(:, 1) + els_bringup(1), ...
              electrodes(:, 2) + els_bringup(2)-2, ...
              electrodes(:, 3) + els_bringup(3)-1, ...
              els_labels, 'fontsize', 10)
    end
end


if plot_electrodes && plot_e_data
    hold on
    if e_data_nodata_show
        plot3(electrodes(e_data_nans, 1) + els_nodata_bringup(1), ...
              electrodes(e_data_nans, 2) + els_nodata_bringup(2), ...
              electrodes(e_data_nans, 3) + els_nodata_bringup(3), ...
                 'marker', e_data_nodata_style_char, ...
                 'color', [0.2 0.2 0.2], ...
                 'markersize', 5, ...
                 'linestyle', 'none', ...
                 'linewidth', 1);
    end
    for i = 1:size(electrodes, 1)
        if e_data_nans(i) == 0 %#ok<*BDSCA>
              
            plot3(electrodes(i, 1) + els_bringup(1), ...
                  electrodes(i, 2) + els_bringup(2), ...
                  electrodes(i, 3) + els_bringup(3), ...
                  'o', 'markerfacecolor', e_color(i, :), ...
                  'markeredgecolor', 'k', ...
                  'markersize', e_mkr_size(i));
            
            if e_data_add_gloss == 1
                plot3(electrodes(i, 1) + els_bringup, ...
                    electrodes(i, 2), electrodes(i, 3), ...
                    'marker', '.', 'color', [0.6 0.8 1], ...
                    'linestyle', 'none', ...
                    'markersize', e_mkr_sise_default * 0.2);
            end
        end
    end
    if ~isempty(els_labels)
    text(electrodes(:, 1) + els_bringup(1), ...
              electrodes(:, 2) + els_bringup(2), ...
              electrodes(:, 3) + els_bringup(3), ...
              els_labels, 'fontsize', 10)
    end
end

if plot_surface
    l = light;
    lighting gouraud;

    if show_view_pos(1)     > 200
        set(l,'position',[-1 0 1]) % [-1 0 1] for left
    elseif show_view_pos(1) < 200
        set(l,'position',[1 0 1]) 
    end

    if ~plot_s_data %|| e2s_data
        % camlight('headlight','infinite')
        material dull; 
    else
        material([.3 .8 .1 10 1]);
        if plot_s_data
            set(gca, 'clim', s_data_span)
            shading interp;
        end
    end
end

   
axis off; axis equal; axis fill
hold on

% shading flat
% set(gcf, 'renderer', 'zbuffer')
% surface_position = get(gca, 'position');

if plot_s_data && s_data_colorbar_show
     s_data_cbar = colorbar('north', 'fontsize', 10);   
     caxis(s_data_span)

     if ~isempty(s_data_colorbar_label)
        s_data_cbar.Label.String = s_data_colorbar_label;
        s_data_cbar.Label.FontSize = 16;
     end
end

if plot_e_data && e_data_colorbar_show
     ax0 = axes('visible', 'off');
     colormap(ax0, e_cmap)
     e_data_cbar = colorbar(ax0, 'southoutside', 'fontsize', 10, ...
                                    'axislocation', 'out'); 
     caxis(ax0, e_data_span)

     if ~isempty(e_data_colorbar_label)
        e_data_cbar.Label.String = e_data_colorbar_label;
        e_data_cbar.Label.FontSize = 16;
     end
end



function out = load_from_file(fname)
    assert(ischar(fname))
    assert(logical(exist(fname, 'file')), 'No such file')
    s = load(fname);
    temp = fieldnames(s);
    out = s.(temp{1});
    fprintf(['Loaded ', fname, '\n'])
    fprintf(['Found fields: ', num2str(numel(temp)), '\n'])
    fprintf(['Selected 1-st field by default: ', temp{1}, '\n'])

function cm = adjust_s_cmap(s_cmap, cmap_type, surf_color_default)
    cm = colormap(s_cmap);
    if strcmp(cmap_type, 'seq')
       cm = [surf_color_default; cm];
    elseif strcmp(cmap_type, 'div')
        cm = [cm(1:size(cm, 1)/2-15, :); ...
       repmat(surf_color_default, [16, 1]); cm(size(cm, 1)/2+16:end, :)];
    end





