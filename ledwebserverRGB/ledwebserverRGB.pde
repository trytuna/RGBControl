/*

Original Version by Poldi
modified by Katsu
co modidied by MrFr33man123 & methanol

the functions readString.append() and readString.contains() where replaced

*/

#include <SPI.h>  // insert by Katsu
// #include <WString.h> removed by Katsu
#include <Ethernet.h>


byte mac[] = { 0x54, 0x55, 0x58, 0x10, 0x00, 0x24 };  // entspricht einer MAC von 84.85.88.16.0.36
byte ip[]  = { 192, 168, 1, 177 };                  // IP-Adresse
byte gateway[] = { 192, 168, 168, 1 };                // Gateway
byte subnet[]  = { 255, 255, 255, 0 };

Server server(80);

int Pin3 = 3;
int Pin4 = 4;
int Pin5 = 5;
int Pin6 = 6;

String readString = String(100);      // string for fetching data from address
boolean Pin3ON = false;                  // Status flag
boolean Pin4ON = false;

void setup(){
Ethernet.begin(mac, ip, gateway, subnet);
server.begin();
pinMode(Pin3, OUTPUT);
pinMode(Pin4, OUTPUT);

Serial.begin(9600); }

void loop(){

// Create a client connection
Client client = server.available();
if (client) {
while (client.connected()) {
if (client.available()) {
char c = client.read();

//read char by char HTTP request
if (readString.length() < 100) {

//store characters to string
// readString.append(c);  removed by Katsu
readString = readString + c; // insert by Katsu
// very simple but it works...
}

Serial.print(c);  //output chars to serial port

if (c == '\n') {  //if HTTP request has ended

// readString.contains() replaced with readString.indexOf(val) > -1  by Katsu
// indexOf locates a character or String within another String.
// Returns the index of val within the String, or -1 if not found.
if(readString.indexOf("3=einschalten") > -1) {
 digitalWrite(Pin3, HIGH);
 Serial.println("Pin 3 eingeschaltet!");
 Pin3ON = true;
}
if(readString.indexOf("3=ausschalten") > -1){
 digitalWrite(Pin3, LOW);
 Serial.println("Pin 3 ausgeschaltet!");
 Pin3ON = false;
}
if(readString.indexOf("4=einschalten") > -1) {
 digitalWrite(Pin4, HIGH);
 Serial.println("Pin 4 eingeschaltet!");
 Pin4ON = true;
}
if(readString.indexOf("4=ausschalten") > -1){
 digitalWrite(Pin4, LOW);
 Serial.println("Pin 4 ausgeschaltet!");
 Pin4ON = false;
}

if(readString.indexOf("all=Alles+aus") > -1){
 digitalWrite(Pin3, LOW);
 digitalWrite(Pin4, LOW);
 Serial.println("Alles ausgeschaltet");
 Pin3ON = false;
 Pin4ON = false;
}
//--------------------------HTML------------------------
client.println("HTTP/1.1 200 OK");

client.println("Content-Type: text/html");

client.println();

client.print("<html><head>");

client.print("<title>Arduino Webserver Poldi</title>");

client.println("</head>");

client.print("<body bgcolor='#444444'>");

//---Überschrift---
client.println("<br><hr />");

client.println("<h1><div align='center'><font color='#2076CD'>RGB Steuerung</font color></div></h1>");

client.println("<hr /><br>");
//---Überschrift---

//---Ausgänge schalten---
client.println("<div align='left'><font face='Verdana' color='#FFFFFF'>Ausg&auml;nge schalten:</font></div>");

client.println("<br>");

client.println("<table border='1' width='500' cellpadding='5'>");

client.println("<tr bgColor='#222222'>");

 client.println("<td bgcolor='#222222'><font face='Verdana' color='#CFCFCF' size='2'>Ausgang 3<br></font></td>");
 if(Pin3ON)
 client.println("<td align='center' bgcolor='#222222'><form method=get><input type=submit name=3 value='ausschalten'></form></td>");
 else
 client.println("<td align='center' bgcolor='#222222'><form method=get><input type=submit name=3 value='einschalten'></form></td>");
 
 if (Pin3ON)
   client.println("<td align='center'><font color='green' size='5'>ON");
 else
   client.println("<td align='center'><font color='#CFCFCF' size='5'>OFF");
   
client.println("</tr>");

client.println("<tr bgColor='#222222'>");

 client.println("<td bgcolor='#222222'><font face='Verdana' color='#CFCFCF' size='2'>Ausgang 4<br></font></td>");
 if (Pin4ON)
 client.println("<td align='center' bgcolor='#222222'><form method=get><input type=submit name=4 value='ausschalten'></form></td>");
 else
 client.println("<td align='center' bgcolor='#222222'><form method=get><input type=submit name=4 value='einschalten'></form></td>");
 
 
 if (Pin4ON)
   client.println("<td align='center'><font color='green' size='5'>ON");
 else
   client.println("<td align='center'><font color='#CFCFCF' size='5'>OFF");
   
client.println("</tr>");

   
client.println("</tr>");

client.println("</table>");


client.println("<br>");

client.println("<form method=get><input type=submit name=all value='Alles aus'></form>");

client.println("</body></html>");

//---Ausgänge schalten---

//clearing string for next read
readString="";

//stopping client
client.stop();
}}}}}

