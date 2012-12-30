import java.lang.System;

public class Driver {

	public Driver() {
		//empty constructor
	}

	public static void main(String[] args) {

		Node node = new Node(1,1,4,3,null, null);
        node.setNextNode(new Node(5, 5, 10, 10, null, null));

		System.out.println("successful");
		System.out.println("Dot product is: " + node.getTheta());
        System.out.println("Is this a branch node: " + node.isBranchNode());
        System.out.println("Is this an end node: " + node.isEndNode());

        Graph g = new Graph(node);
        g.bfs(1, 1);
	}




}
