//-----------------------------------------------------------------------
// Read data from MMA8452 accelerometers using the serial port.Sen to OSC
// Jorge Cano @ Automáticas 2018 (Medialab-Prado)
// November 29, 2018
//-----------------------------------------------------------------------
import processing.serial.*;
import oscP5.*;
import netP5.*;
import signal.library.*;

Serial myPort;
float x, y, z;
String accelData_1;
PVector a1 = new PVector(1, 1, 1);
String accelData_2;
PVector a2 = new PVector(1, 1, 1);

OscP5 oscP5;
NetAddress remoteAddress;
int port;
String ip;

SignalFilter filterA1x;
SignalFilter filterA1y;
SignalFilter filterA1z;
SignalFilter filterA2x;
SignalFilter filterA2y;
SignalFilter filterA2z;

float fa1x = 1;
float fa1y = 1;
float fa1z = 1;
float fa2x = 1;
float fa2y = 1;
float fa2z = 1;

void setup() {
  size (400, 400);

  ip = "127.0.0.1"; 
  port = 11113;
  oscP5 = new OscP5(this, port); 
  remoteAddress = new NetAddress(ip, port); 

  println(Serial.list());  //list of available serial ports
  String portName = Serial.list()[0]; //replace 0 with whatever port you want to use.
  myPort = new Serial(this, portName, 57600);

  float beta = 1.0f;

  filterA1x = new SignalFilter(this);
  filterA1x.setMinCutoff(0.05);
  filterA1x.setBeta(beta);

  filterA1y = new SignalFilter(this);
  filterA1y.setMinCutoff(0.05);
  filterA1y.setBeta(beta);

  filterA1z = new SignalFilter(this);
  filterA1z.setMinCutoff(0.05);
  filterA1z.setBeta(beta);

  filterA2x = new SignalFilter(this);
  filterA2x.setMinCutoff(0.05);
  filterA2x.setBeta(beta);

  filterA2y = new SignalFilter(this);
  filterA2y.setMinCutoff(0.05);
  filterA2y.setBeta(beta);

  filterA2z = new SignalFilter(this);
  filterA2z.setMinCutoff(0.05);
  filterA2z.setBeta(beta);
}

void draw() {

  fa1x = filterA1x.filterUnitFloat( a1.x );
  fa1y = filterA1y.filterUnitFloat( a1.y );
  fa1z = filterA1z.filterUnitFloat( a1.z );
  fa2x = filterA2x.filterUnitFloat( a2.x );
  fa2y = filterA2y.filterUnitFloat( a2.y );
  fa2z = filterA2z.filterUnitFloat( a2.z );

  OscMessage msg = new OscMessage("/a1"); 
  msg.add(fa1x); 
  msg.add(fa1y); 
  msg.add(fa1z);
  oscP5.send(msg, remoteAddress); 

  msg = new OscMessage("/a2");
  msg.add(fa2x); 
  msg.add(fa2y); 
  msg.add(fa2z); 
  oscP5.send(msg, remoteAddress);
}

void serialEvent(Serial myPort) {
  String line = myPort.readStringUntil('\n');
  if (line!=null) {     
    // split incoming line into tokens   
    String[] q = splitTokens(line);    
    if (q.length == 3) {        
      x = float(q[0]);
      y = float(q[1]);
      z = float(q[2]);

      x = map(x, -1.0, 1.0, 0, 127);
      y = map(y, -1.0, 1.0, 0, 127);
      z = map(z, -1.0, 1.0, 0, 127);
    }

    if (line.substring(0, 1).equals("1"))
    {
      println("1");

      a1.x = x;
      a1.y = y;
      a1.z = z;
    }

    if (line.substring(0, 1).equals("2"))
    {

      a2.x = x;
      a2.y = y;
      a2.z = z;
    }
  }
}