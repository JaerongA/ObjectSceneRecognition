function plot_clusterinfo_mastersheet(currentROOT,)

%Visual summary
cd(currentROOT);
for ttRUN = 1:1:4	 %Spk shape
	subplot(3, 4, ttRUN);
	if mean(maxAPMat(ttRUN, :)) > 10^2
		hold on;
			thisMEANAP = mean(thisCLAP(:, ttRUN, :), 3); 
            thisMEANMAXLOC = min(find(thisMEANAP == max(thisMEANAP))); 
            thisMEANminLOC = max(find(thisMEANAP == min(thisMEANAP))); 
            thisPEAKTOVALLEY = thisMEANminLOC - thisMEANMAXLOC + 1;
			%errorbar(mean(thisCLAP(:, ttRUN, :), 3), std(transpose(squeeze(thisCLAP(:, ttRUN, :)))) ./ sqrt(size(thisCLAP, 3)));	%STE as error bars
			errorbar(thisMEANAP, std(transpose(squeeze(thisCLAP(:, ttRUN, :)))));						%STD as error bars
			if thisMEANMAXLOC < thisMEANminLOC
				plot(thisMEANMAXLOC:thisMEANminLOC, thisMEANAP(thisMEANMAXLOC:thisMEANminLOC, 1), '-r');
			end	%thisMEANMAXLOC < thisMEANminLOC
		hold off;
		clear thisMEANAP thisMEANMAXLOC thisMEANminLOC;
	else
		plot(1:1:size(mean(thisCLAP(:, ttRUN, :), 3), 1), ones(1, size(mean(thisCLAP(:, ttRUN, :), 3), 1))); thisPEAKTOVALLEY = nan;
	end	%mean(maxAPMat(ttRUN, :)) > 10^4
	title(['width = ' jjnum2str(ttSPKWIDTH(1, ttRUN)) '\mus (' num2str(thisPEAKTOVALLEY) ')']); set(gca, 'FontSize', szFONT); axis off; clear thisPEAKTOVALLEY;
end	%ttRUN = 1:1:4

subplot(3, 4, 5:6);	%avg. spk shape
%errorbar(mean(mean(thisCLAP, 2), 3), std(transpose(squeeze(mean(thisCLAP, 2)))) ./ sqrt(size(thisCLAP, 3)));
errorbar(mean(mean(thisCLAP, 2), 3), std(transpose(squeeze(mean(thisCLAP, 2)))));			%STD as error bars
title(['Avg.: spk width = ' jjnum2str(SPKWIDTH) '\mus']); set(gca, 'FontSize', szFONT); axis off;

subplot(3, 4, 7:8);	%text descriptions
set(gca, 'XLim', [0 10], 'YLim', [0 10], 'FontSize', szFONT); axis off;
text(txtINIX, txtINIY + txtADJ * 2, ['Cluster summary - ' clusterID]);
text(txtINIX, txtINIY + txtADJ * 1, [' ']);
text(txtINIX, txtINIY - txtADJ * 0, ['Isolation Distance = ' jjnum2str(ISODIST)]);
text(txtINIX, txtINIY - txtADJ * 1, ['L-Ratio = ' jjnum2str(LRATIO)]);
text(txtINIX, txtINIY - txtADJ * 2, ['Spatial Information Score = ' jjnum2str(SpaInfoScore) ' (bit / spk)']);
text(txtINIX, txtINIY - txtADJ * 3, ['# of spks = ' num2str(nSPKS)]);
text(txtINIX, txtINIY - txtADJ * 4, ['Session FR = ' jjnum2str(FRRate) ' Hz']);
text(txtINIX, txtINIY - txtADJ * 5, ['On-map Max FR = ' jjnum2str(onmazeMaxFR) ' (Hz)']);
text(txtINIX, txtINIY - txtADJ * 6, ['On-map Avg. FR = ' jjnum2str(onmazeAvgFR) ' (Hz)']);
text(txtINIX, txtINIY - txtADJ * 7, ['Spike width (peak-to-valley) = ' jjnum2str(SPKWIDTHAMP) ' \mus']);
text(txtINIX, txtINIY - txtADJ * 8, ['Spikes within refractory period = ' jjnum2str(withinREFRACPortion) ' %']);

subplot(3, 4, 9);	%spk map
hold on;
	scatter(thisPos(:, 2), thisPos(:, 3), szDOT, colTRACE, 'filled');
	scatter(thisCLTS(:, end - 2), thisCLTS(:, end - 1), szDOT, colSPK, 'filled');
hold off;
title(['raw spk map']); set(gca, 'YDir', 'rev', 'XLim', [0 imCOL], 'YLim', [0 imROW], 'FontSize', szFONT); axis off;

subplot(3, 4, 10);	%fr map
set(gca, 'YDir', 'rev', 'XLim', [0 imCOL / thisFRMapSCALE], 'YLim', [0 imROW / thisFRMapSCALE], 'nextplot', 'add', 'FontSize', szFONT); axis off;
thisAlphaZ = skaggsMap; thisAlphaZ(isnan(skaggsMap)) = 0; thisAlphaZ(~isnan(skaggsMap)) = 1;
imagesc(skaggsMap); alpha(thisAlphaZ); title(['Skaggs firing rate map']);

subplot(3, 4, 11);	 %auto-correlogram
bar(corrXlabel, correlogram);
title(['AutoCorrelogram']); set(gca, 'FontSize', szFONT, 'XLim', [min(corrXlabel) max(corrXlabel)], 'YLim', [0 max(log10(correlogram))]); xlabel(['Time (ms)']); axis tight;

subplot(3, 4, 12);	 %inter-spike interval
hold on;
	bar(isiHIST);	%plot(ones(1, max(isiHIST) + 1) .* find(histEDGE == 0), 0:1:max(isiHIST), 'r:', 'LineWidth', szLINE);
	text(min(find(isiHIST == min(max(isiHIST)))), min(max(isiHIST)), [jjnum2str((10^histEDGE(min(find(isiHIST == min(max(isiHIST)))))) / 1000) ' ms']); LogISIPEAKTIME = (10^histEDGE(min(find(isiHIST == min(max(isiHIST)))))) / 1000;
hold off;
title(['log ISI']); xlabel(['time (ms)']); axis tight; set(gca, 'FontSize', szFONT, 'XLim', [350 size(histEDGE, 2)], 'XTick', 350:((size(histEDGE, 2) - 350) / 2):size(histEDGE, 2), 'XTickLabel', {['.31'], ['55'], ['10000']});

fprintf('\n%s is processed\n', clusterID);
clear thisWholeCLTS thisEpochCLTS thisEpochCLAP nvtTS nvtX nvtY nvtHD;