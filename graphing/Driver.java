public class Driver {

	public Driver() {
		//empty constructor
	}

	public static void main(String[] args) {
		Node holder1 = new Node();
		Node holder2 = new Node();
		Node node = new Node(1,1,4,3,holder1, holder2);
		System.out.println("successful");
		System.out.println("Dot product is: " + node.getTheta());
	}




}
