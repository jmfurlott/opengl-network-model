

Joseph Furlott

Android 

12/20/2012
-basics of touch control implemented; reads in an mAngle based on x y coordinates
-still having trouble with the camera; it will center right
-model is rotating correctly based on sliding your finger but not seamless
-TODO: fix weird extra created lines
-TODO: camera
-TODO: button and zoom controls (maybe same basic sliding motion but option selected to zoom)

12/18/2012 (2)
-Correctly colors veins and arteries!
-forced horizontal landscape
-TODO: set radius, touch control/camera
-currently the radius is semi-implemented. glLineWidth seems to set it for all lines
instead of just one at a time so I think I will have to do it in a different 
way



12/18/2012
-reading in colors into a new int[] called colors
-TODO: set the vertices and set color point


12/17/2012 
-Correctly drawing in one color right now.
-TODO: color weaving so veins are red and arteries are blue

12/16/2012
-Model working! Drawing successfully on phone.
-Centered and in the middle. landscape all wrong
-TODO: colors!
-TODO: still buggy. seems to drawn wrong lines or disappears oddly. something with
the buffer I am guessing
-TODO: finger controls
-TODO: iOS

12/15/2012
-Correctly reading in text
-OpenGL backend (Model handles the coodinates, etc.  and ModelRenderer renders just what I have in a model object)
-Currently draws a line on the screen

12/14/2012
-Android project created
-semi-implemented text reading - not working yet






C++ OpenGL Version

11/27/12 - 0.04
-LINE STRIPS implemented - much faster
-not perfect rendering right now
-error handling if file isn't there

11/26/12 - 0.03
-thickness around veins


11/26/12 - 0.02
-colors: red and blue


11/25/12 - 0.01
Draws lines from a textfile (new line created everytime - needs to be improved)
-no camera yet
-no colors (artery vs vein)
-no menu system
-no speed improvements
