
// Dave, Aditya

import java.awt.AlphaComposite;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;
 
 
int rows, cols; 
int image[][];

color to = color( 229, 245, 249); 
color from = color(44, 162, 95); 

color to_mt = color(227, 74, 51);
color from_mt = color(254, 232, 200);


// may be used later
color tempColorArr[][]; 

boolean first = true; 
int c_value = 1;  

int isolines[][];

Cell[][] grid;
int rows_test2, cols_test2; 
int rows_mt, cols_mt;
int image_mt[][]; 
int mt_color[][];

void setup()
{
  
  
  ReadFile test = new ReadFile("brain.nrrd");
  test.populateMeta();
  test.populateValues();
  test.printLines();
  
  rows = test.sizeX; 
  cols = test.sizeY; 
  
  size(rows, cols);
  
  image = new int[rows][cols]; 
  
  // Initialize 2D array values
  for (int i = 0; i < rows; i++)
  {
    for (int j = 0; j < cols; j++)
      {
        image[i][j] = (int)test.cells[i][j];
      }
  }
  
  //-------------------------------
  // initialize stuff for mtHood
  ReadFile mt = new ReadFile("mtHood.nrrd");
  mt.populateMeta();
  mt.populateValues();
 // mt.printLines();
  
  rows_mt = mt.sizeX; 
  cols_mt = mt.sizeY; 
  
  
  image_mt = new int[rows][cols]; 
  
  // Initialize 2D array values
  for (int i = 0; i < rows_mt; i++)
  {
    for (int j = 0; j < cols_mt; j++)
      {
        image_mt[i][j] = (int)mt.cells[i][j];
      }
  }
  
  
  // ------------------------------------------
  // create mt color
    mt_color = new color[rows_mt][cols_mt]; 
  
  for (int i = 0; i < rows_mt; i++)
  {
    for (int j = 0; j < cols_mt; j++)
      {
         int grayscaleValue = image[i][j]; 
         float percent = (float)grayscaleValue/255; 
         color current = lerpColor(from_mt, to_mt, percent); 
         mt_color[i][j] = current; 

      }
  }
  
  
  
  
  
  
  
  
  // ---------------------------------------
  // create a 2d colors array first
  tempColorArr = new color[rows][cols]; 
  
  for (int i = 0; i < rows; i++)
  {
    for (int j = 0; j < cols; j++)
      {
         int grayscaleValue = image[i][j]; 
         float percent = (float)grayscaleValue/255; 
         color current = lerpColor(from, to, percent); 
         tempColorArr[i][j] = current; 

      }
  }
  
  
  //--------------------------------------
  // create 2d array for isolines (marching square algorithm)
  isolines = new int[rows][cols];
  
  for (int i = 0; i < rows; i++)
  {
    for (int j = 0; j < cols; j++)
      {
        image[i][j] = (int)test.cells[i][j];
          if(image[i][j] < 200 && image[i][j] > 180 )
           {
             isolines[i][j] = 1; 
           }
           else
           {
             isolines[i][j] = 0; 
           }
         
      }
  }
  
  
}












void draw()
{
  //  println(mouseX + "  " + mouseY);
  
  
   if(c_value == 1)
{

  int mul = 40;  
  ReadFile test2 = new ReadFile("test.nrrd");
  test2.populateMeta();
  test2.populateValues();
  // test2.printLines();
  
  rows_test2 = test2.sizeX; 
  cols_test2 = test2.sizeY; 
  grid = new Cell[cols_test2][rows_test2];
  for (int i = 0; i < rows_test2; i++) 
  {
    for (int j = 0; j < cols_test2; j++)
    {
      // Initialize each object
      float colorValue = test2.cells[i][j];
      grid[i][j] = new Cell(i*mul,j*mul, mul, mul, colorValue );
    }
  }


  // draw this stuff
  for (int i = 0; i < cols_test2; i++)
  {
    for (int j = 0; j < rows_test2; j++)
    {
      grid[i][j].display();
    }
  }

  save("initial.png");
} 

  
  
  
  
  
  
  
  if(c_value == 2)
  {
      for (int i = 0; i < rows; i++)
      {
        for (int j = 0; j < cols; j++)
          {
           int grayscaleValue = image[i][j]; 
           float percent = (float)grayscaleValue/255; 
           color current = lerpColor(from, to, percent); 
           stroke(current);
           point(i,j);
          }
      }
      save("normal_image.png");
      
  }

  if(c_value == 3)
  {
      for (int i = 0; i < rows; i++)
      {
        for (int j = 0; j < cols; j++)
          {
           int grayscaleValue = image[i][j]; 
           stroke(grayscaleValue);
           point(i,j);
          }
      }
      save("normal_image_gray.png");

  }


  // draw isolines: grayscale
  // ----------------
  
  if(c_value == 4)
  {
    stroke(255, 0, 0);
    noFill();
    beginShape(POINTS);
        for (int i = 0; i < rows; i++)
        {
          for (int j = 0; j < cols; j++)
            {
                if(isolines[i][j] == 1)
                {
                  vertex(i,j);
                }
            }
        }
    endShape();
    
    save("isolines_gray.png");
  }
  
  
  // draw isolines: color
  // ----------------
  
  if(c_value == 5)
  {
    
      for (int i = 0; i < rows; i++)
      {
        for (int j = 0; j < cols; j++)
          {
           int grayscaleValue = image[i][j]; 
           float percent = (float)grayscaleValue/255; 
           color current = lerpColor(from, to, percent); 
           stroke(current);
           point(i,j);
          }
      }
    
    stroke(255, 0, 0);
    noFill();
    beginShape(POINTS);
        for (int i = 0; i < rows; i++)
        {
          for (int j = 0; j < cols; j++)
            {
                if(isolines[i][j] == 1)
                {
                  vertex(i,j);
                }
            }
        }
    endShape();
    
    save("isolines_color.png");
 }
  
  if(c_value == 6)
  {
    fill(255);
    rect(0, 0, width, height); 

    
  }

//-------------------------
   if(c_value == 7)
  {
      for (int i = 0; i < rows_mt; i++)
      {
        for (int j = 0; j < cols_mt; j++)
          {
           int grayscaleValue = image_mt[i][j]; 
           stroke(grayscaleValue);
           point(i,j);
          }
      }
      save("mtHood_gray.png");

  }
  
 //------------------------- 
   if(c_value == 8)
  {
      for (int i = 0; i < rows_mt; i++)
      {
        for (int j = 0; j < cols_mt; j++)
          {
           int grayscaleValue = image_mt[i][j]; 
           float percent = (float)grayscaleValue/255; 
           color current = lerpColor(from_mt, to_mt, percent); 
           stroke(current);
           point(i,j);
          }
      }
      save("mtHood_color.png");
      
  }
  
  
  if(first)
  {
    first = false;
    new Resize().doInterpolation();    
  }
  
}








public void interpolate()
{
  
  
}




//---------------------------------------------------------------------------------------------------------

class ReadFile{

   String fileName; 
   String lines[];
   String values[][];
   float cells[][]; 
   
   public ReadFile(String fileName)
   {
     this.fileName = fileName; 
     this.lines = loadStrings(this.fileName);  
   }
   
   int sizeX; 
   int sizeY;
   int dimension; 
   String encoding;
   String type; 

  
  public void printLines()
  {
//    for(int i=0; i<lines.length; i++)
//    {
//      println(lines[i]); 
//    }
  println(this.type + " " + this.dimension + " " + sizeX + " " + sizeY + " " + this.encoding );  

  for(int i=0; i<this.sizeX; i++)
  {
    for(int j=0; j<this.sizeY; j++)
    {
       print(this.cells[i][j] + " ");
    }
    println();
  }

}

  
  public void populateMeta()
  {
    // first all the metadata
    for(int i=0; i<lines.length; i++)
   {
     
     if(lines[i].startsWith("NRRD") || lines[i].startsWith("#"))
     {
       // do nothing
       continue; 
     }
     
     if(lines[i].startsWith("type"))
     {
       this.type = lines[i].split(":")[1].trim();
     }
     
     if(lines[i].startsWith("dimension"))
     {
       String d = lines[i].split(":")[1].trim();
       this.dimension = Integer.parseInt(d); 
     }
     
     if(lines[i].startsWith("sizes"))
     {
       String sizes = lines[i].split(":")[1].trim();
       String y = sizes.split(" ")[0]; 
       String x = sizes.split(" ")[1];
       
       this.sizeX = Integer.parseInt(x); 
       this.sizeY = Integer.parseInt(y); 
     }
     
     if(lines[i].startsWith("encoding"))
     {
       this.encoding = lines[i].split(":")[1].trim();
     }
     
   } 
   
  }
  
  
  public void populateValues()
  {
    
    this.values = new String[this.sizeX][this.sizeY]; 
    // skip to startingLine and start reading 
    int startingLine = 6; 
   
   String temp[] = new String[this.lines.length - startingLine]; 
   int tempL = 0; 
   for(int i=startingLine; i<this.lines.length; i++)
   {
     temp[tempL++] = this.lines[i];
   }
   
    int count = 0; 
      for(int i=0; i<this.sizeX; i++)
      {
        for(int j=0; j<this.sizeY; j++)
        {
          // this.values[i][j] = temp[(j*this.sizeX) + i];
          if(count == temp.length) break; 
          this.values[i][j] = temp[count];
          count++;   
        }
      }
     
   this.cells = new float[this.sizeX][this.sizeY];
   for(int i=0; i<this.sizeX; i++)
   {
     for(int j=0; j<this.sizeY; j++)
     {
       this.cells[i][j] = Float.parseFloat(this.values[i][j]);
     }
   }
     
  }
  

}

















//------------------------------------------------------------------------------------


// A Cell object
class Cell {
  // A cell object knows about its location in the grid as well as its size with the variables x,y,w,h.
  float x,y;   // x,y location
  float w,h;   // width and height
  float fillColor; 

  // Cell Constructor
  Cell(float tempX, float tempY, float tempW, float tempH, float fillColor) 
  {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    this.fillColor = fillColor; 
  } 
  

  void display() {
    stroke(255);
    fill(this.fillColor%255);
    rect(x,y,w,h); 
  }
}



//-------------------------------------------------------------------------------------

// Interpolation

public class Resize {
 
  private static final int IMG_WIDTH = 800;
  private static final int IMG_HEIGHT = 583;
 
  public void doInterpolation(){
 
  try{
 
      BufferedImage originalImage = ImageIO.read(new File("normal_image.png"));
      int type = originalImage.getType() == 0? BufferedImage.TYPE_INT_ARGB : originalImage.getType();

   
      BufferedImage resizeImageHintPng = resizeImageWithHint(originalImage, type);
      ImageIO.write(resizeImageHintPng, "png", new File("interpolated_image.png")); 
 
      }catch(IOException e){}
 
    }
 
    private BufferedImage resizeImage(BufferedImage originalImage, int type)
    {
      BufferedImage resizedImage = new BufferedImage(IMG_WIDTH, IMG_HEIGHT, type);
      Graphics2D g = resizedImage.createGraphics();
      g.drawImage(originalImage, 0, 0, IMG_WIDTH, IMG_HEIGHT, null);
      g.dispose();
     
      return resizedImage;
    }
 
    private BufferedImage resizeImageWithHint(BufferedImage originalImage, int type)
    {
 
      BufferedImage resizedImage = new BufferedImage(IMG_WIDTH, IMG_HEIGHT, type);
      Graphics2D g = resizedImage.createGraphics();
      g.drawImage(originalImage, 0, 0, IMG_WIDTH, IMG_HEIGHT, null);
      g.dispose();  
      g.setComposite(AlphaComposite.Src);
     
      g.setRenderingHint(RenderingHints.KEY_INTERPOLATION,
      RenderingHints.VALUE_INTERPOLATION_BILINEAR);
      g.setRenderingHint(RenderingHints.KEY_RENDERING,
      RenderingHints.VALUE_RENDER_QUALITY);
      g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
      RenderingHints.VALUE_ANTIALIAS_ON);
     
      return resizedImage;
    }  
    
    
    
}


void keyPressed()
{
  if(key == 'c')
  {
    if(c_value == 8)
    {
      c_value = 1; 
    } 
    else
    {
      c_value++;
    }
  }
}
