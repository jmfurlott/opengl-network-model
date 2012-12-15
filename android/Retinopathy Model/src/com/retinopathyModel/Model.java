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
	private ByteBuffer   mColorBuffer;
	private ByteBuffer  mTfan1;
	private int[] coordinates;
	
	public Model() {

		float vertices[] =                                                   //2

        {
        		-1.0f, 1.0f, 1.0f,
        		1.0f, 1.0f, 1.0f,
        		1.0f, -1.0f, 1.0f,
        		-1.0f, -1.0f, 1.0f,
        		
        		-1.0f, 1.0f, -1.0f,
        		1.0f, 1.0f, -1.0f,
        		1.0f, -1.0f, -1.0f,
        		-1.0f, -1.0f, -1.0f
        };

        byte maxColor=(byte)255;

        byte colors[] =                                                      //3
        {
        		maxColor, 0, 0, maxColor
        };

        byte tfan1[] = {
        		7, 0
        };
        
        
        ByteBuffer vbb = ByteBuffer.allocateDirect(vertices.length * 4);     //5
        vbb.order(ByteOrder.nativeOrder());
        mFVertexBuffer = vbb.asFloatBuffer();
        mFVertexBuffer.put(vertices);
        mFVertexBuffer.position(0);

        mColorBuffer = ByteBuffer.allocateDirect(colors.length);
        mColorBuffer.put(colors);
        mColorBuffer.position(0);

        mTfan1 = ByteBuffer.allocateDirect(tfan1.length);
        mTfan1.put(tfan1);
        mTfan1.position(0);
        
        
    }

	
	public void readCoordinates(Context context) {
        File file = context.getFileStreamPath("Coordinates10.txt");
        ReadInCoordinates read = new ReadInCoordinates();
        File myDir = new File(context.getFilesDir().getAbsolutePath());
        
        Log.v("read", "started to");
        
        ArrayList<Integer> coordsList = read.read(myDir, "/Coordinates10.txt", context);
        
        coordinates = new int[coordsList.size()];
        for(int i = 0; i < coordsList.size(); i++) {
        	coordinates[i] = (int) coordsList.get(i); //not sure if you can cast Integer as int
        }
        
        //return coordinates;
	}
        
	
    public void draw(GL10 gl)  {
//	        gl.glFrontFace(GL11.GL_CW);                                          //7
        gl.glVertexPointer(3, GL11.GL_FLOAT, 0, mFVertexBuffer);             //8
        gl.glColorPointer(4, GL11.GL_UNSIGNED_BYTE, 0, mColorBuffer);        //9
        gl.glDrawElements(GL11.GL_LINES, 2, GL11.GL_UNSIGNED_BYTE, mTfan1);
        gl.glFrontFace(GL11.GL_CCW);                                         //11
	}


	
}
