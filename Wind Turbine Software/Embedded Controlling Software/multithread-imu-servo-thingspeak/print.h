// print.h

// Factores de conversion
const float accScale = 9.81 / 16384.0;
const float gyroScale = 250.0 / 32768.0;

// Mostrar medidas en crudo
void printAccRAW(int16_t *ax, int16_t *ay, int16_t *az) {
  Serial.print("RAW a[x y z]: ");
  Serial.print(*ax); Serial.print("\t");
  Serial.print(*ay); Serial.print("\t");
  Serial.println(*az);
}

void printRAW(int16_t ax, int16_t ay, int16_t az, int16_t gx, int16_t gy, int16_t gz) {
  Serial.print("RAW a[x y z] g[x y z]: ");
  Serial.print(ax); Serial.print("\t");
  Serial.print(ay); Serial.print("\t");
  Serial.print(az); Serial.print("\t");
  Serial.print(gx); Serial.print("\t");
  Serial.print(gy); Serial.print("\t");
  Serial.println(gz);
}

// Mostrar medidas en SI
void printSI(int16_t ax, int16_t ay, int16_t az, int16_t gx, int16_t gy, int16_t gz) {
  Serial.print("SI a[x y z] g[x y z]: ");
  Serial.print(ax * accScale); Serial.print("\t");
  Serial.print(ay * accScale); Serial.print("\t");
  Serial.print(az * accScale); Serial.print("\t");
  Serial.print(gx * gyroScale); Serial.print("\t");
  Serial.print(gy * gyroScale); Serial.print("\t");
  Serial.println(gz * gyroScale);
}
