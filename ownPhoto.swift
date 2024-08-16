import UIKit
import AVFoundation
import Photos

class ownphotoViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    var captureSession: AVCaptureSession?
    var frontCamera: AVCaptureDevice?
    var backCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check for camera availability
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        else {
            print("Camera not available.")
            return
        }
        
        self.frontCamera = frontCamera
        self.backCamera = backCamera
        
        // Set the default camera as the back camera
        currentCamera = backCamera
        
        // Initialize the capture session
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo
        
        // Setup input and output
        do {
            let frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            let backCameraInput = try AVCaptureDeviceInput(device: backCamera)
            
            if captureSession?.canAddInput(frontCameraInput) ?? false {
                captureSession?.addInput(frontCameraInput)
            }
            
            if captureSession?.canAddInput(backCameraInput) ?? false {
                captureSession?.addInput(backCameraInput)
            }
            
            photoOutput = AVCapturePhotoOutput()
            
            if captureSession?.canAddOutput(photoOutput!) ?? false {
                captureSession?.addOutput(photoOutput!)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            previewLayer?.frame = view.bounds
            view.layer.insertSublayer(previewLayer!, at: 0)
            
            captureSession?.startRunning()
        } catch {
            print("Error setting up camera input: \(error)")
        }
    }
    
    @IBAction func captureButtonPressed(_ sender: UIButton) {
        guard let photoOutput = self.photoOutput else {
            return
        }
        
        // Create photo settings for both front and back cameras
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = true
        
        // Capture photo for the front camera
        if let frontCamera = self.frontCamera {
//            if photoOutput.supportedFlashModes.contains(NSNumber(value: AVCaptureDevice.FlashMode.auto.rawValue)) {
//                photoSettings.flashMode = .auto
//            }
            
            photoSettings.isCameraCalibrationDataDeliveryEnabled = true
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
        
        // Switch to the back camera and capture photo
        if let backCamera = self.backCamera {
            currentCamera = backCamera
            
//            if photoOutput.supportedFlashModes.contains(NSNumber(value: AVCaptureDevice.FlashMode.auto.rawValue)) {
//                photoSettings.flashMode = .auto
//            }
            
            photoSettings.isCameraCalibrationDataDeliveryEnabled = true
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    // Delegate method called when the photo is captured
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        
        // Save the captured image to the photo gallery
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            let placeholder = creationRequest.placeholderForCreatedAsset
            creationRequest.addResource(with: .photo, data: imageData, options: nil)
            
            // Save the image to the gallery
//            PHAssetChangeRequest.creationRequestForAsset(from: placeh)
        }, completionHandler: { _, error in
            if let error = error {
                print("Error saving photo to gallery: \(error)")
            } else {
                print("Photo saved to gallery.")
            }
        })
    }
}

