//
//  MainVC.swift
//  ColorDetectOpenCV
//
//  Created by lymanny on 14/2/25.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var videoOutput: AVCaptureVideoDataOutput!
    var detectionLayer: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupDetectionLayer()
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high

        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("No video camera available")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            captureSession.addInput(input)
        } catch {
            print("Error setting up camera input: \(error)")
            return
        }

        videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(videoOutput)

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)

        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func setupDetectionLayer() {
        detectionLayer = UIImageView(frame: view.bounds)
        detectionLayer.contentMode = .scaleAspectFit
        detectionLayer.backgroundColor = UIColor.clear
        view.addSubview(detectionLayer)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("[Camera] Error: Failed to get image buffer.")
            return
        }

        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            print("[Camera] Error: Failed to create CGImage from CIImage.")
            return
        }

        let uiImage = UIImage(cgImage: cgImage)
        let originalSize = CGSize(width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))

        DispatchQueue.global(qos: .userInteractive).async {
            if let processedImage = OpenCVWrapper.detectGreenObjects(uiImage, originalSize: originalSize) {
                DispatchQueue.main.async {
                    self.detectionLayer.image = processedImage // Show bounding boxes on top
                }
            } else {
                print("[OpenCV] Error: Failed to process image.")
            }
        }
    }
}
