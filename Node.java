
public class Node<T> {
	private T reference;
	
	private Node<T> parent;
	private Node<T> leftChild;
	private Node<T> rightChild;
	private float value;
	
	public Node(Node<T> parent, Node<T> leftChild, Node<T> rightChild, int value, T reference) {
		this.reference = reference;
		
		this.parent = parent;
		this.leftChild = leftChild;
		this.rightChild = rightChild;
		this.value = value;
	}
	
	public Node(float value, T reference) {
		this.reference = reference;
		this.value = value;
	}
	
	public float getValue() {
		return value;
	}
	
	public boolean hasParent() {
		return parent != null;
	}
	
	public boolean hasRightChild() {
		return rightChild != null;
	}
	
	public boolean hasLeftChild() {
		return leftChild != null;
	}
	
	public boolean hasChild() {
		return hasLeftChild() || hasRightChild();
	}

	public Node<T> getParent() {
		return parent;
	}

	public Node<T> getLeftChild() {
		return leftChild;
	}

	public Node<T> getRightChild() {
		return rightChild;
	}
	
	public T getReference(){
		return reference;
	}

	public void setParent(Node<T> parent) {
		this.parent = parent;
	}

	public void setLeftChild(Node<T> leftChild) {
		this.leftChild = leftChild;
	}

	public void setRightChild(Node<T> rightChild) {
		this.rightChild = rightChild;
	}
	
	public String toString() {
		return "" + value;
	}
}
