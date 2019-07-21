import java.util.*;
import processing.core.*;

class Tile{
  private Tile parent;
  private int g;
  private float h;
  private float f;
  private PVector position;
  
  public Tile(Tile parent, int g, float h, float f, PVector position){
    this.parent = parent;
    this.g = g;
    this.h = h;
    this.f = f;
    this.position = position;
  }
  
  public Tile(Tile parent, int g, float h, PVector position){
    this.parent = parent;
    this.g = g;
    this.h = h;
    this.f = g + h;
    this.position = position;
  }
  
  public Tile(Tile parent, int g, PVector position){
    this.parent = parent;
    this.g = g;
    this.position = position;
  }
  
  public Tile(int g, float h, PVector position){
    this.g = g;
    this.h = h;
    this.f = g + h;
    this.position = position;
  }
  
  public Tile(float f, PVector position){
    this.f = f;
    this.position = position;
  }
  
  public boolean isOn(Tile tile){
    return this.position.dist(tile.getPosition()) == 0;
  }
  
  public List<PVector> getNeighbors(){
    List<PVector> neighbors = new ArrayList<PVector>();
    for(int i=-1; i<2; i++){
      for(int j=-1; j<2; j++){
        if(Math.abs(i + j) == 1){
          neighbors.add(new PVector(position.x + j, position.y + i));
        }
      }
    }
    return neighbors;
  }
  
  public Tile getParent(){
    return parent;
  }
  
  public int getG(){
    return g;
  }
  
  public void updateG(int g){
    this.g = g;
    this.f = g + h;
  }
  
  public float getH(){
    return h;
  }
  
  public float getF(){
    return f;
  }
  
  public PVector getPosition(){
    return position;
  }
}
