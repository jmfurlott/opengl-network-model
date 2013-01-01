import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.String;
import java.util.ArrayList;


// X1  Y1  Z1  X2  Y2  Z2  D  A/V

public class ReadCoordinates {
    InputStream is;
    ArrayList<Integer> coordinates;
//    ArrayList<Integer> colorsList;
//    ArrayList<Integer> radiusList;
    public ReadCoordinates() {
        is = null;
        coordinates = new ArrayList<Integer>();
//        colorsList = new ArrayList<Integer>();
//        radiusList = new ArrayList<Integer>();

    }

    public  ArrayList<Integer> read(String file) {
        //where my coordinates/colors/radii are going to be held
        coordinates = new ArrayList<Integer>();
//        colorsList = new ArrayList<Integer>();
//        radiusList = new ArrayList<Integer>();

        //begin try catch of opening and reading the file
        try {

//            Log.v("try catch", "true");

//            AssetManager am = context.getAssets();

            is = new FileInputStream(file);
            InputStreamReader inputStreamReader = new InputStreamReader(is);

            BufferedReader reader = new BufferedReader(inputStreamReader);
//            Log.v("try catch", "buffer is open");

            //read in top header line
            String header = reader.readLine();
//            Log.v("try catch", header);
            //begin the reading of coordinates
            //stored in a one dimensional arrayList (should be faster/less memory)

            int flag = 0;
            String temp;
            while( (temp = reader.readLine()) != null) {
                String[] line = temp.split(" ");
                //Log.v("whole line", line[0]);
                for(int i = 0; i < line.length; i++) {
                    if(flag < 6) {
                        coordinates.add(Integer.parseInt(line[i]));
                        flag++;
                    } else if (flag == 6) {
                        String radius = line[i];
                        flag++;
                    } else if (flag == 7) {
                        String color = line[i];
                        flag = 0;
                    }

                }

            }

        } catch (Exception e) {
            e.printStackTrace();


        }



        return coordinates;

    }



}
