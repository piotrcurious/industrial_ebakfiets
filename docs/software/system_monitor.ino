/*
 * Industrial E-Bakfiets: Supervisory Controller (Reference Implementation)
 *
 * Target: Arduino Nano / ESP32
 * Function: Monitors dual-motor current, temperatures, and battery SOC.
 * Displays data on a 20x4 I2C LCD for the operator.
 */

#include <Wire.h>
#include <LiquidCrystal_I2C.h>

// Pin Definitions
const int PIN_BATTERY_V = A0;  // 0-60V via Voltage Divider (10k/1k)
const int PIN_FRONT_CURR = A1; // 0-50A via Shunt (ASC712 or similar)
const int PIN_REAR_CURR  = A2;
const int PIN_FRONT_TEMP = A3; // NTC 10k Thermistor in motor housing
const int PIN_REAR_TEMP  = A4;
const int PIN_ALARM_BUZZER = 9;

// Calibration Constants
const float VOLT_DIVIDER_RATIO = 11.0; // (10k+1k)/1k
const float AMPS_PER_VOLT = 20.0;      // Calibration for current sensor
const int TEMP_THRESHOLD = 85;         // Max Celsius before alarm

// Global State
float batVoltage = 0;
float frontAmps = 0;
float rearAmps  = 0;
int frontTemp = 0;
int rearTemp  = 0;

LiquidCrystal_I2C lcd(0x27, 20, 4);

void setup() {
  Serial.begin(9600);
  lcd.init();
  lcd.backlight();
  pinMode(PIN_ALARM_BUZZER, OUTPUT);

  lcd.setCursor(0,0);
  lcd.print("E-BAKFIETS SYSTEM");
  lcd.setCursor(0,1);
  lcd.print("BOOTING V1.0...");
  delay(1000);
}

void loop() {
  readSensors();
  checkSafety();
  updateDisplay();
  delay(500);
}

void readSensors() {
  // Battery Voltage
  int rawV = analogRead(PIN_BATTERY_V);
  batVoltage = (rawV * (5.0 / 1023.0)) * VOLT_DIVIDER_RATIO;

  // Currents
  frontAmps = (analogRead(PIN_FRONT_CURR) - 512) * (5.0 / 1023.0) * AMPS_PER_VOLT;
  rearAmps  = (analogRead(PIN_REAR_CURR) - 512) * (5.0 / 1023.0) * AMPS_PER_VOLT;

  // Temperatures (Simplistic Linear Approximation for NTC)
  frontTemp = map(analogRead(PIN_FRONT_TEMP), 0, 1023, 20, 150);
  rearTemp  = map(analogRead(PIN_REAR_TEMP), 0, 1023, 20, 150);
}

void checkSafety() {
  if (frontTemp > TEMP_THRESHOLD || rearTemp > TEMP_THRESHOLD) {
    digitalWrite(PIN_ALARM_BUZZER, HIGH);
    lcd.setCursor(0,3);
    lcd.print("!! OVERHEAT ALARM !!");
  } else {
    digitalWrite(PIN_ALARM_BUZZER, LOW);
  }
}

void updateDisplay() {
  lcd.clear();
  // Row 0: Battery
  lcd.setCursor(0,0);
  lcd.print("BAT: "); lcd.print(batVoltage, 1); lcd.print("V ");
  lcd.print((batVoltage > 48) ? "HIGH" : "LOW");

  // Row 1: Front Motor
  lcd.setCursor(0,1);
  lcd.print("FR: "); lcd.print(frontAmps, 1); lcd.print("A ");
  lcd.print(frontTemp); lcd.print("C");

  // Row 2: Rear Motor
  lcd.setCursor(0,2);
  lcd.print("RR: "); lcd.print(rearAmps, 1); lcd.print("A ");
  lcd.print(rearTemp); lcd.print("C");

  // Row 3: Total Power
  float totalPower = batVoltage * (frontAmps + rearAmps);
  lcd.setCursor(0,3);
  lcd.print("PWR: "); lcd.print(totalPower, 0); lcd.print("W");
}
