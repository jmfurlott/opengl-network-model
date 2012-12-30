//Joseph Furlott
//head will be at the optic nerve while the end where be where the is no branch but also no vessel..
//will need to first define the optic nerve using matlab ---> head node
//build from there
//end node will be that last node
//one graph will be whole vessel, so each eye will have about 10-15 graphs
//another java file will hold the list of all the graphs

// is edge weight important?!?!!?

import java.lang.System;
import java.util.LinkedList;
import java.util.Queue;


public class Graph extends LinkedList {
    private Node root;

    public Graph() {

    }

    //need better constructor that builds a graph out of nodes
    //just set the root node and it will connect to the rest like a LinkedList
    public Graph(Node root) {
        this.root = root;
    }


    //not tested as of 12/29
    //just returns two nodes that a certain node is connected (directed)
    public LinkedList<Node> neighbors(Node x) {
        LinkedList<Node> neighborList = new LinkedList<Node>();
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


    //SEARCHING METHODS first BFS

    //semi-working but only takes in account for next nodes but no branches!
    //working otherwise; also added position which is doubtful that it is the true position

    public Node bfs(int x, int y) {
        int position = 0;
        Queue q = new LinkedList();
        q.add(this.root);

        while(this.root.getNextNode() != null) {
            q.add(root.getNextNode());
            root = root.getNextNode();
        }

        //for debugging, print the root node and what is being searched
        System.out.println("The root node's coordinates are: " + root.getCurrentX() + " " + root.getCurrentY());
        System.out.println("The coordinates you are searching for are: " + x + " " + y);

        while(!q.isEmpty()) {
            Node node = (Node) q.remove();
            position++;
            if(node.getCurrentX() == x && node.getCurrentY() == y) {
                System.out.println("Node found at " + node.printData() + " And is at position: " + position);
                return node;
            }

        }

        //means we couldn't find it
        System.out.println("Couldn't find node.");
        return null;

    }


}
