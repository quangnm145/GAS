// Include library
// Cai dat thu vien
#include "LiquidCrystal_I2C.h"
#include <wire.h>
#include "DHT.h"            
const int DHTPIN = 3;      
const int DHTTYPE = DHT11;
int buttonStatus; 

// Define connected pin
// Dat ten chan cong ket noi
#define   GAS_PIN           A1
#define   BUTTON_PIN        9
#define   BUZZER_PIN        2 
#define   LED_RED_PIN       8
#define   LED_YELLOW_PIN    10
#define   LED_GREEN_PIN     11
// Set gas and alcohol limt
// Dat cac gia tri nguong
#define   TEMP_LIMIT1       40
#define   GAS_LIMIT1        400
#define   TEMP_LIMIT2       30
#define   GAS_LIMIT2        300
// Set the LCD address to 0x27 for a 16 chars and 2 line display
// Thiet lap dia chi LCD 0x27 de hien thi ky tu LCD 16 ky tu và 2 dong
LiquidCrystal_I2C LCD(0x27, 16, 2);
DHT dht(DHTPIN, DHTTYPE);

void setup() {
  // We initialize serial connection so that we could print values from sensor
  // Khoi tao cong ket noi noi tiep
  dht.begin(); 
  Serial.begin(9600);
  // Initialize LCD 1602 to display
  // Khoi tao LCD 1602 de hien thi
  LCD.init();
  // Turn on LCD backlight
  // Bat den nen LCD 1602
  LCD.backlight();
  // Thiet lap LED va BUZZER o trang thai OUTPUT
  pinMode(LED_RED_PIN, OUTPUT);
  pinMode(LED_YELLOW_PIN, OUTPUT);
  pinMode(LED_GREEN_PIN, OUTPUT);
  pinMode(BUZZER_PIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT);

  digitalWrite(LED_GREEN_PIN, HIGH);
  digitalWrite(LED_YELLOW_PIN, HIGH);
  digitalWrite(LED_RED_PIN, LOW);
  digitalWrite(BUZZER_PIN, LOW);

  buttonStatus = digitalRead(BUTTON_PIN);

  //PreHeating Sensor on 60s
  //Khoi dong lam nong cam bien trong 60s
  for (int i = 60; i >= 0; i--) {
    LCD.setCursor(0, 0);
    LCD.print("PreHeatingSensor");
    LCD.setCursor(7, 1);
    LCD.print(i);
    LCD.print("s  ");
    delay(1000);
    LCD.clear();
  }
}

void loop() {
  // Read gas and alcohol value
  // Doc gia tri cam bien khi gas va nong do con
  int gasValue = analogRead(GAS_PIN);
  Serial.println(gasValue);
  float tempValue  = dht.readTemperature()-11;
  Serial.println(dht.readTemperature());
  // Print gas and alcohol value on LCD at column 1 and row 1
  // Hien thi gia tri khi gas va nong do con
  LCD.setCursor(0, 0);
  LCD.print("Gas ");
  LCD.setCursor(0, 1);
  LCD.print(gasValue);
  LCD.print("  ");
  LCD.setCursor(9, 0);
  LCD.print("TEMP ");
  LCD.setCursor(9, 1);
  LCD.print(tempValue);
  LCD.print("  ");
  delay(100);
  // Compare current gas and alcohol value to their limitt
  // So sanh cac gia tri nguong
  if (buttonStatus == HIGH) digitalWrite(LED_YELLOW_PIN, LOW);
  if (((tempValue < 30) && (gasValue < GAS_LIMIT2))) {
    // Safe
    // An toan
    digitalWrite(LED_GREEN_PIN, HIGH);
    digitalWrite(LED_YELLOW_PIN, HIGH);
    digitalWrite(LED_RED_PIN, LOW);
    digitalWrite(BUZZER_PIN, LOW);
  }

  if (((tempValue <= TEMP_LIMIT1) && (tempValue > TEMP_LIMIT2)) || ((gasValue <= GAS_LIMIT1) && (gasValue > GAS_LIMIT2))) {
    // Turn on warning Led Level 1 and Alarm
    // Bat canh bao Led muc 1 va coi bao dong
    digitalWrite(LED_GREEN_PIN, HIGH);
    //digitalWrite(LED_YELLOW_PIN, LOW);
    digitalWrite(LED_RED_PIN, LOW);
    digitalWrite(BUZZER_PIN, HIGH);
    delay(300);
    digitalWrite(LED_GREEN_PIN, LOW);
    digitalWrite(LED_YELLOW_PIN, LOW);
    digitalWrite(LED_RED_PIN, HIGH);
    digitalWrite(BUZZER_PIN, LOW);
  }

  if ((tempValue > TEMP_LIMIT1) || (gasValue > GAS_LIMIT1)) {
    // Turn on warning Led level 2 and Alarm
    // Bat canh bao led muc 2 va coi hoat dong lien tuc
    digitalWrite(LED_GREEN_PIN, LOW);
    digitalWrite(LED_YELLOW_PIN, LOW);
    digitalWrite(LED_RED_PIN, HIGH);
    digitalWrite(BUZZER_PIN, HIGH);
    delay(100);
    //Tat cac canh bao
    digitalWrite(LED_GREEN_PIN, LOW);
    //digitalWrite(LED_YELLOW_PIN, LOW);
    digitalWrite(LED_RED_PIN, LOW);
   // digitalWrite(BUZZER_PIN, LOW);
  }
}
