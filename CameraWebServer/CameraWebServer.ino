#include <WiFi.h>
#include <WebSocketsClient.h>
#include "esp_camera.h"
#include "img_converters.h"

const char* ssid = "...";
const char* password = "thanhlich1234";
const char* host = " 192.168.67.43";
int port = 8080;
WebSocketsClient webSocket;
unsigned long previousMillis = 0;
const unsigned long interval = 10000;
  void webSocketEvent(WStype_t type, uint8_t * payload, size_t length) {
    switch (type) {
      case WStype_DISCONNECTED:
        Serial.printf("[WSc] Disconnected!\n");
        break;
      case WStype_CONNECTED: {
        Serial.printf("[WSc] Connected to url: %s\n", payload);
        break;
      }
      case WStype_BIN:
        Serial.printf("[WSc] get binary length: %u\n", length);
        break;
      case WStype_TEXT:
        Serial.println((char *)payload);
        break;
      default:
        break;
    }
  }

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");

  camera_config_t config;
  config.ledc_channel = LEDC_CHANNEL_0;
  config.ledc_timer = LEDC_TIMER_0;
  config.pin_d0 = 5;
  config.pin_d1 = 18;
  config.pin_d2 = 19;
  config.pin_d3 = 21;
  config.pin_d4 = 36;
  config.pin_d5 = 39;
  config.pin_d6 = 34;
  config.pin_d7 = 35;
  config.pin_xclk = 0;
  config.pin_pclk = 22;
  config.pin_vsync = 25;
  config.pin_href = 23;
  config.pin_sscb_sda = 26;
  config.pin_sscb_scl = 27;
  config.pin_pwdn = 32;
  config.pin_reset = -1;
  config.xclk_freq_hz = 20000000;
  config.pixel_format = PIXFORMAT_JPEG;
  if (psramFound()) {
    config.frame_size = FRAMESIZE_UXGA;
    config.jpeg_quality = 10;
    config.fb_count = 2;
  } else {
    config.frame_size = FRAMESIZE_SVGA;
    config.jpeg_quality = 12;
    config.fb_count = 1;
  }
  esp_err_t err = esp_camera_init(&config);
  if (err != ESP_OK) {
    Serial.printf("Camera init failed with error 0x%x", err);
    return;
  }
  Serial.println("Camera initialized");

  webSocket.begin(host, 8080, "/", "camesp32");
  webSocket.onEvent(webSocketEvent);
}

void loop() {
  webSocket.loop();
  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval) {
    camera_fb_t * fb = esp_camera_fb_get();
    if (fb) {
      size_t fb_len = fb->len;
      uint8_t * fb_buf = fb->buf;
      webSocket.sendBIN(fb_buf, fb_len);
      
      esp_camera_fb_return(fb);
      previousMillis = currentMillis;
    }
  }
}