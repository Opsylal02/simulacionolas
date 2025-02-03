// Problem description: //<>// //<>// //<>//
// Deformable object simulation
import peasy.*;

// Display control:

PeasyCam _camera;   // Mouse-driven 3D camera


float _timeStep;              // Simulation time-step (s)
int _lastTimeDraw = 0;        // Last measure of time in draw() function (ms)
float _deltaTimeDraw = 0.0;   // Time between draw() calls (s)
float _simTime = 0.0;         // Simulated time (s)
float _elapsedTime = 0.0;     // Elapsed (real) time (s)




DeformableObject _defOb;              // Deformable object

SpringLayout _springLayout;           // Current spring layout

PVector _ballVel = new PVector();     // Ball velocity

ArrayList<Ola> _Olas;



void settings()
{
   size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y, P3D);
}

void setup()
{
   lights();
   frameRate(DRAW_FREQ);
   _lastTimeDraw = millis();

   float aspect = float(DISPLAY_SIZE_X)/float(DISPLAY_SIZE_Y);
   perspective((FOV*PI)/180, aspect, NEAR, FAR);
   _camera = new PeasyCam(this, 0);
   _camera.rotateX(QUARTER_PI);
   _camera.rotateZ(PI);
   _camera.setDistance(100);

   initSimulation(SpringLayout.STRUCTURAL);
}



void keyPressed()
{
   if (key == '1')
      restartSimulation(SpringLayout.STRUCTURAL);

   if (key == '2')
      restartSimulation(SpringLayout.SHEAR);

   if (key == '3')
      restartSimulation(SpringLayout.BEND);

   if (key == '4')
      restartSimulation(SpringLayout.STRUCTURAL_AND_SHEAR);

   if (key == '5')
      restartSimulation(SpringLayout.STRUCTURAL_AND_BEND);

   if (key == '6')
      restartSimulation(SpringLayout.SHEAR_AND_BEND);

   if (key == '7')
      restartSimulation(SpringLayout.STRUCTURAL_AND_SHEAR_AND_BEND);

   if (key == 'r')
      resetOlas();


   if (key == 'm' || key == 'M')
      DRAW_MODE = !DRAW_MODE;

   if (key == 'I' || key == 'i')
      initSimulation(_springLayout);
      
   if(key == 'r' || key == 'R')  // Radial 
   {  
    
      float x = N_X * D_X / 2;
      float y = N_Y * D_Y / 2;
      
      PVector inicio = new PVector(random(-x, x),random(-y, y), (N_Z-1) * D_Z);
      
      Ola w = new Ola( 0.8, 0.5, 20, inicio, 0);
      
      _Olas.add(w);
   }
   
   if(key == 'd' || key == 'D')  // Directional 
   {  
    
      float x = N_X * D_X / 2;
      float y = N_Y * D_Y / 2;
      
      PVector inicio = new PVector(random(-x, x),random(-y, y), (N_Z-1) * D_Z);
      
      Ola w = new Ola( 0.8, 0.5, 20, inicio, 1);
      _Olas.add(w);
   }
   
   if(key == 'g' || key == 'G')  // Gerstner 
   {  
      float x = N_X * D_X / 2;
      float y = N_Y * D_Y / 2;
      
      PVector inicio = new PVector(30 + random(-x, x), 30 + random(-y, y), (N_Z-1) * D_Z);
    
      Ola w = new Ola(0.1, 0.4, 10, inicio, 2);
      
      _Olas.add(w);
   }
}

void initSimulation(SpringLayout springLayout)
{

   _simTime = 0.0;
   
   _timeStep = TS*TIME_ACCEL;
   
   _elapsedTime = 0.0;
   
   _springLayout = springLayout;

   
   _Olas = new ArrayList<Ola>();
 
   _defOb = new DeformableObject(N_X , N_Y, N_Z,D_X, D_Y, D_Z, _springLayout, OBJ_COLOR);

}

void resetOlas()
{
   _Olas = new ArrayList<Ola>();
  
}



void restartSimulation(SpringLayout springLayout)
{
   _simTime = 0.0;
   
   _timeStep = TS*TIME_ACCEL;
   
   _elapsedTime = 0.0;
   
   _springLayout = springLayout;
   
   _defOb = new DeformableObject(N_X , N_Y, N_Z,D_X, D_Y, D_Z, _springLayout, OBJ_COLOR);
}



void draw()
{


  directionalLight(255, 255, 255, 0, 1, -1);
  
   int now = millis();
   
   _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
   
   _elapsedTime += _deltaTimeDraw;
   
   _lastTimeDraw = now;

 

   background(BACKGROUND_COLOR);

   drawDynamicEnvironment();
    
   if (REAL_TIME)
   {
      float expectedSimulatedTime = TIME_ACCEL*_deltaTimeDraw;
      float expectedIterations = expectedSimulatedTime/_timeStep;
      int iterations = 0;

      for (; iterations < floor(expectedIterations); iterations++)
         updateSimulation();

      if ((expectedIterations - iterations) > random(0.0, 1.0))
      {
         updateSimulation();
         iterations++;
      }

     
   } 
   else
      updateSimulation();

 
}


void drawDynamicEnvironment()
{
  
   _defOb.render();
  
}

void updateSimulation()
{
 
   _defOb.update();
   _simTime += _timeStep;
  
}
