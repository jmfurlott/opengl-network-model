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
	private FloatBuffer bCoordinates;
	private float[] coordinates;
	
	
	public Model() {
		
	}
	public Model(Context context, float[] coordinates) {
		//first generate list of coordinates
		
		this.coordinates = coordinates;
//		Log.v("coordinates", Float.toString(coordinates[0]));
//		Log.v("coordinates", String.valueOf(coordinates[1]));
//		Log.v("coordinates", String.valueOf(coordinates[2]));
//		Log.v("coordinates", String.valueOf(coordinates[3]));
//		Log.v("coordinates", String.valueOf(coordinates[4]));
//		Log.v("coordinates", String.valueOf(coordinates[5]));

		
		
		
		//float testCoords[] = {1.0f, 1.0f, 1.0f, -1.0f, -1.0f, -1.0f};
		
//		float vertices[] =                                                   //2
//
//        {
//        		-1.0f, 1.0f, 1.0f,
//        		1.0f, 1.0f, 1.0f,
//        		1.0f, -1.0f, 1.0f,
//        		-1.0f, -1.0f, 1.0f,
//        		
//        		-1.0f, 1.0f, -1.0f,
//        		1.0f, 1.0f, -1.0f,
//        		1.0f, -1.0f, -1.0f,
//        		-1.0f, -1.0f, -1.0f
//        };

        byte maxColor=(byte)255;

        byte colors[] =                                                      //3
        {
        		maxColor, maxColor, maxColor, 0
        };
        
        float colorsFloat[] = {1.0f, 0.0f, 0.0f, 0.0f};

        	
        
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
//
//        bCoordinates = FloatBuffer.allocate(indices.length);
//        bCoordinates.put(indices);
//        bCoordinates.position(0);
        
        
    }


        
	
    public void draw(GL10 gl)  {
    	
       
    	
    	gl.glEnableClientState(GL10.GL_VERTEX_ARRAY);
    	gl.glEnableClientState(GL10.GL_COLOR_ARRAY);
    	gl.glVertexPointer(3, GL10.GL_FLOAT, 0, mFVertexBuffer);
        gl.glColorPointer(4, GL11.GL_FLOAT, 0, mColorBuffer);
    	
    	
        gl.glFrontFace(GL11.GL_CW);                                          //7
        gl.glDrawArrays(GL11.GL_LINES, 0, coordinates.length+1);        
        gl.glDisableClientState(GL10.GL_VERTEX_ARRAY);
        gl.glDisableClientState(GL10.GL_COLOR_ARRAY);

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
