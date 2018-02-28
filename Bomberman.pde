//Este é o código do clone de "Bomberman" criado na oficina de desenvolvimento de jogos 
//da Noite de Processing em 27/02/2018.

int[][] mapa;
float l;
boolean[] p1c, p2c;
ArrayList<Bomb> bombs;

Index p1, p2;

void setup() {
  size(400, 346); 
  frameRate(15);
  mapa = new int[15][13];
  l = width / float(mapa.length);
  
  p1 = new Index( 1, 1 );
  p2 = new Index( 13, 11 );
  p1c = new boolean[5];
  p2c = new boolean[5];
  
  bombs = new ArrayList();
  
  makeMapa();
}

void makeMapa() {
  PImage file = loadImage("mapa.png");
  for (int x=0; x<mapa.length ; x++){
   for (int y=0; y<mapa[0].length ; y++){
     int t = 0;
     color c = file.get(x,y);
     if( c == color(0) ) t = 2;
     else if( c == color(127) ) t = 1;
     //else if( c == color(195) ) 
     else if( c == color( 255 ) ){
       if( abs((9-dist( x, y, 7, 6 )) * randomGaussian()) > 1.2 ) t = 1;
     }
     
     mapa[x][y] = t;
   }
  }
}

void draw() {
  //DESENHANDO O MAPA COM LOOPS ANINHADOS
  for (int x=0; x<mapa.length ; x++){
    for (int y=0; y<mapa[0].length ; y++){
      pushMatrix();
      translate(x*l,y*l);
      switch ( mapa[x][y] ) {
        case 0: fill(#1CFF88); break;
        case 1: fill(#FF831C); break;
        case 2: fill(#5A5A5A); break;
      }
      rect(0,0,l,l);
      popMatrix();
    }
  }
  
  //EFETUANDO OS CONTROLES DO PLAYER 1
  if( p1.i >= 0 ){
    if (p1c[0]) {
      if (mapa[p1.i][p1.j-1] == 0 && nao_ha_bombas(p1.i, p1.j-1) && !p2.equals(p1.i, p1.j-1)) p1.j--; 
    }
    if (p1c[1]) {
      if (mapa[p1.i][p1.j+1] == 0 && nao_ha_bombas(p1.i, p1.j+1) && !p2.equals(p1.i, p1.j+1)) p1.j++; 
    }
    if (p1c[2]) {
      if (mapa[p1.i-1][p1.j] == 0 && nao_ha_bombas(p1.i-1, p1.j) && !p2.equals(p1.i-1, p1.j)) p1.i--; 
    }
    if (p1c[3]) {
      if (mapa[p1.i+1][p1.j] == 0 && nao_ha_bombas(p1.i+1, p1.j) && !p2.equals(p1.i+1, p1.j)) p1.i++; 
    }
    if( p1c[4] && nao_ha_bombas(p1.i, p1.j) ) bombs.add( new Bomb( p1 ) );
  }
    
  
  //EFETUANDO OS CONTROLES DO PLAYER 2
  if( p2.i >= 0 ){
    if (p2c[0]) {
      if (mapa[p2.i][p2.j-1] == 0 && nao_ha_bombas(p2.i, p2.j-1) && !p1.equals(p2.i, p2.j-1)) p2.j--; 
    }
    if (p2c[1]) {
      if (mapa[p2.i][p2.j+1] == 0 && nao_ha_bombas(p2.i, p2.j+1) && !p1.equals(p2.i, p2.j+1)) p2.j++; 
    }
    if (p2c[2]) {
      if (mapa[p2.i-1][p2.j] == 0 && nao_ha_bombas(p2.i-1, p2.j) && !p1.equals(p2.i-1, p2.j)) p2.i--; 
    }
    if (p2c[3]) {
      if (mapa[p2.i+1][p2.j] == 0 && nao_ha_bombas(p2.i+1, p2.j) && !p1.equals(p2.i+1, p2.j)) p2.i++; 
    }
    if( p2c[4] && nao_ha_bombas(p2.i, p2.j) ) bombs.add( new Bomb( p2 ) );
  }
  
  //DESENHANDO OS PLAYERS
  fill( 0, 0, 255);
  ellipse( (p1.i + 0.5) * l, (p1.j + 0.5) * l, l, l);
  fill(255, 0, 0);
  ellipse( (p2.i + 0.5) * l, (p2.j + 0.5) * l, l, l);
  
  for(int i = bombs.size()-1; i >= 0; --i ){
    //DESENHANDO AS BOMBAS
    bombs.get(i).plot();
    //CHECANDO SE A BOMBA DA EXPLODIU E...
    if( bombs.get(i).explodiu() ){
      //CONFERINDO A AREA DA EXPLOSAO NAS QUATRO DIRECOES PARA...
      
      // para cima
      for( int e = bombs.get(i).pos.j - 1; e >= bombs.get(i).pos.j - bombs.get(i).alcance; --e ){
        if( mapa[bombs.get(i).pos.i][e] == 2 ) break;
        //DESTRUIR BLOCOS DESTRUTÍVEIS...
        if( mapa[bombs.get(i).pos.i][e] == 1 ){
          mapa[bombs.get(i).pos.i][e] = 0;
          continue;
        }
        //E JOGADORES QUE SE ENCONTREM NO CAMINHO.
        if( p1.equals( bombs.get(i).pos.i, e ) ) p1.set( -1, -1 );
        if( p2.equals( bombs.get(i).pos.i, e ) ) p2.set( -1, -1 );
        kaboom( (bombs.get(i).pos.i + 0.5) * l, (e + 0.5) * l );
      }
      // para baixo
      for( int e = bombs.get(i).pos.j + 1; e <= bombs.get(i).pos.j + bombs.get(i).alcance; ++e ){
        if( mapa[bombs.get(i).pos.i][e] == 2 ) break;
        if( mapa[bombs.get(i).pos.i][e] == 1 ){
          mapa[bombs.get(i).pos.i][e] = 0;
          continue;
        }
        if( p1.equals( bombs.get(i).pos.i, e ) ) p1.set( -1, -1 );
        if( p2.equals( bombs.get(i).pos.i, e ) ) p2.set( -1, -1 );
        kaboom( (bombs.get(i).pos.i + 0.5) * l, (e + 0.5) * l );
      }
      // para a esquerda
      for( int e = bombs.get(i).pos.i - 1; e >= bombs.get(i).pos.i - bombs.get(i).alcance; --e ){
        if( mapa[e][bombs.get(i).pos.j] == 2 ) break;
        if( mapa[e][bombs.get(i).pos.j] == 1 ){
          mapa[e][bombs.get(i).pos.j] = 0;
          continue;
        }
        if( p1.equals( e, bombs.get(i).pos.j ) ) p1.set( -1, -1 );
        if( p2.equals( e, bombs.get(i).pos.j ) ) p2.set( -1, -1 );
        kaboom( (e + 0.5) * l, (bombs.get(i).pos.j + 0.5) * l );
      }
      // para a direita
      for( int e = bombs.get(i).pos.i + 1; e <= bombs.get(i).pos.i + bombs.get(i).alcance; ++e ){
        if( mapa[e][bombs.get(i).pos.j] == 2 ) break;
        if( mapa[e][bombs.get(i).pos.j] == 1 ){
          mapa[e][bombs.get(i).pos.j] = 0;
          continue;
        }
        if( p1.equals( e, bombs.get(i).pos.j ) ) p1.set( -1, -1 );
        if( p2.equals( e, bombs.get(i).pos.j ) ) p2.set( -1, -1 );
        kaboom( (e + 0.5) * l, (bombs.get(i).pos.j + 0.5) * l );
      }
      
      bombs.remove(i);
    }
  }
}

boolean nao_ha_bombas( int I, int J ){
  for(int i = bombs.size()-1; i >= 0; --i ){
    if( bombs.get(i).pos.equals( I, J ) ) return false;
  }
  return true;
}

void kaboom( float x, float y ){
  fill( random( 160, 255), random(160, 255), 0 );
  int N = round( random( 5.501, 8.499 ) );
  N *= 2;
  beginShape();
  float t = TWO_PI/float(N);
  float d = l * 0.8;
  boolean q = false;
  for( int i = 0; i < N; ++i ){
    float a = random( i*t, (i+1)*t );
    d += random( -3, 2 );
    vertex( d * cos(a) + x, d * sin(a) + y );
    if( q ) d = l * 0.8;
    else d = l * 0.4;
  }
  endShape(CLOSE);
}