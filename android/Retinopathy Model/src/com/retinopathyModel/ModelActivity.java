package com.retinopathyModel;


//JOSEPH FURLOTT
//

import java.io.File;
import java.util.ArrayList;

import android.app.Activity;
import android.content.Context;
import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.WindowManager;


public class ModelActivity extends Activity {
	public float[] coordinates, radii;
	public int[] colors;
	Context context = this;
	private ModelRenderer mRenderer;
	private GLSurfaceView view;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        //for the OpenGL to get started
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        view = new GLSurfaceView(this);

        
        // Part of the Model class now
        ReadInCoordinates read = new ReadInCoordinates();
        File myDir = new File(context.getFilesDir().getAbsolutePath());
        
        
        //Read in the text file and save it to a temporary arrayList
        Log.v("read", "started to");       
        ArrayList<Integer> coordsList = read.readOnlyCoordinates(myDir, "Coordinates10.txt", this);
        Log.v("read" , "successful");

        
        
        //convert the ArrayList to a a float array so that the renderer can handle it
        coordinates = new float[coordsList.size()];
        for(int i = 0; i < coordsList.size(); i++) {
        	coordinates[i] = (float) (coordsList.get(i).intValue())/1000;
        }
        
        //convert the colors ArrayList into an array of int
        ArrayList<Integer> colorsList = read.getColorsArrayList();
        colors = new int[colorsList.size()];
        for(int i = 0; i < colorsList.size(); i++) {
        	colors[i] = colorsList.get(i).intValue() ;
        }
        
        
        //convert the radii ArrayList into a float array
        ArrayList<Integer> radiusList = read.getRadiusArrayList();
        radii = new float[radiusList.size()];
        for(int i = 0; i < radiusList.size(); i++) {
        	radii[i] = (float) radiusList.get(i).intValue()/10;
        }
        
        

        //delete that temporary arrayList so to save space; remember on a phone/tab
        coordsList.clear();
        colorsList.clear();
        radiusList.clear();
        
        
        //what is drawn in the activity
        //setContentView(R.layout.activity_model);
        mRenderer = new ModelRenderer(true, this, coordinates, colors, radii);
        
        //setRenderMode(mRenderer.RENDERMODE_WHEN_DIRTY);

        view.setRenderer(mRenderer);        
        setContentView(view);

        
        
    }
    
    
    //touch events
    private final float TOUCH_SCALE_FACTOR = 180.0f / 320;
    private float mPreviousX;
    private float mPreviousY;
        
    @Override
    public boolean onTouchEvent(MotionEvent e) {
    	//how we are going to handle touch motion - from the android dev website
    	float x = e.getX(); //sets X coordinates
    	float y = e.getY(); //sets Y coordinates; that simple
    	
    	//debug
    	Log.v("touch coordinates", String.valueOf(x) + " " + String.valueOf(y));
    	
    	switch(e.getAction()) {
    		case MotionEvent.ACTION_MOVE:
    			
    			float dx = x - mPreviousX;
    			float dy = y - mPreviousY;
    			
    			if(y > view.getHeight()/2) {
    				dx = dx * -1;
    			}
    			
    			if ( x < view.getWidth() /2) {
    				dy = dy* -1;
    			}
    			
    			mRenderer.setmAngle( mRenderer.getmAngle() + ((dx + dy) * TOUCH_SCALE_FACTOR));
    	}
    	
    	
    	mPreviousX = x;
    	mPreviousY = y;
    	
    	
    	
    	return true;
    }

}
