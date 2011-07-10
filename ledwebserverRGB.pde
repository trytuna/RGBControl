#include <LED.h>
//#include <WString.h>
#include <SPI.h>
#include <Client.h>
#include <Ethernet.h>
#include <Server.h>


byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 192, 168, 1, 177 };
byte gateway[] = { 192, 168, 1, 1 };
byte subnet[] = { 255, 255, 255, 0 };

Server server(80);


byte sampledata=50; //some sample data – outputs 2 (ascii = 50 DEC)
LED led1 = LED(3);  // //Set pin 4 to output
LED led2 = LED(4);
LED led3 = LED(5);
LED led4 = LED(2);
LED led5 = LED(6);
LED led6 = LED(7);
String readString = String(30); //string for fetching data from address
boolean kuechean = false;
boolean badezimmeran = false;
boolean schlafzimmeran = false;
boolean wohnzimmeran = false;
boolean gartenan = false;
boolean arbeitszimmeran = false;
int zaehler1= 1;
int zaehler2= 1;
int zaehler3= 1;
int zaehler4= 1;
int zaehler5= 1;
int zaehler6= 1;


void setup(){ //start Ethernet
    Ethernet.begin(mac, ip, gateway, subnet);
    Serial.begin(9600); }

void loop(){
    Client client = server.available();// Create a client connection

    if (client) {
	  while (client.connected()) {
		if (client.available()) {
		    char c = client.read();
		if (readString.length() < 30) {
		    readString = readString + c;
		}
		    Serial.print(c);
		if (c == '\n') {
			if(readString.indexOf("Kueche") > -1 ) {
			    led1.toggle(); // set the LED on
			    zaehler1++;
			    if(zaehler1 %2 == 0) {
				  kuechean = true;
			    }else{
				  kuechean = false;
			    }
			}
			if(readString.indexOf("Badezimmer") > -1 ) {
			    led2.toggle();
			    zaehler2++;
			    if(zaehler2 %2 == 0) {
				  badezimmeran = true;
			    }else{
				  badezimmeran = false;
			    }
			}
			if(readString.indexOf("Wohnzimmer") > -1 ) {
			    led3.toggle();
			    zaehler3++;
			    if(zaehler3 %2 == 0) {
				  wohnzimmeran = true;
			    }else{
				  wohnzimmeran = false;
			    }
			}
			if(readString.indexOf("Schlafzimmer") > -1 ) {
			    led4.toggle();
			    zaehler4++;
			    if(zaehler4 %2 == 0) {
				  schlafzimmeran = true;
			    }else{
				  schlafzimmeran = false;
			    }
			}
			if(readString.indexOf("Arbeitszimmer") > -1 ) {
			    led5.toggle();
			    zaehler5++;
			    if(zaehler5 %2 == 0) {
				  arbeitszimmeran = true;
			    }else{
				  arbeitszimmeran = false;
			    }
			}
			if(readString.indexOf("Garten") > -1 ) {
			    led6.toggle();
			    zaehler6++;
			    if(zaehler6 %2 == 0) {
				  gartenan = true;
			    }else{
				  gartenan = false;
			    }
			}

		 client.println("HTTP/1.1 200 OK");
		 client.println("Content-Type: text/html");
		 client.println();
		 client.println("<div align=center>");
		 client.print("<body style=background-color:lightblue>");
		 client.println("<font color=red><h1>Steuerung des Heimbereiches</font></h1>");
		 client.println("<hr/>");
		 client.println("<h1><font color='#2076CD'>Zimmer</font color></h1>");
		 client.println("<hr /><br>");
		 client.println("<form method=GET>");
		 if (kuechean) {
		     client.println("<input type=submit value=Kueche  name=AN style=width:200;height:100;background-color:red;/>");
		 }else {
		     client.println("<input type=submit  value=Kueche name=AUS style=width:200;height:100;background-color:lightgreen;>");
		 }

		 if (badezimmeran) {
		     client.println("<input type=submit name=AN value=Badezimmer style=width:200;height:100;background-color:red>");
		 }else {
		     client.println("<input type=submit name=AUS value=Badezimmer style=width:200;height:100;background-color:lightgreen>");
		 }

		 if (wohnzimmeran) {
		     client.println("<input type=submit name=AN value=Wohnzimmer  style=width:200;height:100;background-color:red>");
		 }else {
		     client.println("<input type=submit name=AUS value=Wohnzimmer style=width:200;height:100;background-color:lightgreen>");
		 }

		 if (schlafzimmeran) {
		     client.println("<input type=submit name=AN value=Schlafzimmer style=width:200;height:100;background-color:red>");
		 }else {
		     client.println("<input type=submit name=AUS value=Schlafzimmer style=width:200;height:100;background-color:lightgreen>");
		 }
		 if (arbeitszimmeran) {
		     client.println("<input type=submit name=AN value=Arbeitszimmer style=width:200;height:100;background-color:red>");
		 }else {
		     client.println("<input type=submit name=AUS value=Arbeitszimmer style=width:200;height:100;background-color:lightgreen>");
		 }

		 if (gartenan) {
		     client.println("<input type=submit name=AN value=Garten  style=width:200;height:100;background-color:red>");
		 }else {
		     client.println("<input type=submit name=AUS value=Garten style=width:200;height:100;background-color:lightgreen>");
		 }

		 client.println("<br/>");
		 client.println("</body></html>");
		 readString=" ";
		 client.stop();
		 }
	     }
	   }
	 }
}


