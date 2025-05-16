
function matrix = createHeatMap(lap, pos, behavior)

    % make all the same length
    minLength = min([length(lap),length(pos), length(behavior)]);
    lap = lap(1:minLength);
    pos = pos(1:minLength);
    behavior = behavior(1:minLength);

    heatmap = zeros(max(lap)+2,ceil(max(pos))); 
    occupancymap = zeros(max(lap)+2,ceil(max(pos)));
    offset = min(lap);
    for x = 1:length(lap)%pos)
        x_pos = round(pos(x))+1;
        if x_pos > size(heatmap,2); x_pos = size(heatmap,2); end
        y_pos = lap(x)+1+(-offset);
        heatmap(y_pos,x_pos) = heatmap(y_pos,x_pos) + behavior(x);
        occupancymap(y_pos,x_pos) = occupancymap(y_pos,x_pos) + 1;
    end

    matrix = heatmap./occupancymap;

end
