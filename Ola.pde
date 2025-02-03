public class Ola
{
  int _type;
  float C;
  float AMP;
  float T;
  float W;
  float Le;
  float Fr;
  float w;
  float fi;
  
  boolean disapear;
  
  PVector src_dir;
  
  Ola(float _a, float _T, float _L, PVector dir, int type)
  {
    _type = 0;
    C = _L/_T;
    AMP = _a;
    T = _T;
    W = 2 * PI / _T;
    Le = _L;
    Fr = 2 * PI / _L;
    src_dir = dir.copy(); 
    _type = type;
    
    w = 2 * PI / _L;
    fi = _T * 2 * PI;
  }
    void Amplitud() {
      
      AMP = AMP * pow(0.99, _simTime/100000);
      
    }
    
  PVector vectorwave(float t, PVector punto)
  {
    PVector res = punto.copy();
    
    float dot;
    
    float dist;
    
    switch(_type)
    {
      case 0:
      
        dist = PVector.sub(src_dir, punto).mag();
        
        res.x = 0;
        res.y = 0;
        res.z = AMP * sin(w * dist+fi * t);
        break;
        
      case 1: 
      
        src_dir.normalize();
        dot = punto.copy().dot(src_dir);
        
        res.x = 0;
        res.y = 0;
        res.z = AMP * sin(w * dot+fi * t);
        break;
        
      case 2:
      
        src_dir.normalize();
        
        float H = 2 * AMP;
        float S = H / Le;
        float Q = PI*AMP*W*2;
    
        dot = punto.copy().dot(src_dir);
        
        res.x = Q * AMP * src_dir.x * cos(w * dot+fi * t);
        
        res.y = Q * AMP * src_dir.y * cos(w * dot+fi * t);
        
        res.z = AMP * sin(w * dot+fi * t);
        
        break;
    }
    return res;
  }
}
