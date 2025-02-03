
public class DampedSpring
{
   Particle _p1;   // First particle attached to the spring
   Particle _p2;   // Second particle attached to the spring

   float _Ke;      // Elastic constant (N/m)
   float _Kd;      // Damping coefficient (kg/m)

   float _l0;      // Rest length (m)
   float _l;       // Current length (m)
   float _v;       // Current rate of change of length (m/s)

   PVector _e;     // Current elongation vector (m)
   PVector _eN;    // Current normalized elongation vector (no units)
   PVector _F;     // Force applied by the spring on particle 1 (the force on particle 2 is -_F) (N)

   DampedSpring(Particle p1, Particle p2, float ke, float kd)
   {
     _p1 = p1;
     _p2 = p2;
     _Ke = ke;
     _Kd = kd;
     
     _e = PVector.sub(_p2.getPosition().copy(), _p1.getPosition());
     _eN = _e.copy().normalize();
     
     _l = _e.mag();
     _l0 = _l;

     _F = new PVector(0.0, 0.0, 0.0);
   }

   Particle getParticle1()
   {
      return _p1;
   }

   Particle getParticle2()
   {
      return _p2;
   }
}
