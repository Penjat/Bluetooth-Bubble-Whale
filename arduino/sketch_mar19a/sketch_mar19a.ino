/*
 * BTserialDemo: A simple demo of sending and receiving data between serial monitor
 *               and HM-10.
 * 
 * References: https://www.pjrc.com/teensy/td_libs_AltSoftSerial.html
 *             http://www.martyncurrey.com/hm-10-bluetooth-4ble-modules/
 *
 * Copyright Chris Dinh 2020
 */

#include <SoftwareSerial.h>

static SoftwareSerial btSerial(11, 10);


bool lightOn = false;
/* There is data waiting to be read from the HM-10 device. */
static void HandleRxDataIndication(void)
{
   char c = btSerial.read();

   if (c == 'o') {
    Serial.println("turning light on");
    lightOn = true;
    btSerial.write("WHALE-ON");
  }
  if (c == 'f') {
    Serial.println("turning light off");
    lightOn = false;
    btSerial.write("WHALE-OFF");
  }

  if (c == 's') {  
    if (lightOn == true) {
       btSerial.write("WHALE-ON");
    } else {
      btSerial.write("WHALE-OFF");
    }
  } 
    
   /* Just echo the character for now. */
   Serial.write(c);
}

/* There is data waiting to be sent to the HM-10 device. */
static void HandleTxDataIndication(void)
{
   char c = Serial.read();
  Serial.println(c);
   /* Echo the character just been sent. */
   Serial.write(c);

   /* We don't send carriage return or line feed. */
   if (c == 0x0A || c == 0x0D)
   {
      return;
   }

   Serial.println("the input is: " + c);

   btSerial.write(c);
}

void setup()
{
   Serial.begin(9600);
   btSerial.begin(9600);
   Serial.println("BTserial started at 115200");
   pinMode(6, OUTPUT);
}

void loop()
{
  if (lightOn == true) {
    digitalWrite(6, HIGH);
  } else {
    digitalWrite(6, LOW);
  }
   if (btSerial.available())
   {
      HandleRxDataIndication();
   }

   if (Serial.available())
   {
      HandleTxDataIndication();
   }
}
