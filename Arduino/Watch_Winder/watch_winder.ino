//Arduino Watch Winder by jagumiel

//Include the Arduino Stepper Library
#include <Stepper.h>

// Number of steps per internal motor revolution 
const float STEPS_PER_REV = 32; 

// Number of Steps Desired
int numSteps;


// The pins used are 8,9,10,11 
// Connected to ULN2003 Motor Driver In1 to In4 respectively.

Stepper steppermotor(STEPS_PER_REV, 8, 10, 9, 11);

void setup(){
  //Mandatory. Configures the pins at start-up.
}

void loop(){
  // 15 rotations Clockwise (1 full rotation is 2050 steps)
  steppermotor.setSpeed(500);    
  numSteps  =  30750;
  steppermotor.step(numSteps);
  delay(2000);
  
  // 15 rotations Counterclockwise
  steppermotor.setSpeed(500);    
  numSteps  =  - 30750;
  steppermotor.step(numSteps);
  
  // Wait 30 seconds before rotation again
  delay(30000);
}
