///// Main Code
close("*");

input = getDirectory("Select Folder with Example Images for Filtering: ");
output = getDirectory("Select Folder for Output images and data: ");
macros = getDirectory("Select Folder with NeuroTracker3D macros: ");

open(input + "NeuroTracker3D_Demo.tif");
ImageTitle = getTitle();
shortImageTitle = replace(ImageTitle, ".tif", "");
run("Duplicate...", "title=C2_Dup duplicate channels=2-2");

Stack.getDimensions(width, height, channels, slices, frames);

// Run filtering examples to save how well the input image is filtered by different means
run("Duplicate...", "title=C2_Dup_SingleVolume duplicate frames=1-1");
selectWindow("C2_Dup_SingleVolume");
for (i = 0; i < 5; i++) {
	runMacro(macros + "FilteringFunction.ijm",i+1); // Pass i + 1 as variable to external macro for radius of filtering
	close("*Filtered*"); // Close all "Filtered" image windows to avoid cluttering workspace
}
