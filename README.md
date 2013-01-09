

Joseph Furlott

FILE DIRECTORY
- opengl-cpp -----> c++ version of the opengl model (pretty incomplete)

- android    -----> android app

- matlab     -----> matlab image processing functions; segmentation

- graphing   -----> Java code for graph ADT; segmentation improvement; separation

- iOS	    ------> iOS app



iOS 1/8/2013 - 
	-simple motion tracking implemented need to fix up the angle in which its rotating and what happens if you reach the second half of the screen (look at android code)
	-still similar TODOs from yesterday
	-colors working!!

iOS 1/7/2013 -
	-modeling is rendering okay but still a lot to do
	-current derivation of the coordinates is terribly inefficient
	-fix coloring
	-fix spatial camera; ZOOM OUT!
	-handle motion!

iOS 1/6/2013 -
	-started the iOS app; currently running an arbitrary square as a test that openGL is working
	-started reading coordinates function


Graphing 1/1/2013 -
	-Network class created/started
	-buildNetwork seems to be working but creating 6000 graphs which is way too high
	-TODO: handle branches:::look at notes

Graphing 12/30/2012 - BFS working and now able to traverse the graph (maybe DFS would be faster but this is fine for now.) BFS only takes in acccount nextNodes right now however


Graphing 12/29/2012 -
	-basic graph traversal functions implmentated like add/delete/neighboring
	-TODO: how to build the graph? 
	-TODOL bfs currently semi-implemented. not adding to queue right

Graphing 12/27/2012 -

-Graphing ADT started
-directories better organized


Matlab (segmentation/separation)

12/26/2012
-Decent segmentation working in the rgb2binary.m function.
-Still not very smooth but decent.  can work with it
-may begin separation...
-also from a long time ago, write coordinates semi-implementated..will use this for separation??
![Alt text](https://raw.github.com/jmfurlott/opengl-network-model/master/matlab/output_binary.jpg?login=jmfurlott&token=945c1eb9788fe354a7bf537baa4976b3)




Android 


12/21/2012 (2)
-zoom and rotate toggle working via pressing the menu button.  much more
stable this way but less seamless I guess
-zoom still odd using only the z axis and rotate needs to be better too

12/21/2012
-zoom working based on an invisible toggle in the lower right hand corner
-awkward; doesn't want to work 100% of the time. switches back to rotations - weird
-TODO: implement as a menu button or a visible button at least. I think its due
	to the toggle being based off coordinates in space ( quick and dirty right now)
-TODO: create more natural zoom.  zth zoom is okay but kinda weird


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
