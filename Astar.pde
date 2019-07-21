import java.util.*;


//grid parameters
int tileSize = 20;
float sizeMultiplier = 1;
int cellSize = (int)(tileSize * sizeMultiplier);
int deltaX = 0;
int deltaY = 0;

//mouse
float mouseWheelStep = 0.5f;

boolean isDraggingLeft = false;
boolean isDraggingRight = false;

//A*
boolean isSolving = false;

Tile startTile = null;
Tile endTile = null;

HashMap<PVector, Boolean> walls = new HashMap<PVector, Boolean>();
HashMap<PVector, Tile> pending = new HashMap<PVector, Tile>();
BinaryTree<Tile> pendingTree = new BinaryTree<Tile>();
HashMap<PVector, Tile> done = new HashMap<PVector, Tile>();
List<PVector> path = new ArrayList<PVector>();

void setup(){
  size(1000, 1000);
}

void draw(){
  background(255);
  if(!isSolving){
    handleDragging();
  }else{
    if(!pending.isEmpty()){
      astar_step();
    }else{
      isSolving = false;
    }
  }
  drawGrid();
  drawPending();
  drawDone();
  drawPath();
  drawWalls();
  drawStart();
  drawEnd();
  drawCursor();
}

void setPath(Tile tile){
  Tile target = tile;
  while(target.getParent() != null){
    target = target.getParent();
    path.add(0, target.getPosition());
  }
}

void astar_step(){
  Node<Tile> least = pendingTree.min();
  pendingTree.remove(least);
  if(least == null){
    isSolving = false;
    return;
  }
  done.put(least.getReference().getPosition(), least.getReference());
  
  if(isEnd(least.getReference())){
    isSolving = false;
    setPath(least.getReference());
    return;
  }
  
  List<PVector> neighbors = least.getReference().getNeighbors();
  for(PVector neighbor:neighbors){
    
    int g = least.getReference().getG() + 1;
    float h = neighbor.dist(endTile.getPosition());
    int maxX = (int)width/tileSize;
    int maxY = (int)height/tileSize;
    
    if(neighbor.x >= 0 && neighbor.y >= 0 && neighbor.x < maxX && neighbor.y < maxY){
      if(done.get(neighbor) == null && walls.get(neighbor) == null){
        if(pending.get(neighbor) == null){
          Tile newTile = new Tile(least.getReference(), g, h, neighbor);
          pending.put(neighbor, newTile);
          pendingTree.add(g + h, newTile);
        }else{
          if(pending.get(neighbor).getG() > g){
            Tile tile = pending.get(neighbor);
            pendingTree.remove(pendingTree.findByReference(tile.getF(), tile));
            tile.updateG(g);
            pendingTree.add(tile.getF(), tile);
          }
        }
      }
    }
  }
}

void drawGrid(){
  stroke(0);
  for(int y=0; y<height*sizeMultiplier; y+=cellSize){
    line(0, y-deltaY, width, y-deltaY);
  }
  for(int x=0; x<width*sizeMultiplier; x+=cellSize){
    line(x-deltaX, 0, x-deltaX, height);
  }
}

void drawCursor(){
  int mouseI = (mouseY + deltaY)/cellSize;
  int mouseJ = (mouseX + deltaX)/cellSize;
  
  fill(0, 0, 255);
  rect(getOldGrid(mouseJ, deltaX),  getOldGrid(mouseI, deltaY), cellSize, cellSize);
}

void drawWalls(){
  for(Map.Entry wall:walls.entrySet()){
    fill(0);
    stroke(0);
    rect(getOldGrid((int)(((PVector)wall.getKey()).x), deltaX), getOldGrid((int)(((PVector)wall.getKey()).y), deltaY), cellSize, cellSize);
  }
}

void drawStart(){
  if(startTile != null){
    fill(66, 135, 245);
    stroke(66, 135, 245);
    rect(getOldGrid((int)startTile.getPosition().x, deltaX), getOldGrid((int)startTile.getPosition().y, deltaY), cellSize, cellSize);
  }
}

void drawEnd(){
  if(endTile != null){
    fill(255, 162, 0);
    stroke(255, 162, 0);
    rect(getOldGrid((int)endTile.getPosition().x, deltaX), getOldGrid((int)endTile.getPosition().y, deltaY), cellSize, cellSize);
  }
}

void drawPending(){
  for(Map.Entry p:pending.entrySet()){
    fill(244, 252, 0);
    stroke(244, 252, 0);
    rect(getOldGrid((int)((PVector)p.getKey()).x, deltaX), getOldGrid((int)((PVector)p.getKey()).y, deltaX), cellSize, cellSize);
  }
}

void drawDone(){
  for(Map.Entry d:done.entrySet()){
    float f = ((Tile)d.getValue()).getF();
    float h = ((Tile)d.getValue()).getH();
    fill(255-f*f*0.25/h/0.3, 255, 0);
    stroke(159, 5, 255);
    rect(getOldGrid((int)((PVector)d.getKey()).x, deltaX), getOldGrid((int)((PVector)d.getKey()).y, deltaX), cellSize, cellSize);
  }
}

void drawPath(){
  for(PVector pos:path){
    fill(245, 90, 66);
    stroke(245, 90, 66);
    rect(getOldGrid((int)((PVector)pos).x, deltaX), getOldGrid((int)((PVector)pos).y, deltaY), cellSize, cellSize);
  }
}

void handleDragging(){
  int mouseI = (mouseY + deltaY)/cellSize;
  int mouseJ = (mouseX + deltaX)/cellSize;
  
  if(isDraggingLeft){
    if(walls.get(new PVector(mouseJ, mouseI)) == null){
      walls.put(new PVector(mouseJ, mouseI), true);
    }
  }
  if(isDraggingRight){
    if(walls.get(new PVector(mouseJ, mouseI)) != null){
      walls.remove(new PVector(mouseJ, mouseI));
    }
  } 
}

int getOldGrid(int pos, int delta){
  return pos * cellSize + 1 - delta;  
}

boolean isWall(int j, int i){
  return walls.get(new PVector(j, i)) != null;
}

boolean isEnd(Tile tile){
  return tile.getPosition().dist(endTile.getPosition()) == 0;
}

void mouseWheel(MouseEvent e){
  sizeMultiplier = max(1, sizeMultiplier + mouseWheelStep * -e.getCount());
  
  deltaX = (int)(mouseX * (sizeMultiplier - 1));
  deltaY = (int)(mouseY * (sizeMultiplier - 1));
  
  cellSize = (int)(tileSize * sizeMultiplier);
}

void mousePressed(MouseEvent e){
  if(mouseButton == LEFT){
    isDraggingLeft = true;
  }else if(mouseButton == RIGHT){
    isDraggingRight = true;
  }
}

void mouseReleased(MouseEvent e){
  if(mouseButton == LEFT){
    isDraggingLeft = false;
  }else if(mouseButton == RIGHT){
    isDraggingRight = false;
  }
}

void keyPressed(){
  // enter 10
  // s 115/ S 83
  // g 103/ G 71
  
  int mouseI = (mouseY + deltaY)/cellSize;
  int mouseJ = (mouseX + deltaX)/cellSize;
  switch(key){
    case 10:
      if(!isSolving){
        if(startTile != null && endTile != null){
          pending = new HashMap<PVector, Tile>();
          pendingTree = new BinaryTree<Tile>();
          done = new HashMap<PVector, Tile>();
          path = new ArrayList<PVector>();
          pending.put(startTile.getPosition(), startTile);
          pendingTree.add(0, startTile);
          pendingTree.print2();
          isSolving = true;
        }
      }
      
      break;
    case 115:
    case 83:
      if(!isWall(mouseJ, mouseI) && !isSolving){
        if(endTile == null || endTile.getPosition().dist(new PVector(mouseJ, mouseI)) > 0){
          startTile = new Tile(0, new PVector(mouseJ, mouseI));
        }
      }
      break;
    case 103:
    case 71:
      if(!isWall(mouseJ, mouseI) && !isSolving){
        if(startTile == null || startTile.getPosition().dist(new PVector(mouseJ, mouseI)) > 0){
          endTile = new Tile(0, new PVector(mouseJ, mouseI));
        }
      }
      break;
    case 99:
    case 67:
      if(!isSolving){
        walls = new HashMap<PVector, Boolean>();
        pending = new HashMap<PVector, Tile>();
        pendingTree = new BinaryTree<Tile>();
        done = new HashMap<PVector, Tile>();
        path = new ArrayList<PVector>();
        startTile = null;
        endTile = null;
      }
      break;
  }
}
