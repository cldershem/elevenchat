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
}

