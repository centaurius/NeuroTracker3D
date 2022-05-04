//close("*");

input = getDirectory("Select Folder with PSF: ");
output = input;
File.makeDirectory(output);

// Load PSF
open(input+"PSF.tif");

// Restrict PSF area and save PSF cropped image as tiff and png
selectWindow("PSF.tif");
run("8-bit");
setMinAndMax(0, 15);
call("ij.ImagePlus.setDefault16bitRange", 8);
setSlice(15);

makeRectangle(12, 31, 30, 31);
run("Duplicate...", "title=PSF_cropped duplicate");
run("Duplicate...", "title=Dup duplicate");
Stack.setXUnit("um");
run("Properties...", "channels=1 slices=28 frames=1 pixel_width=0.1625 pixel_height=0.1625 voxel_depth=1");
run("Scale Bar...", "width=1 height=1 font=0 color=White background=None location=[Upper Right] hide label");
saveAs("Tiff", output+"PSF_cropped.tif");
rename("PSF_cropped");
selectWindow("PSF_cropped");
run("Scale Bar...", "width=1 height=1 font=0 color=White background=None location=[Upper Right] hide label");
saveAs("PNG", output+"PSF_cropped.png");

close("PSF_cropped.png");
close("*.tif");

selectWindow("PSF_cropped");
run("Reslice [/]...", "output=1.000 start=Right avoid");
setSlice(15);
run("Rotate 90 Degrees Left");
saveAs("PNG", output+"PSF_cropped_OrthogonalView.png");




