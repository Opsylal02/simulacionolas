static int _lastParticleId = 0; //<>// //<>//

public class Particle
{
   int _id;            // Unique id for each particle

   PVector _s;         // Position (m)
   PVector _sInit;     // Initial position (m)
   PVector _v;         // Velocity (m/s)
   PVector _a;         // Acceleration (m/(s*s))
   PVector _F;         // Force (N)
   float _m;           // Mass (kg)

   boolean _noGravity; // If true, the particle will not be affected by gravity
   boolean _clamped;   // If true, the particle will not move


   Particle(PVector s, PVector v, float m, boolean noGravity, boolean clamped)
   {
      _id = _lastParticleId++;

      _s = s.copy();
      
      _sInit = s.copy();
      
      _m = m;

      _noGravity = noGravity;
      
      _clamped = clamped;

      _a = new PVector(0.0, 0.0, 0.0);
      
      
      _F = new PVector(0.0, 0.0, 0.0);
   }

   void update()
   {
      if (_clamped)
         return;

      if (!_noGravity)
      
         updateWeightForce();

      _s = _sInit.copy();
      
      PVector altura = new PVector(0.0, 0.0, 0.0);  
      
      for(Ola ola : _Olas) {

        altura = ola.vectorwave(_simTime, _s);
        
        _s.x += altura.x;
        
        _s.y += altura.y;
        
        _s.z += altura.z;

        }
        
     
   }
   
   int getId()
   {
      return _id;
   }
   
   PVector getVelocity()
   {
     return _v;
   }

   PVector getPosition()
   {
      return _s;
   }

   void setPosition(PVector s)
   {
      _s = s.copy();
      
      _a.set(0.0, 0.0, 0.0);
      
      _F.set(0.0, 0.0, 0.0);
   }

   void setVelocity(PVector v)
   {
      _v = v.copy();
   }

   void updateWeightForce()
   {
      PVector weigthForce = new PVector(0, 0, -G * _m);
      
      _F.add(weigthForce);
      
   }

   void addExternalForce(PVector F)
   {
      _F.add(F);
   }
}
