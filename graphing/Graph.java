//Joseph Furlott
//head will be at the optic nerve while the end where be where the is no branch but also no vessel..
//will need to first define the optic nerve using matlab ---> head node
//build from there
//end node will be that last node
//one graph will be whole vessel, so each eye will have about 10-15 graphs
//another java file will hold the list of all the graphs

// is edge weight important?!?!!?

import java.util.ArrayList;

public class Graph extends ArrayList {

    public Graph() {

    }

    //need better constructor that builds a graph out of nodes
    //should be done just like an arraylist



    //not tested as of 12/29
    //just returns two nodes that a certain node is connected (directed)
    public ArrayList<Node> neighbors(Node x) {
        ArrayList<Node> neighborList = new ArrayList<Node>();
        neighborList.add(x.getNextNode());
        neighborList.add(x.getBranchNode());

        return neighborList;
    }


    //checks whether second node is connected to the first node as either a branch or just the next in the vessel
    //assumed to be a directed graph
    public boolean adjacent(Node first, Node second) {
        //check based off coordinates

        //first check the next node
        if(first.getNextNode().getCurrentX() == second.getCurrentX()) {
            if(first.getNextNode().getCurrentY() == second.getCurrentY()) {
                return true;
            }
            else
                return false;
        }  //now check the branched off node:
        else if(first.getBranchNode().getCurrentX() == second.getCurrentX()) {
            if(first.getBranchNode().getCurrentY() == second.getCurrentY()) {
                return true;
            }
            else
                return false;
        }
        else {
            return false;
        }

    }

    //build two edges between the nodes
    //maybe need to do a try catch for a NullPointerException
    public boolean add(Node current, Node next, Node branch) {
        //could be helpful in constructing the graph

        current.setNextNode(next);
        current.setBranchNode(branch);
        return true;

    }



    public void delete(Node current, boolean branch) {
        if(branch == true) {
            current.setBranchNode(null);
        }
        else if(branch == false) {
            current.setNextNode(null);
        }

    }



}
