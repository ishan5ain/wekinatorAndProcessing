/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;
import processing.sound.*;
import websockets.*;
import tramontana.library.*;

Tramontana t;

OscP5 oscP5;
NetAddress myRemoteLocation;
int counter = 0;
boolean printing = false;
int noiseType = 0;
int offset = 100;

void setup() {
  size(400, 400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12001);
  t = new Tramontana(this, "10.28.17.37");

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device,
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1", 12001);
}


void draw() {
  background(0);
  textSize(24);

  //displaying the text according to the data received from wekinator
  if (noiseType == 1) {
    text("Noisy Background", width/2 - offset, height/2);
  } else {
    text("Not so Noisy Background", width/2 - offset, height/2);
  }
}

void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  //OscMessage myMessage = new OscMessage("/test");

  //myMessage.add(123); /* add an int to the osc message */

  /* send the message */
  //oscP5.send(myMessage, myRemoteLocation);
  //t.playVideo("https://www.drivehq.com/file/DFPublishFile.aspx/FileID5033634320/Key83vl85p21uav/hello-bear.mp4");
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  println(counter + " /wek/outputs received " + theOscMessage);

  if (theOscMessage.checkTypetag("f")) {

    //unpacking the 'classifier' value
    float firstValue = theOscMessage.get(0).floatValue();
    println(" values: "+firstValue);

    //setting flags for who is printing and who is not
    if (firstValue == 2) {
      printing = true;
    } else {
      printing = false;
    }
  }

  if (theOscMessage.checkTypetag("fffff")) {
    float ffout1 = theOscMessage.get(0).floatValue();
    println("noise type: " + ffout1 + " | Noise Type: " + noiseType);
    if (ffout1 < 9) {
      noiseType = 1;
    } else {
      noiseType = 0;
    }
  }

  //if (theOscMessage.checkTypetag("fffff")) {
  //  float ffout2 = theOscMessage.get(1).floatValue();
  //  println("ffout1: " + ffout2);
  //  if (ffout2 < 4) {
  //    t.makeVibrate();
  //    //t.playVideo("https://www.drivehq.com/file/DFPublishFile.aspx/FileID5033634320/Key83vl85p21uav/hello-bear.mp4");
  //  }
  //}

  //counter to for console debugging purpose to see the progress
  counter++;
}