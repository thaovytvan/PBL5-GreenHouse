import cv2
import os
import sys
from ultralytics import YOLO
image_file = sys.argv[1]
model = YOLO("./py/best.pt")
results = model.predict(source=image_file, show=True, save=True)
boxes = results[0].boxes.numpy()
print(len(boxes.cls))