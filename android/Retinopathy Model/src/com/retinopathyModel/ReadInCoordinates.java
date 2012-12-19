package com.retinopathyModel;

import java.io.BufferedReader;
import java.io.File;
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
	InputStream is;
	ArrayList<Integer> coordinates;
	ArrayList<Integer> colorsList; 
	
	public ReadInCoordinates() {
		is = null;
		coordinates = new ArrayList<Integer>();
		colorsList = new ArrayList<Integer>();
		
	}
	
	public  ArrayList<Integer> read(File myDir, String file, Context context) {
		//where my coordinates are going to be held
		coordinates = new ArrayList<Integer>();
		colorsList = new ArrayList<Integer>();
		
		//begin try catch of opening and reading the file
		try {
			
			Log.v("try catch", "true");

			AssetManager am = context.getAssets();
			is = am.open(file);
			InputStreamReader inputStreamReader = new InputStreamReader(is);
			
			BufferedReader reader = new BufferedReader(inputStreamReader);
			Log.v("try catch", "buffer is open");
			
			//read in top header line
			String header = reader.readLine();
			Log.v("try catch", header);
			//begin the reading of coordinates
			//stored in a one dimensional arrayList (should be faster/less memory)
			String temp;
			while( (temp = reader.readLine()) != null) {
				String[] line = temp.split(" ");
				//Log.v("whole line", line[0]);
				for(int i = 0; i < line.length; i++) {
					coordinates.add(Integer.parseInt(line[i]));
					
				}
				
			}
			
			Log.v("try catch", String.valueOf(coordinates.get(8)));
		} catch (Exception e) {
			e.printStackTrace();
			Log.v("expcetion", e.toString());
			
		}
		
		
		
		return coordinates;
		
	}

	public  ArrayList<Integer> readOnlyCoordinates(File myDir, String file, Context context) {
		//where my coordinates are going to be held
		coordinates = new ArrayList<Integer>();
		
		//how I know not to read in color or diameter
		int flag = 0;
		int tempColor, tempDiameter;
		
		//begin try catch of opening and reading the file
		try {
			
			Log.v("try catch", "true");

			AssetManager am = context.getAssets();
			is = am.open(file);
			InputStreamReader inputStreamReader = new InputStreamReader(is);
			
			BufferedReader reader = new BufferedReader(inputStreamReader);
			Log.v("try catch", "buffer is open");
			
			//read in top header line
			String header = reader.readLine();
			Log.v("try catch", header);
			//begin the reading of coordinates
			//stored in a one dimensional arrayList (should be faster/less memory)
			String temp;
			while( (temp = reader.readLine()) != null) {
				String[] line = temp.split(" ");
				//Log.v("whole line", line[0]);
				for(int i = 0; i < line.length; i++) {
					
					if(flag < 6) {
						coordinates.add(Integer.parseInt(line[i]));
						flag++;
					}
					else if (flag == 6) {
						tempDiameter = Integer.parseInt(line[i]);
						flag++;
					}
					else if(flag == 7) {
						tempColor = Integer.parseInt(line[i]);
						colorsList.add(tempColor);
						flag = 0;
						break;
					}
				}
				
			}
			
			Log.v("try catch", String.valueOf(coordinates.get(8)));
		} catch (Exception e) {
			e.printStackTrace();
			Log.v("expcetion", e.toString());
			
		}
		
		return coordinates;
		
	}
	
	
	public ArrayList<Integer> getCoordinatesArrayList() {
		return coordinates;
	}
	
	public ArrayList<Integer> getColorsArrayList() {
		return colorsList;
	}
	
}
