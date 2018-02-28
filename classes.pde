class Bomb{
  Index pos;
  int fusivel, alcance;
  Bomb( Index p ){
    pos = p.get();
    fusivel = millis() + 3000;
    alcance = 2;
  }
  boolean explodiu(){
    if( millis() > fusivel ) return true;
    else return false;
  }
  void plot(){
    fill(0);
    ellipse( (pos.i + 0.5) * l, (pos.j + 0.5) * l, l, l );
  }
}

class Index{
  int i, j;
  Index( int I, int J ){
    i = I;
    j = J;
  }
  void set( int I, int J ){
    i = I;
    j = J;
  }
  boolean equals( int I, int J ){
    return (i == I && j == J);
  }
  Index get(){
    return new Index( i, j );
  }
}