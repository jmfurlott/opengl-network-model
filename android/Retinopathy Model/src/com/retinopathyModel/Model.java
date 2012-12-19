package com.retinopathyModel;


import java.io.File;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.util.ArrayList;

import javax.microedition.khronos.opengles.GL10;
import javax.microedition.khronos.opengles.GL11;

import android.content.Context;
import android.util.Log;
public class Model {
	private FloatBuffer mFVertexBuffer;
	private FloatBuffer   mColorBuffer; //or ByteBuffer in tutorial!
	private float[] coordinates;
	float[] radiusFloat;
	
	
	public Model() {
		//empty!
	}

	
	public Model(Context context, float[] coordinates, int[] colors, float[] radii) {
		//first generate list of coordinates		
		this.coordinates = coordinates;


        float colorsFloat[] = buildColorArray(colors);	
        radiusFloat = radii;
        
        float indices[] = { 0, 1 };
        
        
        ByteBuffer vbb = ByteBuffer.allocateDirect(coordinates.length * 4);     //5
        vbb.order(ByteOrder.nativeOrder());
        mFVertexBuffer = vbb.asFloatBuffer();
        mFVertexBuffer.put(coordinates);
        mFVertexBuffer.position(0);
//
        ByteBuffer second = ByteBuffer.allocateDirect(colorsFloat.length * 4);
        second.order(ByteOrder.nativeOrder());
       // mColorBuffer = ByteBuffer.allocateDirect(colors.length);
        mColorBuffer = second.asFloatBuffer();
        mColorBuffer.put(colorsFloat);
        mColorBuffer.position(0);
        
    }


        
	
    public void draw(GL10 gl)  {
    	
       
    	
    	gl.glEnableClientState(GL10.GL_VERTEX_ARRAY);
    	gl.glEnableClientState(GL10.GL_COLOR_ARRAY);
    	gl.glVertexPointer(3, GL10.GL_FLOAT, 0, mFVertexBuffer);
        gl.glColorPointer(4, GL11.GL_FLOAT, 0, mColorBuffer);
    	
        int a = 0;
    	gl.glLineWidth(this.radiusFloat[a]);
    	a++;
    	if(a == radiusFloat.length) {
    		a = 0;
    	}
    	
        gl.glFrontFace(GL11.GL_CW);                                          //7
        gl.glDrawArrays(GL11.GL_LINES, 0, coordinates.length+1);        
        gl.glDisableClientState(GL10.GL_VERTEX_ARRAY);
        gl.glDisableClientState(GL10.GL_COLOR_ARRAY);

    }


    public float[] buildColorArray(int[] colors) {
    	float colorsFloat[] = new float[colors.length * 8];
    	
    	int a = 0;
    	int i = 0;
    	while(i < colors.length) {
    		if(colors[i] == 0) {
    			colorsFloat[a] = 0.0f;
    			a++;
    			colorsFloat[a] = 0.0f;
    			a++;
    			colorsFloat[a] = 1.0f;
    			a++;
    			colorsFloat[a] = 1.0f;
    			a++;
    			
    			colorsFloat[a] = 0.0f;
    			a++;
    			colorsFloat[a] = 0.0f;
    			a++;
    			colorsFloat[a] = 1.0f;
    			a++;
    			colorsFloat[a] = 1.0f;
    			a++;
    			
    			i++;
    		}
    		else if (colors[i] == 1) {
    			colorsFloat[a] = 1.0f;
    			a++;
    			colorsFloat[a] = 0.0f;
    			a++;
    			colorsFloat[a] = 0.0f;
    			a++;
    			colorsFloat[a] = 1.0f;
    			a++;
    			
    			colorsFloat[a] = 1.0f;
    			a++;
    			colorsFloat[a] = 0.0f;
    			a++;
    			colorsFloat[a] = 0.0f;
    			a++;
    			colorsFloat[a] = 1.0f;
    			a++;
    			
    			i++;
    		}
    	}    	
  
    	return colorsFloat;

    }
    

    
    
	
	public float[] readCoordinates(Context context) {
        File file = context.getFileStreamPath("Coordinates10.txt");
        ReadInCoordinates read = new ReadInCoordinates();
        File myDir = new File(context.getFilesDir().getAbsolutePath());
        
        Log.v("read", "started to");
        
        ArrayList<Integer> coordsList = read.read(myDir, "/Coordinates10.txt", context);
        
        coordinates = new float[coordsList.size()];
        for(int i = 0; i < coordsList.size(); i++) {
        	coordinates[i] = (float) coordsList.get(i)/100; //not sure if you can cast Integer as int
        }
        
        return coordinates;
	}
	
}
