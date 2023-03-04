import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }

  setMines();
}
public void setMines()
{
  int row = (int)(Math.random()*NUM_ROWS);
  int col = (int)(Math.random()*NUM_COLS);
  for (int i = 0; i < 50; i++) {
    if (!mines.contains(buttons[row][col]))
      mines.add(buttons[row][col]);
    row = (int)(Math.random()*NUM_ROWS);
    col = (int)(Math.random()*NUM_COLS);
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (!mines.contains(buttons[r][c]) && !buttons[r][c].clicked)
        return false;
      else if (mines.contains(buttons[r][c]) && buttons[r][c].clicked)
        return false;
    }
  }
  return true;
}
public void displayLosingMessage()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (mines.contains(buttons[r][c]))
        buttons[r][c].setClicked(true);
      else
        buttons[r][c].setLabel("L");
    }
  }
}
public void displayWinningMessage()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c].setLabel("W");
    }
  }
}
public boolean isValid(int r, int c)
{
  return (r >= 0 && r < NUM_ROWS) && (c >= 0 && c < NUM_COLS);
}
public int countMines(int row, int col)
{
  int numMines = 0;
  if (isValid(row-1, col-1)) {
    if (mines.contains(buttons[row-1][col-1]))
      numMines++;
  }
  if (isValid(row-1, col)) {
    if (mines.contains(buttons[row-1][col]))
      numMines++;
  }
  if (isValid(row-1, col+1)) {
    if (mines.contains(buttons[row-1][col+1]))
      numMines++;
  }
  if (isValid(row, col-1)) {
    if (mines.contains(buttons[row][col-1]))
      numMines++;
  }
  if (isValid(row, col+1)) {
    if (mines.contains(buttons[row][col+1]))
      numMines++;
  }
  if (isValid(row+1, col-1)) {
    if (mines.contains(buttons[row+1][col-1]))
      numMines++;
  }
  if (isValid(row+1, col)) {
    if (mines.contains(buttons[row+1][col]))
      numMines++;
  }
  if (isValid(row+1, col+1)) {
    if (mines.contains(buttons[row+1][col+1]))
      numMines++;
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    if (mouseButton == RIGHT && !clicked) {
      flagged = !flagged;
      if (!flagged)
        clicked = false;
    }
    if (mouseButton == LEFT) {
      clicked = true;
      if (mines.contains(this))
        displayLosingMessage();
      else if (countMines(myRow, myCol) > 0)
        myLabel = "" + countMines(myRow, myCol);
      else {
        for (int r = myRow-1; r <= myRow+1; r++) {
          for (int c = myCol-1; c <= myCol+1; c++) {
            if (r != myRow || c != myCol) {
              if (isValid(r, c) && !buttons[r][c].clicked)
                buttons[r][c].mousePressed();
            }
          }
        }
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    if(myLabel.equals("W") || myLabel.equals("L"))
      fill(0);
    else if(myLabel.equals("5"))
      fill(#760105);
    else if (myLabel.equals("4"))
      fill(#1E0176);
    else if (myLabel.equals("3"))
      fill(255, 0, 0);
    else if (myLabel.equals("2"))
      fill(#026213);
    else if (myLabel.equals("1"))
      fill(0, 0, 255);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  public void setClicked(boolean trueFalse)
  {
    clicked = trueFalse;
  }
}
