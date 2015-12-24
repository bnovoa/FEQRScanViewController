/*

FEQRScanViewController.swift

Created by Fabian Ehlert on 19.12.15.
Copyright © 2015 Fabian Ehlert. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

import UIKit
import AVFoundation

protocol FEQRScanViewControllerDelegate {
    func didScanCodeWithResult(result: String)
}

class FEQRScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var delegate: FEQRScanViewControllerDelegate?
    
    @IBOutlet weak var cameraView: UIView!
    
    private var closeTitle = "Close"
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    // MARK: Init
    
    init(closeTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.closeTitle = closeTitle
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Close-Button
        let doneButton = UIBarButtonItem(title: closeTitle, style: .Plain, target: self, action: "done")
        navigationItem.setLeftBarButtonItem(doneButton, animated: false)
  
        // Request camera access
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (granted: Bool) -> Void in
            if granted {
                self.setupScanner()
            } else {
                self.accessDenied()
            }
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Setup
    
    private func setupScanner() {
        // Initialize and configure the CaptureSession
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        configureSession(captureSession)

        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            if qrScanTypeAvailable(metadataOutput) {
                metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue()!)
                metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            } else {
                scannerFailed()
                return
            }
        } else {
            scannerFailed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.frame = cameraView.layer.bounds
        
        cameraView.layer.masksToBounds = true
        cameraView.layer.addSublayer(previewLayer)

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.captureSession.startRunning()
        })
        
        updateUI()
    }
    
    private func configureSession(session: AVCaptureSession) -> AVCaptureSession {
        session.beginConfiguration()
        
        for input in session.inputs {
            session.removeInput(input as! AVCaptureInput)
        }
        
        if let input = rearCamera() {
            session.addInput(input)
        }
        
        session.commitConfiguration()
        
        return session
    }
    
    private func rearCamera() -> AVCaptureDeviceInput? {
        // Search for input devices. If one is available, return it
        for device in (AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)) {
            if let captureDevice: AVCaptureDevice! = device as! AVCaptureDevice {
                if captureDevice.position == .Back {
                    var input: AVCaptureDeviceInput?
                    do {
                        input = try AVCaptureDeviceInput(device: captureDevice)
                        return input
                    } catch let error {
                        print(error)
                    }
                    return nil
                }
            }
        }
        return nil
    }
    
    private func qrScanTypeAvailable(metadataOutput: AVCaptureMetadataOutput) -> Bool {
        if let types: [String] = metadataOutput.availableMetadataObjectTypes as? [String] {
            if types.contains(AVMetadataObjectTypeQRCode) {
                return true
            }
        }
        return false
    }

    // MARK: Scanner lifecycle
    
    private func foundCode(result: String) {
        done()
        delegate?.didScanCodeWithResult(result)
    }
    
    private func updateUI() {
        if let _ = previewLayer {
            previewLayer.frame = cameraView.layer.bounds
            
            if previewLayer.connection.supportsVideoOrientation {
                previewLayer.connection.videoOrientation = interfaceOrientationToVideoOrientation(UIApplication.sharedApplication().statusBarOrientation)
            }
        }
    }
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if let _ = captureSession {
            captureSession.stopRunning()
        }
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(readableObject.stringValue);
        }
    }
    
    // MARK: Error messages
    
    private func accessDenied() {
        let permissionAlert = UIAlertController(title: "Camera access denied!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        permissionAlert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action: UIAlertAction) -> Void in
            self.done()
        }))
        
        self.presentViewController(permissionAlert, animated: true, completion: nil)
    }
    
    private func scannerFailed() {
        let alert = UIAlertController(title: "Scanning failed!", message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action: UIAlertAction) -> Void in
            self.done()
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: ScanController dismissal
    
    func done() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Helper
    
    private func interfaceOrientationToVideoOrientation(orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        switch orientation {
        case .Portrait:
            return AVCaptureVideoOrientation.Portrait
        case .PortraitUpsideDown:
            return AVCaptureVideoOrientation.PortraitUpsideDown
        case .LandscapeLeft:
            return AVCaptureVideoOrientation.LandscapeLeft
        case .LandscapeRight:
            return AVCaptureVideoOrientation.LandscapeRight
        default:
            return AVCaptureVideoOrientation.Portrait
        }
    }
}
