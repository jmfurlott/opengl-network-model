package com.retinopathyModel;




import android.app.Activity;
import android.content.Context;
import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.view.WindowManager;




public class ModelActivity extends Activity {

	Context context = this;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //setContentView(R.layout.activity_bouncy_square_acitivity);
        
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        GLSurfaceView view = new GLSurfaceView(this);

        
        /* Part of the Model class now
        File file = this.getFileStreamPath("Coordinates10.txt");
        ReadInCoordinates read = new ReadInCoordinates();
        File myDir = new File(context.getFilesDir().getAbsolutePath());
        
        Log.v("read", "started to");
        
        ArrayList<Integer> coordinates = read.read(myDir, "/Coordinates10.txt", this);
        Log.v("read" , "successful");
        */
        
        
        
        //setContentView(R.layout.activity_model);
        view.setRenderer(new ModelRenderer(true));
           
        
        
        //view.setRenderer(new SquareRenderer(true));
        setContentView(view);
        
        
    }

}
