package com.retinopathyModel;




import java.io.File;
import java.util.ArrayList;

import android.app.Activity;
import android.content.Context;
import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.util.Log;
import android.view.WindowManager;




public class ModelActivity extends Activity {
	public float[] coordinates;
	Context context = this;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //setContentView(R.layout.activity_bouncy_square_acitivity);
        
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        GLSurfaceView view = new GLSurfaceView(this);

        
        // Part of the Model class now
        //File file = this.getFileStreamPath("Coordinates10.txt");
        ReadInCoordinates read = new ReadInCoordinates();
        File myDir = new File(context.getFilesDir().getAbsolutePath());
        
        Log.v("read", "started to");
        
        ArrayList<Integer> coordsList = read.readOnlyCoordinates(myDir, "Coordinates10.txt", this);
        Log.v("read" , "successful");
       // Log.v("read", String.valueOf(coordsList.size()));
        coordinates = new float[coordsList.size()];
        for(int i = 0; i < coordsList.size(); i++) {
        	coordinates[i] = (float) coordsList.get(i).intValue();
        }
        
        for(int i = 0; i < 10; i++) {
        	Log.v("coordinates", String.valueOf(coordinates[i]));
        }
        
		
        //Log.v("coordinates", coordsList.get(0).toString());
        
        //setContentView(R.layout.activity_model);
        view.setRenderer(new ModelRenderer(true, this, coordinates));
           
        
        
        //view.setRenderer(new SquareRenderer(true));
        setContentView(view);
        
        
    }

}
