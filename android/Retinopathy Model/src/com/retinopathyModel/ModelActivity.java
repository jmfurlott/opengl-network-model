package com.retinopathyModel;




import java.io.File;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;

//import com.example.opengltut.R;



public class ModelActivity extends Activity {

	Context context = this;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //setContentView(R.layout.activity_bouncy_square_acitivity);
        
     //   getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
       // GLSurfaceView view = new GLSurfaceView(this);
        
        File file = this.getFileStreamPath("Coordinates10.txt");
        ReadInCoordinates read = new ReadInCoordinates();
        File myDir = new File(context.getFilesDir().getAbsolutePath());
        
        Log.v("read", "started to");
        
        int flag = read.read(myDir, "/Coordinates10.txt", this);
        Log.v("read" , "successful");
        setContentView(R.layout.activity_model);
        //view.setRenderer(ModelRenderer(true));
        
        
        //view.setRenderer(new SquareRenderer(true));
        ///setContentView(view);
        
        
    }

}
