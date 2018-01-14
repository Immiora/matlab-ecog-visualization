function surface_data = eb_visualizer_annot2surface_data(annot, ctable)

labels = unique(annot);
surface_data = zeros(size(annot, 1), 3);

for l = labels'
    if l ~= 0
    c = ctable.table(:, 5) == l;
    len = length(find(annot == l));
        if strcmp(ctable.struct_names{c}, 'unknown')
            surface_data(annot == l, :) = 127.5;
        else
        surface_data(annot == l, :) = ...
            repmat(ctable.table(c, 1:3), len, 1);
        end
    end
end

surface_data = surface_data/255;