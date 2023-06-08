#include <WebSocketsClient.h>
#include <ESP8266WiFi.h>
#include <DHT.h>
#include <ArduinoJson.h>
int relayPin = 2;
const char *ssid = "...";
const char *password = "thanhlich1234";
const char *host = "192.168.67.43";
int moto = 0;
int bongden = 0;
int tudong = 0;
int fan = 0;
int senServer = 0;
int senServerbd = 0;
int senServerq = 0;
int port = 8080;
const int dht11Pin = D3;
const int light_sensor_pin = D5;
#define SOIL_MOIST_1_PIN A0
// Define DHT11 sensor object
DHT dht11(dht11Pin, DHT11);
WebSocketsClient webSocket;
WiFiClient client;
unsigned long previousMillis = 0;
const unsigned long interval = 500;
void webSocketEvent(WStype_t type, uint8_t *payload, size_t length)
{
  switch (type)
  {
  case WStype_DISCONNECTED:
    Serial.printf("[WSc] Disconnected!\n");
    break;
  case WStype_CONNECTED:
  {
    Serial.printf("[WSc] Connected to url: %s\n", payload);
    break;
  }
  case WStype_BIN:
    // Serial.printf("[WSc] get binary length: %u\n", length);
    break;
  case WStype_TEXT:
  {
    DynamicJsonDocument doc(1024);
    deserializeJson(doc, payload);
    moto = doc["moto"];
    bongden = doc["bongden"];
    tudong = doc["tudong"];
    fan = doc["quat"];
    if (tudong == 0)
    {
      moto = 0;
      bongden=0;
      fan = 0;
      if (moto == 1)
      {
        Serial.println("Bật moto nước");
        moto = 1;
      }
      else if (moto == 0)
      {
        Serial.println("Tắt moto nước");
        moto = 0;
      }
      if (bongden == 1)
      {
        Serial.println("Bật bóng đèn");
        bongden = 1;
      }
      else if (bongden == 0)
      {
        Serial.println("Tắt bóng đèn");
        bongden = 0;
      }
      if (fan == 1)
      {
        Serial.println("Bật fan nước");
        fan = 1;
      }
      else if (fan == 0)
      {
        Serial.println("Tắt fan nước");
        fan = 0;
      }
    }
    else
    {
      Serial.println("Tự Động");
    }
    break;
  }
  default:
    break;
  }
}

void setup()
{
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");
  webSocket.begin(host, 8080, "/", "arduino");
  webSocket.onEvent(webSocketEvent);
  pinMode(2, OUTPUT);
  pinMode(5, OUTPUT);
    pinMode(4, OUTPUT);
  dht11.begin();
}

void loop()
{
  webSocket.loop();
  // Ít nước:0%  ==> Nhiều nước 100%
  unsigned long currentMillis = millis();
  int i = 0;
  int anaValue = 0;
  for (i = 0; i < 10; i++) //
  {
    anaValue += analogRead(SOIL_MOIST_1_PIN); // Đọc giá trị cảm biến độ ẩm đất
    delay(50);                                // Đợi đọc giá trị ADC
  }
  anaValue = anaValue / (i);
  anaValue = map(anaValue, 1023, 0, 0, 100); // Ít nước:0%  ==> Nhiều nước 100%
  int light_value = digitalRead(light_sensor_pin);
  Serial.print("thai");
  Serial.print(light_value);
  Serial.print("ngu");
  float temperature = dht11.readTemperature();
  float humidity = dht11.readHumidity();
  if (isnan(temperature))
  {
    temperature = 32;
  }
  if (isnan(humidity))
  {
    humidity = 70;
  }
  Serial.print(" %\t");
  Serial.print("Do am dat: ");
  Serial.print(anaValue);
  Serial.println(" %");
  Serial.print(" %\t");
  Serial.print("Nhiet do: ");
  Serial.print(temperature);
  Serial.println(" %");
  Serial.print(" %\t");
  Serial.print("Do am : ");
  Serial.print(humidity);
  Serial.println(" %");
  Serial.println(moto);
  Serial.println(bongden);
  if (tudong == 0)
  {
    if (moto == 1)
    {                        // nếu giá trị đầu vào là '1'
      digitalWrite(5, HIGH); // đặt chân kết nối với module relay ở mức cao
    }
    else if (moto == 0)
    {                       // nếu giá trị đầu vào là '0'
      digitalWrite(5, LOW); // đặt chân kết nối với module relay ở mức thấp
    }
    if (bongden == 1)
    {
      digitalWrite(2, HIGH);
      bongden = 1;
    }
    else if (bongden == 0)
    {
      digitalWrite(2, LOW);
      bongden = 0;
    }
        if (fan == 1)
    {
      digitalWrite(4, LOW);
      fan = 1;
    }
    else if (fan == 0)
    {
      digitalWrite(4, HIGH);
      fan = 0;
    }
  }
  else
  {
    if (anaValue <50)
    {                        // nếu giá trị đầu vào là '1'
      digitalWrite(5, HIGH); // đặt chân kết nối với module relay ở mức cao
      Serial.println("Bật moto nước");
      senServer = 1;
    }
    else
    {                       // nếu giá trị đầu vào là '0'
      digitalWrite(5, LOW); // đặt chân kết nối với module relay ở mức thấp
      Serial.println("Tắt moto nước");
      senServer = 0;
    }
      if (light_value == 1)
    {                        // nếu giá trị đầu vào là '1'
      digitalWrite(2, HIGH); // đặt chân kết nối với module relay ở mức cao
      Serial.println("Bật Bóng Đèn");
      senServerbd = 1;
    }
    else
    {                       // nếu giá trị đầu vào là '0'
      digitalWrite(2, LOW); // đặt chân kết nối với module relay ở mức thấp
      Serial.println("Tắt Bóng Đèn");
      senServerbd = 0;
    }
          if (temperature > 30)
    {                        // nếu giá trị đầu vào là '1'
      digitalWrite(4, LOW); // đặt chân kết nối với module relay ở mức cao
      Serial.println("Bật Quat");
      senServerq = 1;
    }
    else
    {                       // nếu giá trị đầu vào là '0'
      digitalWrite(4, HIGH); // đặt chân kết nối với module relay ở mức thấp
      Serial.println("Tắt Quat");
      senServerq = 0;
    }
  }

  if (currentMillis - previousMillis >= interval)
  {
    previousMillis = currentMillis;
    unsigned long currentMillis = millis();

    // Chuyển đổi giá trị nhiệt độ và độ ẩm sang kiểu chuỗi
    String tempStr = String(temperature, 1);
    String humiStr = String(humidity, 1);
    String message = "{\"temperature\": " + tempStr + ", \"humidity\": " + humiStr + ", \"anaValue\": " + anaValue + ", \"sendServer\": " + senServer + ", \"sendServerbd\": " + senServerbd + ", \"sendServerq\": " + senServerq + " }";
    const char *messageStr = message.c_str();
    webSocket.sendTXT(messageStr);
  }
}
