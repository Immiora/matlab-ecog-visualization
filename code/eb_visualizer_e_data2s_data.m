function s_data = eb_visualizer_e_data2s_data(vertices, els, edata, hemi, fade)
len     = size(vertices, 1);
s_data  = zeros(len, 1);

nonanind = find(~isnan(edata));

for el = nonanind'
    b_z = abs(vertices(:,3)-els(el,3));
    b_y = abs(vertices(:,2)-els(el,2));
    if strcmp(hemi, 'l'), 
        b_x = abs(vertices(:,1) - els(el,1));  
    elseif strcmp(hemi, 'r'), 
        b_x = abs(els(el,1) - vertices(:,1));
    end
    d = edata(el) * exp((-(b_x.^2+b_z.^2+b_y.^2))/fade); %exponential fall off % electrode_weight is a measure: cor, power, lag or whatever else
    % take out data(e)from d, and all(all~=0) = data(e)
    s_data = s_data + d;
end
% s_data = round(s_data);
