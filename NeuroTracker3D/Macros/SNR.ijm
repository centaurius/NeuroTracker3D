// Main code
/*
 * 
 * This macro depends on having a pre-defined ROI set.  
 * It must be in the same folder as where you want the output of each analysis run to go.  
 * Ideally, in the output folder with the other parts of the data analysis.
 * 
 */
output = getDirectory("Select Folder for Output of SNR analysis: ");

run("Clear Results");
roiManager("reset");

run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack display redirect=None decimal=3");

run("8-bit");
run("Select None");
Stack.setSlice(4);
Stack.setFrame(5);
run("Clear Results");
roiManager("Open", output + File.separator +"RoiSet.zip");
for (i = 0; i < 9; i++) {
	roiManager("Select", i);
	Roi.getCoordinates(x, y);
}
for (i = 0; i < 9; i++) {
	roiManager("Select", i);
	makeOval(x[i]-9, y[i]-9, 18, 18);
	run("Measure");
}

run("Measure");

setSlice(8);
run("Select All");
run("Measure");

roiManager("reset");

FN = getTitle();
sFN = replace(FN, ".tif", "");
saveAs("Results", output+sFN+"_SNRData.csv");