function opts = eb_get_options()

opts = eb_visualizer_set_defauts(struct);
fields = fieldnames(opts);

for f = 1:numel(fields)
    fprintf([fields{f}, '\n'])
end