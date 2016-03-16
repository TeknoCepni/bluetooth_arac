#include <NewSoftSerial.h>   //Software Serial Port
#define RxD 6
#define TxD 7
 
#define DEBUG_ENABLED  1
 
NewSoftSerial blueToothSerial(RxD,TxD);

char motorHizi=0;
int arkaMotor = 3;
int direksiyon = 11;

void setup() {
  Serial.begin(9600); 
  pinMode(RxD, INPUT);
  pinMode(TxD, OUTPUT); 
 
//  pinMode(arkaMotor, OUTPUT);
//  pinMode(direksiyon, OUTPUT);  

  pinMode(12, OUTPUT);
  pinMode(9, OUTPUT);
  
  pinMode(13, OUTPUT);
  pinMode(8, OUTPUT);

  setupBlueToothConnection(); 
}

void loop() {
  while (!blueToothSerial.available());
  motorHizi = blueToothSerial.read(); 
  switch(motorHizi)
  {
    case '5':control(12,9,arkaMotor,LOW,LOW,255); break;
    case '4':control(12,9,arkaMotor,LOW,LOW,200); break;
    case '3':control(12,9,arkaMotor,LOW,LOW,150); break;
    case '2':control(12,9,arkaMotor,LOW,LOW,250); break;
    case '1':control(12,9,arkaMotor,HIGH,LOW,200); break;
    case '0':analogWrite(arkaMotor, 0); break;
    case 'a':analogWrite(direksiyon, 0); break; //on motor ayarlari dur 
    case 'b':control(13,8,direksiyon,LOW,LOW,255); break; //on motor ayarlari saga 
    case 'c':control(12,9,direksiyon,HIGH,LOW,255); break; //on motor ayarlari sola
  }
   
}

void control( int dw1, int dw2, int motor, int lh1, int lh2, int aw)
{
      digitalWrite(dw1, lh1);
      digitalWrite(dw2, lh2);
      analogWrite(motor, aw);  
}

void setupBlueToothConnection()
{
  blueToothSerial.begin(38400); //Set BluetoothBee BaudRate to default baud rate 38400
  blueToothSerial.print("\r\n+STWMOD=0\r\n"); //set the bluetooth work in slave mode
  blueToothSerial.print("\r\n+STNA=SeeedBTSlave\r\n"); //set the bluetooth name as "SeeedBTSlave"
  blueToothSerial.print("\r\n+STOAUT=1\r\n"); // Permit Paired device to connect me
  blueToothSerial.print("\r\n+STAUTO=0\r\n"); // Auto-connection should be forbidden here
  delay(2000); // This delay is required.
  blueToothSerial.print("\r\n+INQ=1\r\n"); //make the slave bluetooth inquirable 
  Serial.println("The slave bluetooth is inquirable!");
  delay(2000); // This delay is required.
  blueToothSerial.flush();
}

