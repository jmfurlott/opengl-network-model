//will contain all the information for one eye
//will contain several graphs making the eye based on sections.

//TODO: things that don't need correct building of graphs from images like printing out coordinates etc
    //maybe shoot it to the model?!?!?! by outputting the same format text file; would be cool

import java.lang.*;
import java.lang.IndexOutOfBoundsException;
import java.lang.Integer;
import java.lang.String;
import java.lang.System;
import java.util.ArrayList;

public class Network {
    private ArrayList<Graph> network; //not sure if should be arraylist but oh well

    public Network() {
        //empty; needs parameters to be properly constructured
        network = null;
    }

    public Network(String filename) {
        //filename says where to look for the coordinates
        ReadCoordinates reader = new ReadCoordinates();

        //have all coordinates read in
        ArrayList<Integer> allCoordinates = reader.read(filename);

        //now build from list of all the coordinates
        network = buildNetwork(allCoordinates);
        //debugging::
        System.out.println("Total number of coordinates(inc. z): " + allCoordinates.size());
        System.out.println("Total number of graphs in network: " + network.size());

        //then method to handle the branches

    }


    //build Network!!!!! main method
    public ArrayList<Graph> buildNetwork(ArrayList<Integer> allCoordinates) {
        ArrayList<Graph> graphs = new ArrayList<Graph>();

        //must first build list of nodes and then with each root node at to the
        //remember this contains the zth coordinate that we do not need!!
        Node graphRoot = null; //the node that is the root of a certain graph (not necessary the optic disc, but thats what 'root' should be

        boolean flag = false;

        for(int i = 0; i < allCoordinates.size()-10; i += 7) { //i is the one by one coordinate for loop
                                                //obviously fix this -10 issue but okay for now
            int x0 = allCoordinates.get(i).intValue();
            int y0 = allCoordinates.get(i+1).intValue();
            //skip z
            int x1 = allCoordinates.get(i+3); //account for z
            int y1 = allCoordinates.get(i+4);

            int x2 = allCoordinates.get(i+8);
            int y2 = allCoordinates.get(i+9);

            if(!flag) {
                graphRoot = new Node(x0,y0, 0, 0, null, null); //okay so root node of this certain graph is set
            }

            if(x1 == x2 && y1 == y2) {
                graphRoot.setNextNode(new Node(x1,y1,0,0,null,null)); //append node
                graphRoot = graphRoot.getNextNode(); //change root
                flag = true;
            } else {
                graphs.add(new Graph(graphRoot));

                flag = false;
            }


            //nope nope wrong REDO

        }

        //deconstruct the allCoordinates list since we don't need it now; save memory
        allCoordinates.clear();


        return graphs;
    }

    //build Network will not take into account the branching so do that for another method..where there is a graph that
    //has two nodes at the same x0,y0,z0 but leads to two different places
    //public ArrayList<Graph> handleBranches(ArrayList<Graph> semibuiltNetwork)


}