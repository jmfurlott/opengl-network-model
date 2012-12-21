package com.retinopathyModel;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

import android.content.Context;
import android.opengl.GLES20;
import android.opengl.GLSurfaceView;
import android.util.Log;
//1
//2

class ModelRenderer implements GLSurfaceView.Renderer
{
	
    private boolean mTranslucentBackground;
    private Model model;
    private float x,y;
    private float mAngle;
    private static boolean zoom;  //needs to be static!!!!!!!!! wow
    
    public ModelRenderer(boolean useTranslucentBackground, Context context, float[] coordinates, int[] colors, float[] radii)
    {
        mTranslucentBackground = useTranslucentBackground;

        model = new Model(context, coordinates, colors, radii);                                               //3
        
    }

    public void onDrawFrame(GL10 gl)                                          //4
    {
  	
    	
        gl.glClear(GL10.GL_COLOR_BUFFER_BIT | GL10.GL_DEPTH_BUFFER_BIT);      //5

        gl.glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
        
        gl.glMatrixMode(GL10.GL_MODELVIEW);                                   //6
        gl.glLoadIdentity();                                                  //7
        //GLU.gluLookAt(gl, mAngle, 0.0f, 8.5f, 2.0f, 1.5f, 0, 0.0f, 2.0f, 0.0f); 
        gl.glTranslatef(-1.5f,-1.0f, -12.0f);                //

        if(zoom == false) {
        	gl.glRotatef(mAngle, 0.0f, 1.0f, 0.0f);
        } 
        else if (zoom == true) {
        	gl.glScalef(1.0f, 1.0f, mAngle/5);
        }
        
        gl.glEnableClientState(GL10.GL_VERTEX_ARRAY);                         //9
        gl.glEnableClientState(GL10.GL_COLOR_ARRAY);

        model.draw(gl);                                                     //10
    
    }

    public void onSurfaceChanged(GL10 gl, int width, int height)              //11
    {
           gl.glViewport(0, 0, width, height);                                //12

           float aspectRatio;
           float zNear =  .1f;
           float zFar = 1000;
           float fieldOfView = (30.0f/57.3f);
           float size;
           
           gl.glEnable(GL10.GL_NORMALIZE);
           
           aspectRatio = (float) width/ (float) height;
           
           gl.glMatrixMode(GL10.GL_PROJECTION);
           
           size = zNear * (float) (Math.tan((double) (fieldOfView/2.0f)));
           
           gl.glFrustumf(-size, size, -size/aspectRatio, size/aspectRatio, zNear, zFar);
           
           gl.glMatrixMode(GL10.GL_MODELVIEW);
           
           
    }

    public void onSurfaceCreated(GL10 gl, EGLConfig config)                   //15
    {
        gl.glDisable(GL10.GL_DITHER);                                         //16

        gl.glHint(GL10.GL_PERSPECTIVE_CORRECTION_HINT,                        //17
                 GL10.GL_FASTEST);

             if (mTranslucentBackground)                                      //18
         {
             gl.glClearColor(0,0,0,0);
         }
             else
         {

             gl.glClearColor(1,1,1,1);
         }
         gl.glEnable(GL10.GL_CULL_FACE);                                      //19
         gl.glShadeModel(GL10.GL_SMOOTH);                                     //20
         gl.glEnable(GL10.GL_DEPTH_TEST);                                     //21
	    }
    
    
    public static int loadShader(int type, String shaderCode){

        // create a vertex shader type (GLES20.GL_VERTEX_SHADER)
        // or a fragment shader type (GLES20.GL_FRAGMENT_SHADER)
        int shader = GLES20.glCreateShader(type);

        // add the source code to the shader and compile it
        GLES20.glShaderSource(shader, shaderCode);
        GLES20.glCompileShader(shader);

        return shader;
    }

    
    public void setmAngle(float mAngle) {
    	this.mAngle = mAngle;
    }
    public float getmAngle() {
    	return mAngle;
    }
    
    public void setZoom(boolean zoom) {
    	this.zoom = zoom;
    	Log.v("zoom", String.valueOf(zoom));
    }
    public boolean getZoom() {
    	return zoom;
    }
}

	
	
	

