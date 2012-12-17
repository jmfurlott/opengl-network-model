package com.retinopathyModel;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

import android.content.Context;
import android.opengl.GLSurfaceView;
//1
//2

class ModelRenderer implements GLSurfaceView.Renderer
{
	
    private boolean mTranslucentBackground;
    private Model model;
    private float mTransY;
    private float mAngle;
    
    public ModelRenderer(boolean useTranslucentBackground, Context context, float[] coordinates)
    {
        mTranslucentBackground = useTranslucentBackground;
        model = new Model(context, coordinates);                                               //3
    }

    public void onDrawFrame(GL10 gl)                                          //4
    {

        gl.glClear(GL10.GL_COLOR_BUFFER_BIT | GL10.GL_DEPTH_BUFFER_BIT);      //5

        gl.glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
        
        gl.glMatrixMode(GL10.GL_MODELVIEW);                                   //6
        gl.glLoadIdentity();                                                  //7
 

        
        gl.glTranslatef(-2.0f,(float)Math.sin(mTransY), -7.0f);                //
        //handles the rotation
       // gl.glRotatef(mAngle, 0.0f, 1.0f, 0.0f);
       // gl.glRotatef(mAngle, 1.0f, 0.0f, 0.0f);
        
        
        gl.glEnableClientState(GL10.GL_VERTEX_ARRAY);                         //9
         gl.glEnableClientState(GL10.GL_COLOR_ARRAY);

        model.draw(gl);                                                     //10

    //    mTransY += .075f;
    //    mAngle += .4;
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

}

	
	
	

