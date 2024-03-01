import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public static final int NUM_ROWS = 20;
public static final int NUM_COLS = 20;
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private MSButton[][] buttons;
private  boolean lose = false; //2d array of minesweeper buttons


void setup ()
{
  //buttons = new MSButton[NUM_ROWS][NUM_COLS];
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  //first call to new initialize empty apt building across all floors
  //your code to initialize buttons goes here
  for (int r =0; r<NUM_ROWS; r++) {
    for (int c = 0; c<NUM_COLS; c++) {
      buttons[r][c]= new MSButton(r, c);
    }
  }

  setMines();
}
public void setMines()
{
  while (mines.size()< NUM_ROWS) //some
  {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    mines.add(buttons[r][c]);
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
  {
    displayWinningMessage();
  }
  if (lose == true)
    displayLosingMessage();
}
public boolean isWon()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (!buttons[r][c].clicked && !mines.contains(buttons[r][c]))
        return false;
    }
  }
  return true;
}
public void displayLosingMessage()
{
  for (int i =0; i<mines.size(); i++) {
    mines.get(i).clicked=true;
    for (int r = 0; r < NUM_ROWS; r++)
      for (int c = 0; c < NUM_COLS; c++)
      {
        buttons[r][c].setLabel("");
      }


    buttons[7][5].setLabel("L");
    buttons[7][6].setLabel("O");
    buttons[7][7].setLabel("S");
    buttons[7][8].setLabel("T");
    buttons[7][9].setLabel(":");
    buttons[7][10].setLabel("(");
  }
}
public void displayWinningMessage()
{
  for (int r = 0; r < NUM_ROWS; r++)
    for (int c = 0; c < NUM_COLS; c++)
    {
      buttons[r][c].setLabel("");
    }

  buttons[7][7].setLabel("W");
  buttons[7][8].setLabel("I");
  buttons[7][9].setLabel("N");
  buttons[7][10].setLabel("N");
  buttons[7][11].setLabel("E");
  buttons[7][12].setLabel("R");
}



public boolean isValid(int r, int c)
{
  //your code here
  if (r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS)
    return true;
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;

  for (int r = row-1; r<=row+1; r++) {
    for (int c = col-1; c<=col+1; c++)
      if (isValid(r, c) && mines.contains(buttons[r][c]))
        numMines++;
    if (mines.contains(buttons[row][col]))
      numMines--;
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
    clicked = true;
    if (mouseButton == RIGHT)
    {
      if (flagged == true)
        flagged = false; 
      clicked = false;
      if (flagged == false)
        flagged = true;
    } else if (mines.contains(this)) {
      displayLosingMessage();
      lose = true;
    } else if (countMines(myRow, myCol) > 0 && !mines.contains(buttons[myRow][myCol]))
    {
      setLabel(countMines(myRow, myCol));
    } else 
    {
      for (int r = myRow-1; r<=myRow+1; r++)
        for (int c = myCol-1; c<=myCol+1; c++)
          if (isValid(r, c) && !buttons[r][c].clicked)
            buttons[r][c].mousePressed();
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill( 228, 183, 191);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
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
}
