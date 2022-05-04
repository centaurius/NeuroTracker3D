s = getArgument();

close("Dup");
close("*Filtered");
output = getDirectory("Select Folder for Output of filtered images and data: ") + File.separator;
File.makeDirectory(output);
choices = newArray("Gaussian Blur","Median","Mean","Minimum","Maximum","Variance");
for (i = 0; i < choices.length; i++) {
	txt = choices[i] + " 3D...";
	selectWindow("C2_Dup_SingleVolume");
	run("Duplicate...", "title=Dup duplicate");
	run(txt, "x=s y=s z=s");
	rename(choices[i] + " Filtered");
	FN = getTitle();
	saveAs("Tiff", output+FN+"Radius_"+s+".tif");
	close("Dup");
}
