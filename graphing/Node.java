//Joseph Furlott

//TODO: how to create a list of nodes using the constructor???




//a Node is defined as a part in a vessel that has a branch, the optic nerve, or the end of a vessel

//contains: branch node and its coordinates, next node and its coordinates, theta in between those nodes
import java.lang.Math;

public class Node {

    private int x, y;  //coordinates of the current node
    private int bx, by; //coordinates of the branch
    private double theta; //calculated not on the constructor but via a dot product method
    private Node branchNode, nextNode;
    private double width; //width of the vessel


    public Node() {
        //empty constructors
    }

    public Node(int cx, int cy, int bx, int by, Node nextNode, Node branchNode) {
        x = cx;
        y = cy;
        this.bx = bx;
        this.by = by;

        //dot product method
        theta = calculateTheta(cx, cy, bx, by);

        this.nextNode = nextNode;   //not sure about this or how to build the next node
        this.branchNode = branchNode;

    }

    //with width of vessel
    public Node(int cx, int cy, int bx, int by, Node nextNode, Node branchNode, double width) {
        x = cx;
        y = cy;
        this.bx = bx;
        this.by = by;

        //dot product method
        theta = calculateTheta(cx, cy, bx, by);

        this.nextNode = nextNode;   //not sure about this or how to build the next node
        this.branchNode = branchNode;

        this.width = width;
    }


    public double calculateTheta(int cx, int cy, int bx, int by) {
        //works okay. prints out in radians. maybe convert to angle?

        int x1 = cx;
        int x2 = bx;
        int y1 = cy;
        int y2 = by;

        double angle;
        double dot = x1*x2 + y1*y2;
        double magA =  Math.sqrt(x1*x1 + y1*y1 );
        double magB =  Math.sqrt(x2*x2 + y2*y2);
        //just the equation
        angle =  Math.acos( (dot/(magA*magB)));

        return angle;

    }

    //check to see if branch node or not
    public boolean isBranchNode() {
        if (this.branchNode == null) {
            return false;
        }
        else {
            return true;
        }
    }

    //same check but end node
    public boolean isEndNode() {
        if(this.nextNode == null && this.branchNode == null) {
            return true;
        }
        else
            return false;
    }




    //   get/setters!

    public double getTheta() {
        return theta;
    }
    public void setTheta(double theta) {
        this.theta = theta;
    }

    public int getCurrentX() {
        return x;
    }
    public void setCurrentX(int x) {
        this.x = x;
    }

    public int getCurrentY() {
        return y;
    }
    public void setCurrentY( int y) {
        this.y = y;
    }

    public int getBranchX() {
        return bx;
    }
    public void setBranchX(int bx) {
        this.bx = bx;
    }

    public int getBranchY() {
        return by;
    }
    public void setBranchY(int by) {
        this.by = by;
    }

    public double getWidth() {
        return width;
    }
    public void setWidth(double width) {
        this.width = width;
    }

    public Node getNextNode() {
        return nextNode;
    }
    public void setNextNode(Node node) {
        this.nextNode = node;
    }

    public Node getBranchNode() {
        return branchNode;
    }
    public void setBranchNode(Node node) {
        this.branchNode = node;
    }
}