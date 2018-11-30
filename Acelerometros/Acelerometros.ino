//----------------------------------------------------------------------
// Firmware to read two MMA8452 and send data trough serial port
// Jorge Cano @ Automáticas 2018 (Medialab-Prado)
// November 29, 2018
//----------------------------------------------------------------------
#include <Wire.h>
#include "SparkFun_MMA8452Q.h"

MMA8452Q accel_1(0x1D);
MMA8452Q accel_2(0x1C);

void setup()
{
  Serial.begin(57600);
  Serial.println("MMA8452Q Test Code!");
  accel_1.init();
  accel_2.init();
}

void loop()
{
  if (accel_1.available())
  {
    accel_1.read();
    printCalculatedAccels1();
    Serial.println(); // Print new line every time.
  }
  if (accel_2.available())
  {
    accel_2.read();
    printCalculatedAccels2();
    Serial.println(); // Print new line every time.
  }
}

void printCalculatedAccels1()
{ 
  Serial.println("1");
  Serial.print(accel_1.cx, 3);
  Serial.print("\t");
  Serial.print(accel_1.cy, 3);
  Serial.print("\t");
  Serial.print(accel_1.cz, 3);
  Serial.print("\t");
}
void printCalculatedAccels2()
{ 
  Serial.println("2");
  Serial.print(accel_2.cx, 3);
  Serial.print("\t");
  Serial.print(accel_2.cy, 3);
  Serial.print("\t");
  Serial.print(accel_2.cz, 3);
  Serial.print("\t");
}



