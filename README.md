# 🚀 ColorDetectOpenCV

This project demonstrates **real-time color detection** using **OpenCV** in an iOS app. It captures live video from the camera, processes frames, and detects **green-colored objects**, drawing bounding boxes around them.

Inspired by [this video](https://www.youtube.com/watch?v=aFNDh5k3SjU).

---

## 🖼️ Preview
![Color Detection Preview](https://github.com/user-attachments/assets/3e3f111d-d65f-4ab1-a677-7e5f70cda134)

---

## ✨ Features
✔ Uses `AVFoundation` to capture live video frames.  
✔ Implements **real-time green object detection** using OpenCV.  
✔ Draws bounding boxes around detected objects.  
✔ Utilizes **Objective-C++ wrapper** to bridge OpenCV with Swift.  

---

## 📦 Install CocoaPods
This project uses OpenCV, which is installed via **CocoaPods**. To set up the dependencies, run:
```sh
pod install
```
Then, open the `.xcworkspace` file instead of `.xcodeproj`.

---

## 🔗 Add Bridging Header
Since OpenCV is written in **C++**, it **cannot be called directly from Swift**. We use an **Objective-C++ wrapper (`OpenCVWrapper`)** to bridge OpenCV with Swift.

1. Create a **bridging header file** named:  
   `ColorDetectOpenCV-Bridging-Header.h`
   
2. Add the following inside the file:
   ```objc
   #import "OpenCVWrapper.h"
   ```

3. In **Build Settings**, search for `Objective-C Bridging Header` and set the path to:
   ```
   $(SRCROOT)/ColorDetectOpenCV/Helper/Header/ColorDetectOpenCV-Bridging-Header.h
   ```

---

## ❓ Why Can't We Call OpenCV Directly in Swift?
1. **Swift Does Not Support C++ Directly**  
   - OpenCV is built in **C++**, and Swift **cannot** directly call C++ code.  
   - **Solution:** Use **Objective-C++ (`.mm` files)** as a bridge.

2. **CocoaPods Installs OpenCV as a Precompiled Framework**  
   - The OpenCV framework installed via CocoaPods does **not** provide Swift-compatible headers.  
   - **Solution:** Use a bridging header to expose OpenCV functions inside an **Objective-C wrapper**.
