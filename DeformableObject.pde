public class DeformableObject
{
   int N_H;   // Number of nodes in X direction
   int N_V;   // Number of nodes in Y direction
   int N_Z;   // Number of nodes in Z direction

   float D_H;      // Separation of the object's nodes in the X direction (m)
   float D_V;      // Separation of the object's nodes in the Y direction (m)
   float D_Z;      // Separation of the object's nodes in the Z direction (m)

   SpringLayout _springLayout;   // Physical layout of the springs that define the surface of each layer
   color _color;                 // Color (RGB)

   Particle[][][] _nodes;                             // Particles defining the object
   ArrayList<DampedSpring> _springs;                  // Springs joining the particles
   
   DeformableObject(int nx, int ny, int nz, float sx, float sy, float sz, SpringLayout springlayout, color c)
   {
     N_H = nx;
     N_V = ny;
     N_Z = nz;
     
     D_H = sx;
     D_V = sy;
     D_Z = sz;
     
     _springLayout = springlayout;
     
     _color = c;
     
     _springs = new ArrayList<DampedSpring>();
     
     _nodes = new Particle[N_H][N_V][N_Z];
     
     createNodes();
            
     switch(_springLayout)
     {
      case STRUCTURAL:
        createStructSprings();
        break;
         
      case SHEAR:
        createShearSprings();
        break;
         
      case BEND:
        createBendSprings();
        break;
        
      case STRUCTURAL_AND_SHEAR:
      
        createStructSprings();
        createShearSprings();
        break;
         
      case STRUCTURAL_AND_BEND:
        createStructSprings();
        createBendSprings();
        break;
        
      case SHEAR_AND_BEND:
        createShearSprings();
        createBendSprings();
        break;
        
      case STRUCTURAL_AND_SHEAR_AND_BEND:
        createStructSprings();
        createShearSprings();
        createBendSprings();
        break;
        
      default:
        createStructSprings();
        break;
     }
   }
   
   void createNodes()
   {
      for(int x = 0; x < N_H; x++)
      {
       for(int y = 0; y < N_V; y++)
       {
          for(int z = 0; z < N_Z; z++)
          {
            boolean fixed = false;
            if(z != N_Z - 1)
                fixed = true;
            PVector pos = new PVector(-D_H * N_H/2 + D_H * x, -D_V * N_V/2 + D_V * y, D_Z * z);
            
            _nodes[x][y][z] = new Particle(pos, new PVector(0.0, 0.0, 0.0), m, false, fixed);
          }
         }
      }
   }
   
   void createStructSprings()
   {
      for(int x = 0; x < N_H; x++){
        for(int y = 0; y < N_V; y++){
          for(int z = 0; z < N_Z; z++)
          {
           if(x + 1 < N_H)
           {
             DampedSpring spring = new DampedSpring(_nodes[x][y][z], _nodes[x+1][y][z], Kx, Kdx);
             _springs.add(spring);
           }
           if(y + 1 < N_V)
           {
             DampedSpring spring = new DampedSpring(_nodes[x][y][z], _nodes[x][y+1][z], Kx, Kdx);
             _springs.add(spring);
           }
           if(z + 1 < N_Z)
           {
             DampedSpring spring = new DampedSpring(_nodes[x][y][z], _nodes[x][y][z+1], Kz, Kdz);
             _springs.add(spring);
           }
          }
        }
          }
   }
   
   void createShearSprings()
   {
     DampedSpring spring;
      for(int x = 0; x < N_H; x++){
        for(int y = 0; y < N_V; y++){
          for(int z = 0; z < N_Z; z++)
          {
           if(x + 1 < N_H && y + 1 < N_V)
           {
             spring = new DampedSpring(_nodes[x][y][z], _nodes[x+1][y+1][z], Kx, Kdx);
             _springs.add(spring);

           }
           if(x - 1 >= 0 && y + 1 < N_V)
           {
             spring = new DampedSpring(_nodes[x][y][z], _nodes[x-1][y+1][z], Kx, Kdx);
             _springs.add(spring);

           }
           if(z + 1 < N_Z)
           {
                spring = new DampedSpring(_nodes[x][y][z], _nodes[x][y][z+1], Kz, Kdz);
                _springs.add(spring);
           }
          }
        }
      }
   }
   
   void createBendSprings()
   {
     DampedSpring spring;
     for(int x = 0; x < N_H; x++){
      for(int y = 0; y < N_V; y++){
        for(int z = 0; z < N_Z; z++)
        {
         if(x + 2 < N_H)
         {
           spring = new DampedSpring(_nodes[x][y][z], _nodes[x+2][y][z], Kx, Kdx);
           _springs.add(spring);
         }
         if(y + 2 < N_V)
         {
           spring = new DampedSpring(_nodes[x][y][z], _nodes[x][y+2][z], Kx, Kdx);
           _springs.add(spring);
         }
         if(z + 1 < N_Z)
         {
           spring = new DampedSpring(_nodes[x][y][z], _nodes[x][y][z+1], Kz, Kdz);
           _springs.add(spring);
         }
        }
   }
     }
   }

   int getNumNodes()
   {
      return N_H*N_V*N_Z;
   }

   int getNumSprings()
   {
      return _springs.size();
   }

   void update()
   {
      for(int x = 0; x < N_H; x++){
        for(int y = 0; y < N_V; y++){
          for(int z = 0; z < N_Z; z++){
            _nodes[x][y][z].update();
          }
        }
      }

   }

   void render()
   {
      if (DRAW_MODE)
         renderWithSegments();
      else
         renderWithQuads();
   }

   void renderWithSegments()
   {
      stroke(0);
      strokeWeight(0.5);

      for (DampedSpring s : _springs)
      {
         PVector pos1 = s.getParticle1().getPosition();
         PVector pos2 = s.getParticle2().getPosition();

         line(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z);
      }
   }

   void renderWithQuads()
   {
      int i, j, k;
  
      noStroke();
      fill(_color);
      stroke(0);
      
      strokeWeight(1.0);
      for (j = 0; j < N_V - 1; j++)
      {
         beginShape(QUAD_STRIP);
         for (i = 0; i < N_H; i++)
         {
            if ((_nodes[i][j][N_Z-1] != null) && (_nodes[i][j+1][N_Z-1] != null))
            {
               PVector pos1 = _nodes[i][j][N_Z-1].getPosition();
               
               PVector pos2 = _nodes[i][j+1][N_Z-1].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }
      
      noStroke();
      for (j = 0; j < N_V - 1; j++)
      {
         beginShape(QUAD_STRIP);
         for (i = 0; i < N_H; i++)
         {
            if ((_nodes[i][j][0] != null) && (_nodes[i][j+1][0] != null))
            {
               PVector pos1 = _nodes[i][j][0].getPosition();
               PVector pos2 = _nodes[i][j+1][0].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }
      strokeWeight(0.0);
      

      for (j = 0; j < N_V - 1; j++)
      {
         beginShape(QUAD_STRIP);
         for (k = 0; k < N_Z; k++)
         {
            if ((_nodes[0][j][k] != null) && (_nodes[0][j+1][N_Z-1] != null))
            {
               PVector pos1 = _nodes[0][j][k].getPosition();
               PVector pos2 = _nodes[0][j+1][k].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }
      
      for (j = 0; j < N_V - 1; j++)
      {
         beginShape(QUAD_STRIP);
         for (k = 0; k < N_Z; k++)
         {
            if ((_nodes[N_H-1][j][k] != null) && (_nodes[N_H-1][j+1][N_Z-1] != null))
            {
               PVector pos1 = _nodes[N_H-1][j][k].getPosition();
               PVector pos2 = _nodes[N_H-1][j+1][k].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }

      for (i = 0; i < N_H - 1; i++)
      {
         beginShape(QUAD_STRIP);
         for (k = 0; k < N_Z; k++)
         {
            if ((_nodes[i][0][k] != null) && (_nodes[i+1][0][k] != null))
            {
               PVector pos1 = _nodes[i][0][k].getPosition();
               PVector pos2 = _nodes[i+1][0][k].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }

      for (i = 0; i < N_H - 1; i++)
      {
         beginShape(QUAD_STRIP);
         for (k = 0; k < N_Z; k++)
         {
            if ((_nodes[i][N_V-1][k] != null) && (_nodes[i+1][N_V-1][k] != null))
            {
               PVector pos1 = _nodes[i][N_V-1][k].getPosition();
               PVector pos2 = _nodes[i+1][N_V-1][k].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }
   }
}
