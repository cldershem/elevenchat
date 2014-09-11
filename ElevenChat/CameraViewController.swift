//
//  CameraViewController.swift
//  ElevenChat
//
//  Created by Cameron Dershem on 9/11/14.
//  Copyright (c) 2014 Cameron Dershem. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var cameraView: UIView!
    
    // our global session
    private let captureSession = AVCaptureSession()
    // the camera, if found
    private var captureDevice : AVCaptureDevice?
    // which camera
    private var cameraPosition = AVCaptureDevicePosition.Back
    // JPEG output
    private var stillImageOutput : AVCaptureStillImageOutput?
    // preview layer
    private var previewLayer : AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        if findCamera(cameraPosition) {
            // start session
            beginSession()
        } else {
            // show sad error
        }
        
    }
    
    // find camera
    func findCamera(position : AVCaptureDevicePosition) -> Bool {
        
        // grab all video capture devices
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        
        // find the camera matching the position
        for device in devices {
            if device.position == position {
                captureDevice = device as? AVCaptureDevice
            }
        }
        
        return captureDevice != nil
        
    }
    
    // start the capture session
    func beginSession() {
        var err : NSError? = nil
        
        // try to open the device
        let videoCapture = AVCaptureDeviceInput(device: captureDevice, error: &err)
        
        if err != nil {
            // Fail silently.  Do better in the real world.
            println("Capture session could not start: \(err?.description)")
            return
        }
        
        // add video input
        if captureSession.canAddInput(videoCapture) {
            captureSession.addInput(videoCapture)
        }
        
        // config capture session
        if !captureSession.running {
            // set JPEG output
            stillImageOutput = AVCaptureStillImageOutput()
            let outputSettings = [ AVVideoCodecKey : AVVideoCodecJPEG ]
            stillImageOutput!.outputSettings = outputSettings
            
            // add output to session
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            
            // display camera in UI
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            cameraView.layer.addSublayer(previewLayer)
            previewLayer?.frame = cameraView.layer.frame
            previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            // start camera
            captureSession.startRunning()
        }
    }
    
    
    
    @IBAction func flipCamera(sender: UIButton) {
        // Flip the camera
        
        // when session is running to make change you must...
        captureSession.beginConfiguration()
        // find and remove input
        let currentInput = captureSession.inputs[0] as AVCaptureInput
        captureSession.removeInput(currentInput)
        
        // toggle camera (if this then that if not then that)
        cameraPosition = cameraPosition == .Back ? .Front : .Back
        
        // find other camera
        if findCamera(cameraPosition) {
            beginSession()
        } else {
            // show sad panda
        }
        
        // commit changes
        captureSession.commitConfiguration()
    }
    
    @IBAction func takePhoto(sender: UIButton) {
        if let stillOutput = self.stillImageOutput {
            
            // we do this on another thread so we don't hang the UI
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                // find video connection
                var videoConnection : AVCaptureConnection?
                for connection in stillOutput.connections {
                    // find a matching input port
                    for port in connection.inputs! {
                        // and matching type
                        if port.mediaType == AVMediaTypeVideo {
                            videoConnection = connection as? AVCaptureConnection
                            break
                        }
                    }
                    if videoConnection != nil {
                        break // for connection
                    }
                }
                
                if videoConnection != nil {
                    // found the video connection, let's get the image
                    stillOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
                        (imageSampleBuffer:CMSampleBuffer!, _) in
                        
                        let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
                        
                        self.didTakePhoto(imageData)
                    }
                }
            }
        }
    }
    
    func didTakePhoto(imageData: NSData) {
        
        // Example 1: if you want to show thumbnail
        let imate = UIImage(data: imageData)
        
        // Example 2: if you want to save image
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let prefix: String = formatter.stringFromDate(NSDate())
        let fileName = "\(prefix).jpg"
        
        let tmpDirectory = NSTemporaryDirectory()
        let snapFileName = tmpDirectory.stringByAppendingPathComponent(fileName)
        imageData.writeToFile(snapFileName, atomically: true)
        
    }
}

