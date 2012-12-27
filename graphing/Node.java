//Joseph Furlott
//a Node is defined as a part in a vessel that has a branch, the optic nerve, or the end of a vessel

//contains: branch node and its coordinates, next node and its coordinates, theta in between those nodes
import java.lang.Math;

public class Node {

    private int x, y;  //coordinates of the current node
    private int bx, by; //coordinates of the branch
    private double theta; //calculated not on the constructor but via a dot product method
    private Node branchNode, nextNode;


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

    public double getTheta() {
        return theta;
    }

    public void setTheta(double theta) {
        this.theta = theta;
    }

}