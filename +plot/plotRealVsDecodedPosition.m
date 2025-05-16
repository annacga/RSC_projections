function plotRealVsDecodedPosition(mData,area,session)


    col =  [122 172 210
            80 106 139
            217 85 88
            129 89 162 
            180 151 94
            179 205 142]./255; 

    real_position =  mData(area ,session).d_data(length(mData(area ,session).d_data)).iter{1,mData(area ,session).d_data(length(mData(area ,session).d_data)).medianTestFold}.realPos_test;
    predicted_position = mData(area ,session).d_data(length(mData(area ,session).d_data)).iter{1,mData(area ,session).d_data(length(mData(area ,session).d_data)).medianTestFold}.predPos_test;

    figure()
    plot(real_position, 'LineWidth', 1.5, 'Color', 'k'); hold on
    plot(predicted_position, 'LineWidth',1.5, 'Color', col(area,:));
    xlim( [100 700])
    xticks([]);
    yticks([0 156])
    yticklabels({'0','157'});
    box 'off'
    set(gca, 'FontSize',12, 'FontName', 'Arial')
    axis('off')
    
    
    
    nFrames = length(real_position)/50;
    fig = figure('Position',[0 0 800 300]);
    axis('off')
    set(gca, 'FontSize',12, 'FontName', 'Arial')
    set(gca, 'FontSize', 15)
    %              scatter3(Y(:,1),Y(:,2),Y(:,3),50,[0.5 0.5 0.5],'filled','MarkerFaceAlpha',.4,'MarkerEdgeAlpha',.4); hold on
    predicted_position(find(abs((predicted_position-real_position))>77)) =  155-  predicted_position(find(abs((predicted_position-real_position))>77));

    hold on
    k = 0;
    for j = 200:length(real_position)
        ylim([0  155])
        plot(real_position(j-199:j), 'LineWidth', 2.5, 'Color', 'k'); hold on
        plot(predicted_position(j-199:j), 'LineWidth',2.5, 'Color', col(1,:));
        
        hold off
        axis('off')
        
        m = getframe(gcf); %get frame
        
        
        if j == 200
            [~,map] = rgb2ind(m.cdata, 256, 'nodither');
        end
        map( find(sum(map')>2),:) = ones(length(find(sum(map')>2)),3);
        k = k+1;
        [mov(:,:,1,k), map] = rgb2ind(m.cdata, map, 'nodither');
         
    end
   dirct = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Michele Gianatti/Data&Analysis/Paper/decoding/decodingVsNoCells/M2',
   imwrite(mov,map, fullfile(dirct,strcat('vid.gif')), 'DelayTime', 0, 'LoopCount', inf)
% 
end