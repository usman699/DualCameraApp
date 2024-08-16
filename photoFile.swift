//import UIKit
//import AVFoundation
//import Photos
//
//class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
//    var captureSession: AVCaptureSession?
//    var frontCamera: AVCaptureDevice?
//    var backCamera: AVCaptureDevice?
//    var currentCamera: AVCaptureDevice?
//    var photoOutput: AVCapturePhotoOutput?
//    var previewLayer: AVCaptureVideoPreviewLayer?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Check for camera availability
//        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
//              let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
//        else {
//            print("Camera not available.")
//            return
//        }
//        
//        self.frontCamera = frontCamera
//        self.backCamera = backCamera
//        
//        // Set the default camera as the back camera
//        currentCamera = backCamera
//        
//        // Initialize the capture session
//        captureSession = AVCaptureSession()
//        captureSession?.sessionPreset = .photo
//        
//        // Setup input and output
//        do {
//            let frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
//            let backCameraInput = try AVCaptureDeviceInput(device: backCamera)
//            
//            if captureSession?.canAddInput(frontCameraInput) ?? false {
//                captureSession?.addInput(frontCameraInput)
//            }
//            
//            if captureSession?.canAddInput(backCameraInput) ?? false {
//                captureSession?.addInput(backCameraInput)
//            }
//            
//            photoOutput = AVCapturePhotoOutput()
//            
//            if captureSession?.canAddOutput(photoOutput!) ?? false {
//                captureSession?.addOutput(photoOutput!)
//            }
//            
//            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
//            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
//            previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
//            previewLayer?.frame = view.bounds
//            view.layer.insertSublayer(previewLayer!, at: 0)
//            
//            captureSession?.startRunning()
//        } catch {
//            print("Error setting up camera input: \(error)")
//        }
//    }
//    
//    @IBAction func captureButtonPressed(_ sender: UIButton) {
//        guard let photoOutput = self.photoOutput else {
//            return
//        }
//        
//        // Create photo settings for both front and back cameras
//        let photoSettings = AVCapturePhotoSettings()
//        photoSettings.isHighResolutionPhotoEnabled = true
//        
//        // Capture photo for the front camera
//        if let frontCamera = self.frontCamera {
//            if let flashModeValue = AVCaptureDevice.FlashMode.auto.rawValue as? Int,
//               let flashMode = AVCaptureDevice.FlashMode(rawValue: flashModeValue) {
//                
//                photoSettings.isCameraCalibrationDataDeliveryEnabled = true
//                photoOutput.capturePhoto(with: photoSettings, delegate: self)
//            }
//        }
//            
//            // Switch to the back camera and capture photo
//            if let backCamera = self.backCamera {
//                currentCamera = backCamera
//                
//                if let flashModeValue = AVCaptureDevice.FlashMode.auto.rawValue as? Int,
//                   let flashMode = AVCaptureDevice.FlashMode(rawValue: flashModeValue) {
//                    
//                    photoSettings.isCameraCalibrationDataDeliveryEnabled = true
//                    photoOutput.capturePhoto(with: photoSettings, delegate: self)
//                }
//            }
//            
//            // Delegate method called when the photo is captured
//            func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//                guard let imageData = photo.fileDataRepresentation() ,   let image = UIImage(data: imageData) else {
//                    return
//                }
//                
//                // Save the captured image to the photo gallery
//                PHPhotoLibrary.shared().performChanges({
//                    let creationRequest = PHAssetCreationRequest.forAsset()
//                    let placeholder = creationRequest.placeholderForCreatedAsset
//                    creationRequest.addResource(with: .photo, data: imageData, options: nil)
//                    
//                    // Save the image to the gallery
//                    PHAssetChangeRequest.creationRequestForAsset(from: image)
//                }, completionHandler: { _, error in
//                    if let error = error {
//                        print("Error saving photo to gallery: \(error)")
//                    } else {
//                        print("Photo saved to gallery.")
//                    }
//                })
//            }
//        }
//    }



//import AVFoundation
//import Photos
//import UIKit
//class photoFileViewController: UIViewController, AVCapturePhotoCaptureDelegate {
//
//    var captureSession: AVCaptureSession?
//    var frontCamera: AVCaptureDevice?
//    var backCamera: AVCaptureDevice?
//    var photoOutput: AVCapturePhotoOutput?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupCaptureSession()
//        setupCameraDevices()
//        setupInputOutput()
//        startCaptureSession()
//    }
//    @IBAction func names(_ sender: Any) {
//        print("clicked")
//        capturePhoto()
//    }
//
//    func setupCaptureSession() {
//        captureSession = AVCaptureSession()
//        captureSession?.sessionPreset = .photo
//    }
//
//    func setupCameraDevices() {
//        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
//                                                                      mediaType: .video,
//                                                                      position: .unspecified)
//        let devices = deviceDiscoverySession.devices
//
//        for device in devices  {
//            if device.position == .front {
//                frontCamera = device
//            } else if device.position == .back {
//                backCamera = device
//            }
//        }
//    }
//
//    func setupInputOutput() {
//        // Setup input for back camera
//        if let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
//            do {
//                let backCameraInput = try AVCaptureDeviceInput(device: backCamera)
//                if ((captureSession?.canAddInput(backCameraInput)) != nil) {
//                    captureSession!.addInput(backCameraInput)
//                }
//            } catch {
//                // Handle error
//                print("Error setting up back camera input: \(error.localizedDescription)")
//            }
//        } else {
//            // Back camera is not available
//            print("Back camera not available")
//        }
//
//        // Setup input for front camera
//        if let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
//            do {
//                let frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
//                if ((captureSession?.canAddInput(frontCameraInput)) != nil) {
//                    captureSession?.addInput(frontCameraInput)
//                }
//            } catch {
//                // Handle error
//                print("Error setting up front camera input: \(error.localizedDescription)")
//            }
//        } else {
//            // Front camera is not available
//            print("Front camera not available")
//        }
//
//        // Setup output
//        let photoOutput = AVCapturePhotoOutput()
//        if ((captureSession?.canAddOutput(photoOutput)) != nil) {
//            captureSession?.addOutput(photoOutput)
//        }
//    }
//
//    func startCaptureSession() {
//
//
//
//
//
//
//
//
//        guard let captureSession = captureSession else { return }
//        if !captureSession.isRunning {
//            captureSession.startRunning()
//        }
//    }
//
//    func capturePhoto() {
//        guard let photoOutput = photoOutput else { return }
//
//        let photoSettings = AVCapturePhotoSettings()
//        photoSettings.isHighResolutionPhotoEnabled = true
//
//        photoOutput.capturePhoto(with: photoSettings, delegate: self)
//    }
//
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        if let imageData = photo.fileDataRepresentation() {
//            let frontImage = UIImage(data: imageData)
//            let backImage = getBackCameraImage()
//            let mergedImage = mergeImages(frontImage: frontImage, backImage: backImage)
//
//            saveImageToGallery(image: mergedImage)
//        }
//    }
//
//    func getBackCameraImage() -> UIImage? {
//        // Perform necessary steps to capture an image from the back camera
//        // Return the captured image
//
//        return nil
//    }
//
//    func mergeImages(frontImage: UIImage?, backImage: UIImage?) -> UIImage? {
//        guard let frontImage = frontImage, let backImage = backImage else { return nil }
//
//        let mergedSize = CGSize(width: frontImage.size.width + backImage.size.width, height: max(frontImage.size.height, backImage.size.height))
//
//        UIGraphicsBeginImageContextWithOptions(mergedSize, false, 0.0)
//
//        frontImage.draw(in: CGRect(x: 0, y: 0, width: frontImage.size.width, height: frontImage.size.height))
//        backImage.draw(in: CGRect(x: frontImage.size.width, y: 0, width: backImage.size.width, height: backImage.size.height))
//
//        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
//
//        UIGraphicsEndImageContext()
//
//        return mergedImage
//    }
//
//    func saveImageToGallery(image: UIImage?) {
//        guard let image = image else { return }
//
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetChangeRequest.creationRequestForAsset(from: image)
//        }) { success, error in
//            if let error = error {
//                print("Error saving image to gallery: \(error.localizedDescription)")
//            } else {
//                print("Image saved to gallery successfully.")
//            }
//        }
//    }
//
//    // Add a button action to trigger the capturePhoto() method
//}
//




import AVFoundation
import Photos
import UIKit

class  photoFileViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    private var captureSession: AVCaptureSession?
    private var frontCamera: AVCaptureDevice?
    private var backCamera: AVCaptureDevice?
    private var photoOutput: AVCapturePhotoOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupCameraDevices()
        setupPhotoOutput()
        
        startCaptureSession()
    }
    
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
    }
    
    private func setupCameraDevices() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        
        for device in discoverySession.devices {
            if device.position == .front {
                frontCamera = device
            } else if device.position == .back {
                backCamera = device
            }
        }
    }
    
    private func setupPhotoOutput() {
        photoOutput = AVCapturePhotoOutput()
        
        if let photoOutput = photoOutput {
            if captureSession?.canAddOutput(photoOutput) ?? false {
                captureSession?.addOutput(photoOutput)
            }
        }
    }
    
    private func startCaptureSession() {
        do {
            guard let captureSession = captureSession else { return }
            
            let frontCameraInput = try AVCaptureDeviceInput(device: frontCamera!)
            let backCameraInput = try AVCaptureDeviceInput(device: backCamera!)
            
            let audioDevice = AVCaptureDevice.default(for: .audio)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice!)
            
            if captureSession.canAddInput(frontCameraInput) && captureSession.canAddInput(backCameraInput) && captureSession.canAddInput(audioInput) {
                captureSession.addInput(frontCameraInput)
                captureSession.addInput(backCameraInput)
                captureSession.addInput(audioInput)
                
                captureSession.startRunning()
            }
        } catch {
            print("Error starting capture session: \(error.localizedDescription)")
        }
    }

//    
    
    // Method to capture photo from front and back cameras
    func capturePhoto() {
        let frontCameraSettings = AVCapturePhotoSettings()
        let backCameraSettings = AVCapturePhotoSettings()
        
        if let frontCameraPhotoOutput = photoOutput, let backCameraPhotoOutput = photoOutput {
            frontCameraPhotoOutput.capturePhoto(with: frontCameraSettings, delegate: self)
            backCameraPhotoOutput.capturePhoto(with: backCameraSettings, delegate: self)
        }
    }
    
    // Delegate method called when photo capture is completed
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(), let capturedImage = UIImage(data: imageData) {
            saveImageToGallery(image: capturedImage)
        }
    }
    
    // Method to save image to the gallery
    func saveImageToGallery(image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            if let error = error {
                print("Error saving photo to gallery: \(error.localizedDescription)")
            } else {
                print("Photo saved to gallery successfully.")
            }
        }
    }
}








//func setupFrontCamera() {
//        do {
//            guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
//                print("Error: Front camera not available.")
//                return
//            }
//            let frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
//
//          let   frontCameraSession = AVCaptureSession()
//
//            if frontCameraSession.canAddInput(frontCameraInput) {
//                frontCameraSession.addInput(frontCameraInput)
//            } else {
//                print("Error: Could not add front camera input to the session.")
//                return
//            }
//
//          let  frontVideoOutput = AVCaptureVideoDataOutput()
//            if frontCameraSession.canAddOutput(frontVideoOutput) {
//                frontCameraSession.addOutput(frontVideoOutput)
//            } else {
//                print("Error: Could not add front camera output to the session.")
//                return
//            }
//
//            frontVideoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "frontCameraQueue"))
//
//          let   frontVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: frontCameraSession)
//            frontVideoPreviewLayer.videoGravity = .resizeAspectFill
//            frontVideoPreviewLayer.frame = view.layer.bounds
//            view.layer.addSublayer(frontVideoPreviewLayer)
//
//            frontCameraSession.startRunning()
//        } catch {
//            print("Error: \(error.localizedDescription)")
//        }
//    }
//
//
//
//func setupBackCamera() {
//        do {
//            guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
//                print("Error: Back camera not available.")
//                return
//            }
//
//            let backCameraInput = try AVCaptureDeviceInput(device: backCamera)
//
//           let backCameraSession = AVCaptureSession()
//
//            if backCameraSession.canAddInput(backCameraInput) {
//                backCameraSession.addInput(backCameraInput)
//            } else {
//                print("Error: Could not add back camera input to the session.")
//                return
//            }
//
//          let  backVideoOutput = AVCaptureVideoDataOutput()
//            if backCameraSession.canAddOutput(backVideoOutput) {
//                backCameraSession.addOutput(backVideoOutput)
//            } else {
//                print("Error: Could not add back camera output to the session.")
//                return
//            }
//
//            backVideoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "backCameraQueue"))
//
//          let  backVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: backCameraSession)
//            backVideoPreviewLayer.videoGravity = .resizeAspectFill
//            backVideoPreviewLayer.frame = view.layer.bounds
//            view.layer.addSublayer(backVideoPreviewLayer)
//
//            backCameraSession.startRunning()
//        } catch {
//            print("Error: \(error.localizedDescription)")
//        }
//    }
//func mergeImages(frontCameraImage: UIImage, backCameraImage: UIImage) -> UIImage? {
//        // Merge the two images into a single image.
//        // You can implement your logic here to combine the images as per your requirement.
//        // For example, you can overlay one image on the other or combine them side by side.
//        // In this example, we'll stack them vertically.
//
//        let mergedSize = CGSize(width: max(frontCameraImage.size.width, backCameraImage.size.width),
//                                height: frontCameraImage.size.height + backCameraImage.size.height)
//
//        UIGraphicsBeginImageContextWithOptions(mergedSize, false, 0.0)
//
//        frontCameraImage.draw(in: CGRect(x: 0, y: 0, width: mergedSize.width, height: frontCameraImage.size.height))
//        backCameraImage.draw(in: CGRect(x: 0, y: frontCameraImage.size.height, width: mergedSize.width, height: backCameraImage.size.height))
//
//        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return mergedImage
//    }
//
//
//private func captureOutputs(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//        print("Error: Video frame buffer not available.")
//        return
//    }
//
//    let ciImage = CIImage(cvPixelBuffer: imageBuffer)
//    let context = CIContext(options: nil)
//
//    if output == frontCameraVideoDataOutput {
//        let frontCameraImage = UIImage(ciImage: ciImage)
//        self.frontImage = frontCameraImage
//    } else if output == frontCameraVideoDataOutput {
//        let backCameraImage = UIImage(ciImage: ciImage)
//        self.backImage = backCameraImage
//    }
//
//    // Check if both frontImage and backImage are available
//    if let frontImage = self.frontImage, let backImage = self.backImage {
//        // At this point, you have received video frames from both cameras.
//        // You can proceed to merge or combine the images and save the resulting image to the gallery.
//    }
//
//func imageFromSampleBuffer(_ sampleBuffer: CMSampleBuffer) -> UIImage? {
//       if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
//           let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
//           let context = CIContext()
//           if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
//               return UIImage(cgImage: cgImage)
//           }
//       }
//       return nil
//   }
//}
