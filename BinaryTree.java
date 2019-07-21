import java.util.ArrayList;
import java.util.List;

public class BinaryTree<T> {
	private Node<T> head;
	
	public BinaryTree() {
		
	}
	
	public void printLevel() {
		List<List<Float>> tree = new ArrayList<List<Float>>();
		printLevel(head, 0, tree);
		for(int i=0; i<tree.size(); i++) {
			for(int j=0; j<tree.get(i).size(); j++) {
				System.out.print(tree.get(i).get(j) + " ");
			}
			System.out.println(" ");
		}
	}
	
	public void printLevel(Node<T> node, int index, List<List<Float>> tree) {
		if(node == null) return;
		if(tree.size() <= index) tree.add(new ArrayList<Float>());
		tree.get(index).add(new Float(node.getValue()));
		printLevel(node.getLeftChild(), index+1, tree);
		printLevel(node.getRightChild(), index+1, tree);
	}
	
	public void print2() {
		print2(head);
	}
	
	public void print2(Node<T> node) {
		if(node == null) {
			System.out.print("null");
			return;
		}
		System.out.print(node);
		if(node.hasChild()) {
			System.out.print("(");
			print2(node.getLeftChild());
			System.out.print(",");
			print2(node.getRightChild());
			System.out.print(")");
		}
	}
	
	public void add(float value, T reference) {
		if(head == null) 
			head = new Node<T>(value, reference);
		else
			add(head, new Node<T>(value, reference));
	}
	
	private void add(Node target, Node current) {
		if(current.getValue() < target.getValue()) {
			if(!target.hasLeftChild()) {
				target.setLeftChild(current);
				current.setParent(target);
				return;
			}
			add(target.getLeftChild(), current);
		}else {
			if(!target.hasRightChild()) {
				target.setRightChild(current);
				current.setParent(target);
				return;
			}
			add(target.getRightChild(), current);
		}
	}
	
	public Node<T> min(Node node) {
    if(node == null) return null;
		Node min = node;
		while(min.hasLeftChild()) {
			min = min.getLeftChild();
		}
		return min;
	}
	
	public Node<T> min() {
		return min(head);
	}
	
	public Node<T> max(Node node) {
    if(node == null) return null;
		Node max = node;
		while(max.hasRightChild()) {
			max = max.getRightChild();
		}
		return max;
	}
	
	public Node<T> max() {
		return max(head);
	}
	
	public Node<T> find(float value) {
		return find(value, head);
	}
	
	public Node<T> find(float value, Node<T> target) {
		if(target == null || target.getValue() == value) return target;
		if(value < target.getValue()) {
			return find(value, target.getLeftChild());
		}else {
			return find(value, target.getRightChild());
		}
	}

  public Node<T> findByReference(float value, T reference){
    Node<T> target = find(value);
    if(target == null || target.getReference() == reference) return target;
    while(target.hasRightChild()){
      if(target.getRightChild().getReference() == reference) return target.getRightChild();
      target = target.getRightChild();
    }
    return null;
  }

	
	public Node remove(float value) {
		return remove(find(value));
	}
	
	public Node remove(Node<T> target) {
		if(target == null) return null;
		
		Node<T> replacement = target.getRightChild();
		if(target.hasLeftChild()) {
			replacement = max(target.getLeftChild());
			if(target.getLeftChild() != replacement) 
				replacement.setLeftChild(target.getLeftChild());
			replacement.setRightChild(target.getRightChild());
		}
		
		if(replacement != null && replacement.getParent() != target) 
			replacement.getParent().setRightChild(null);
		
		if(target == head) {
			head = replacement;
			if(target.hasLeftChild() && target.getLeftChild() != replacement)
				target.getLeftChild().setParent(replacement);
			if(target.hasRightChild())
				target.getRightChild().setParent(replacement);
		}else {
			if(target.getValue() < target.getParent().getValue()) {
				target.getParent().setLeftChild(replacement);
			}else {
				target.getParent().setRightChild(replacement);
			}
		}
		if(replacement != null)
			replacement.setParent(target.getParent());
		
		return target;
	}
	
	
}
