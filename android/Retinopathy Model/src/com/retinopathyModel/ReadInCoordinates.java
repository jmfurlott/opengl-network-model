package com.retinopathyModel;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;

import android.content.Context;
import android.content.res.AssetManager;
import android.util.Log;
//class that will read in from a text file and contain the coordinates/vertices of the model
//it will also have radius and color of each vessel depending on whether artery or vein
//where artery = blue and vein = red

//text file form (stored in assets/):
// X1  Y1  Z1  X2  Y2  Z2  D  A/V



public class ReadInCoordinates {
	
	
	public ReadInCoordinates() {
		//empty constructor for now
		//will need to pass in text file name eventually
	}
	
	public int read(File myDir, String file, Context context) {
		//where my coordinates are going to be held
		ArrayList<Integer> coordinates = new ArrayList<Integer>();
		
		//begin try catch of opening and reading the file
		try {
			
			Log.v("try catch", "true");

			AssetManager am = context.getAssets();
			InputStream is = am.open(file);
			InputStreamReader inputStreamReader = new InputStreamReader(is);
			
			BufferedReader reader = new BufferedReader(inputStreamReader);
			Log.v("buffer opened", "true");
			
			//read in top header line
			String header = reader.readLine();
			
			//begin the reading of coordinates
			//stored in a one dimensional arrayList (should be faster/less memory)
			String temp;
			while( (temp = reader.readLine()) != null) {
				String[] line = temp.split(" ");
				Log.v("whole line", line[0]);
				for(int i = 0; i < line.length; i++) {
					coordinates.add(Integer.parseInt(line[i]));
					
				}
				
			}
			
			
			
		} catch (Exception e) {
			e.printStackTrace();
			Log.v("expcetion", e.toString());
		}
		
		
		
		
		return 1;
	}


}
