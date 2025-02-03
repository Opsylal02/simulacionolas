
// Spring Layout
enum SpringLayout
{
   STRUCTURAL,
   SHEAR,
   BEND,
   STRUCTURAL_AND_SHEAR,
   STRUCTURAL_AND_BEND,
   SHEAR_AND_BEND,
   STRUCTURAL_AND_SHEAR_AND_BEND
}

// Simulation values:

final boolean REAL_TIME = true;   // To make the simulation run in real-time or not
final float TIME_ACCEL = 1.0;     // To simulate faster (or slower) than real-time




boolean DRAW_MODE = false;                            // True for wireframe
final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1000;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 1000;                      // Display height (pixels)
final float FOV = 50;                                 // Field of view (º)
final float NEAR = 0.01;                              // Camera near distance (m)
final float FAR = 10000.0;                            // Camera far distance (m)
final color OBJ_COLOR = color(60, 131, 208, 180);        // Object color (RGB)
final color BACKGROUND_COLOR = color(190, 1800, 210); // Background color (RGB)




final float Kx = 0.3;        // Elastic constant on X and Y axis
final float Kz = 1;        // Elastic constant on Z axis
final float Kdx = 0.5;       // Damping constant on X and Y axis
final float Kdz = 0.6;       // Damping constant on X axis
final float m = 0.1;         // Mass of mattress particles



final float TS = 0.01;       // Initial simulation time step (s)
final float G = 9.81;        // Acceleration due to gravity (m/(s·s))

final int N_X = 50;          // Number of nodes of the object in the X direction
final int N_Y = 50;          // Number of nodes of the object in the Y direction
final int N_Z = 2;           // Number of nodes of the object in the Z direction

final float D_X = 0.65;       // Separation of the object's nodes in the X direction (m)
final float D_Y = 0.65;       // Separation of the object's nodes in the Y direction (m)
final float D_Z = 10.0;      // Separation of the object's nodes in the Z direction (m)
