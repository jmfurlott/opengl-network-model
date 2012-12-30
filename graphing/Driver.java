import java.lang.System;

public class Driver {

	public Driver() {
		//empty constructor
	}

	public static void main(String[] args) {

        Node node1 = new Node(1,1,0,0,null, null);
        Node node2 = new Node(2,2,0,0,null, null);
        Node node3 = new Node(3,3,0,0,null, null);
        Node node4 = new Node(4,4,0,0,null, null);
        Node node5 = new Node(5,5,0,0,null, null);
        Node node6 = new Node(6,6,0,0,null, null);

        node1.setNextNode(node2);
        node2.setNextNode(node3);
        node3.setNextNode(node4);
        node4.setNextNode(node5);


		System.out.println("successful");
		System.out.println("Dot product is: " + node1.getTheta());
        System.out.println("Is this a branch node: " + node1.isBranchNode());
        System.out.println("Is this an end node: " + node1.isEndNode());

        Graph g = new Graph(node1);
        g.bfs(5, 5);
	}




}
