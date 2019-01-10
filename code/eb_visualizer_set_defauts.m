function opts = eb_visualizer_set_defauts(opts)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% general %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isfield(opts, 'fig_handle')
    opts.fig_handle = figure('units', 'normalized', 'outerposition', [0.15 0.15 .65 .65], 'visible', 'off'); end

if ~isfield(opts, 'show_hemi_default')
    opts.show_hemi_default      = 'l'; end

if ~isfield(opts, 'show_view_pos')
    if strcmp(opts.show_hemi_default, 'l')
        opts.show_view_pos      = [270, 0]; 
    elseif strcmp(opts.show_hemi_default, 'r')
        opts.show_view_pos      = [90, 0];
    end
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% surface %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isfield(opts, 'surf_color_default')
    opts.surf_color_default    = [0.7 0.7 0.7]; end
if ~isfield(opts, 'surf_alpha_default')
    opts.surf_alpha_default = 1; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% surface data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isfield(opts, 's_data_cmap') 
    opts.s_data_cmap           = 'cold'; end

if ~isfield(opts, 's_data_span') 
    opts.s_data_span           = []; end 

if ~isfield(opts, 's_data_thresh')
    opts.s_data_thresh         = []; end

if ~isfield(opts, 's_data_colorbar_show')
    opts.s_data_colorbar_show  = 1; end

if ~isfield(opts, 's_data_colorbar_label') 
    opts.s_data_colorbar_label  = ''; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% electrodes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isfield(opts, 'els_nodata_bringup')
    if strcmp(opts.show_hemi_default, 'l')
        opts.els_nodata_bringup = [-10, 0, 0]; 
    elseif strcmp(opts.show_hemi_default, 'r')
        opts.els_nodata_bringup = [10, 0, 0]; 
    end
end

if ~isfield(opts, 'els_bringup')
    if strcmp(opts.show_hemi_default, 'l')
        opts.els_bringup       = [-7, 0, 0]; 
    elseif strcmp(opts.show_hemi_default, 'r')
        opts.els_bringup       = [7, 0, 0]; 
    end
end

if ~isfield(opts, 'els_form')
    opts.els_form              = 'filled'; end

if ~isfield(opts, 'els_labels')
    opts.els_labels = []; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% electrode data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isfield(opts, 'e_mkr_sise_default')
    opts.e_mkr_sise_default    = 10; end

if ~isfield(opts, 'e_data_span')
    opts.e_data_span           = []; end

if ~isfield(opts, 'e_data_thresh')
    opts.e_data_thresh         = []; end

if ~isfield(opts, 'e_data_cmap_rng')
    opts.e_data_cmap_rng       = 64; end

if ~isfield(opts, 'e_data_scale_step')
    opts.e_data_scale_step     = 2; end

if ~isfield(opts, 'e_data_color_default')
    opts.e_data_color_default  = [0 0 0]; end  

if ~isfield(opts, 'e_data_cmap')
    opts.e_data_cmap           = 'hot'; end

if ~isfield(opts, 'e_data_scale')
    opts.e_data_scale  = round(linspace(0.5, opts.e_data_scale_step, opts.e_data_cmap_rng) * opts.e_mkr_sise_default); 
end

if ~isfield(opts, 'e_data_plot_form')
    opts.e_data_plot_form      = 'color'; end

if ~isfield(opts, 'e_data_line_width')
    opts.e_data_line_width     = 2; end

if ~isfield(opts, 'e_data_nodata_style') 
    opts.e_data_nodata_style  = 'filled'; end

if ~isfield(opts, 'e_data_nodata_show')
    opts.e_data_nodata_show  = 1; end

if ~isfield(opts, 'e_data_nodata_style_char')
    if strcmp(opts.e_data_nodata_style, 'empty')
        opts.e_data_nodata_style_char  = 'o';
    elseif strcmp(opts.e_data_nodata_style, 'filled')
        opts.e_data_nodata_style_char  = '.';
    end
end

if ~isfield(opts, 'e_data_add_gloss')
    opts.e_data_add_gloss = 0; end

if ~isfield(opts, 'e_data_colorbar_show')
    opts.e_data_colorbar_show  = 1; end

if ~isfield(opts, 'e_data_colorbar_label')
    opts.e_data_colorbar_label  = ''; end

if ~isfield(opts, 'e_data_fade')
    opts.e_data_fade = 7; end


fields = fieldnames(opts);
for o = 1:length(fields)
    assignin('caller', fields{o}, opts.(fields{o}))
end