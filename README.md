Connected Component Labeling
===================

An iOS project to find the number of connected components in an image (after linear thresholding)

"Connected-component labeling (alternatively connected-component analysis, blob extraction, region labeling, blob discovery, or region extraction) is an algorithmic application of graph theory, where subsets of connected components are uniquely labeled based on a given heuristic. Connected-component labeling is not to be confused with segmentation."[1](http://en.wikipedia.org/wiki/Connected-component_labeling#Algorithms)

This is an iOS project that runs on 3.5 inch/4 inch iPhone Retina devices (both 32 & 64 bit).

Download the source and run it on the iOS simulator. 

[The default source code will only label white colored objects in your image]

****

###HOW TO TEST THIS PROJECT FROM THE FRONT-END:

1.) Run the project. 

2.) Click the load button and choose an image from your gallery. (Loading from camera not available)


3.) Click the 'label' button. A text should appear, indicating the number of unique components found.


****

###HOW TO INCLUDE THIS FUNCTIONALITY INTO YOUR PROJECT:

1.) Drag and drop the two files titled: ConnectedComponentLabelling.h and ConnectedComponentLabelling.m in your project


2.) Create an object of this class in your app:
    
    ConnectedComponentLabelling *ccl = [[ConnectedComponentLabelling alloc] init];
      
      
3.) Pass the image you want to label. The returned image gets the unique regions colored by a tint that is unique to each blob.
    
    image = [ccl twoPassCCL :image :[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:255.0]];
     //(Defaults to white. Change the color values as per your requirements OR threshold your image apriori and then call this method)
      
      
4.) The total number of unique elements counted can be obtained using:
    
    [ccl getUniqueElementCount];
    

  
