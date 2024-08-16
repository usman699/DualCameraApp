import AVFoundation
import UIKit
import Photos

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    @IBAction func capturebutton(_ sender: Any) {
        capturePhoto()
    }
    
    let captureSession = AVCaptureSession()
    let frontCameraOutput = AVCapturePhotoOutput()
    let backCameraOutput = AVCapturePhotoOutput()
    let imageMergeQueue = DispatchQueue(label: "ImageMergeQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupCameraOutputs()
        startCaptureSession()
    }
    
    func setupCaptureSession() {
        // Configure capture session
        captureSession.sessionPreset = .photo
        
        // Set up video input from front camera
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        guard let frontCameraInput = try? AVCaptureDeviceInput(device: frontCamera) else { return }
        if captureSession.canAddInput(frontCameraInput) {
            captureSession.addInput(frontCameraInput)
        }
        
        // Set up video input from back camera
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        guard let backCameraInput = try? AVCaptureDeviceInput(device: backCamera) else { return }
        if captureSession.canAddInput(backCameraInput) {
            captureSession.addInput(backCameraInput)
        }
    }
    
    func setupCameraOutputs() {
        // Set up photo outputs for front and back cameras
        if captureSession.canAddOutput(frontCameraOutput) {
            captureSession.addOutput(frontCameraOutput)
        }
        if captureSession.canAddOutput(backCameraOutput) {
            captureSession.addOutput(backCameraOutput)
        }
    }
    
    func startCaptureSession() {
        // Start the capture session
        captureSession.startRunning()
    }
    
    func capturePhoto() {
        // Capture photos from front and back cameras
        let frontSettings = AVCapturePhotoSettings()
        let backSettings = AVCapturePhotoSettings()
        
        frontCameraOutput.capturePhoto(with: frontSettings, delegate: self)
        backCameraOutput.capturePhoto(with: backSettings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(),
           let frontImage = UIImage(data: imageData),
           let backImage = getBackCameraImage() {
            
            mergeImages(frontImage: frontImage, backImage: backImage) { mergedImage in
                // Save the merged image to the photo gallery
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: mergedImage)
                }) { success, error in
                    if let error = error {
                        print("Error saving merged image: \(error.localizedDescription)")
                    } else {
                        print("Merged image saved to gallery.")
                    }
                }
            }
        }
    }
    
    func getBackCameraImage() -> UIImage? {
        // Retrieve the most recent captured back camera image
        // You can customize this method based on your requirements
        // For example, you can store the back camera images in an array and retrieve the desired image
        // Here, we're simply returning nil as a placeholder
        
        return nil
    }
    
    func mergeImages(frontImage: UIImage, backImage: UIImage, completion: @escaping (UIImage) -> Void) {
        imageMergeQueue.async {
            // Merge the front and back camera images into a single image
            let size = CGSize(width: frontImage.size.width, height: frontImage.size.height + backImage.size.height)
            
            UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
            frontImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: frontImage.size.height))
            backImage.draw(in: CGRect(x: 0, y: frontImage.size.height, width: size.width, height: backImage.size.height))
            let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let mergedImage = mergedImage {
                DispatchQueue.main.async {
                    completion(mergedImage)
                }
            }
        }
    }
    
}

