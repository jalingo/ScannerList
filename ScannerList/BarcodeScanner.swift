//
//  BarcodeScanner.swift
//  ScannerList
//
//  Created by Jimmy Lingo on 4/2/17.
//  Copyright © 2017 Promethatech. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeScanner: UIViewController {

    // MARK: - Properties

    var captureSession: AVCaptureSession?
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var codeFrameView: UIView?
   
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode]
    
    // MARK: - Properties: IBOutlets
    
    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!
    
    // MARK: - Functions
    
    fileprivate func prepareAndLaunchScanner() {
        
        /*
         Get an instance of the AVCaptureDevice class to initialize a device object and
         provide the video as the media type parameter.
         */
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            /*
             Get an instance of the AVCaptureDeviceInput class using the previous device
             object.
             */
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            /*
             Initialize a AVCaptureMetadataOutput object and set it as the output device to
             the capture session.
             */
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            /*
             Initialize the video preview layer and add it as a sublayer to the viewPreview
             view's layer.
             */
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        launchScanner()
    }
    
    fileprivate func launchScanner() {
        
        // Start video capture.
//        captureSession?.startRunning()
        
        // Initialize Code Frame to highlight the QR code
        codeFrameView = UIView()
        
        if let codeFrameView = codeFrameView {
            codeFrameView.layer.borderColor = UIColor.green.cgColor
            codeFrameView.layer.borderWidth = 5
            view.addSubview(codeFrameView)
            view.bringSubview(toFront: codeFrameView)
        }
    }
    
    /**
     If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
     */
//    fileprivate func handleQRCode(from metadataObj: AVMetadataMachineReadableCodeObject) {
//        // MARK: - TODO: Need to derive prices here...
//    }
//    
//    fileprivate func handleEAN8Code(from metadataObj: AVMetadataMachineReadableCodeObject) {
//        // MARK: - TODO: Need to derive prices here...
//    }
//    
//    fileprivate func handleUPCECode(from metadataObj: AVMetadataMachineReadableCodeObject) {
//        // MARK: - TODO: Need to derive prices here...
//    }
//
//    fileprivate func handleEAN13andUPCACode(from metadataObj: AVMetadataMachineReadableCodeObject) {
//        // split EAN13 with UPCA (12) by checking for zero in first digit
//        metadataObj.stringValue.characters.first != "0" ?
//            handleEAN13Code(from: metadataObj) : handleUPCACode(from: metadataObj)
//    }
//    
//    fileprivate func handleEAN13Code(from metadataObj: AVMetadataMachineReadableCodeObject) {
//        // MARK: - TODO: Need to derive prices here...
//    }
//    
//    fileprivate func handleUPCACode(from metadataObj: AVMetadataMachineReadableCodeObject) {
//        // MARK: - TODO: Need to derive prices here...
//    }
    
    fileprivate func searchForPriceAndName(of code: String) {
        let trimmedCode = code.trimmingCharacters(in: .whitespaces)
        DataService.searchAPI(codeNumber: trimmedCode)
    }
    
    fileprivate func itemHasBeenFound(as name: String, costing price: String) {

        let alert = UIAlertController(title: "Search Results", message: "Name: \(name) for $\(price)!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Search", style: .destructive, handler: { [weak me = self] action in
            
            if name != "NOT FOUND" { me?.update(name: name) }
            if price != "NOT FOUND" { me?.update(price: (price as NSString).doubleValue) }
            
            me?.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func update(name newName: String) {
        
    }
    
    fileprivate func update(price newPrice: Double) {
        
    }
}

// MARK: - Extensions

// MARK: - Extension: UIViewController

extension BarcodeScanner {
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        prepareAndLaunchScanner()
        
        // Move the message label and top bar to the front
        view.bringSubview(toFront: messageLabel)
        view.bringSubview(toFront: topbar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            captureSession?.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession?.stopRunning()
        }
    }
}

// MARK: - Extension: AVCaptureMetadataOutputObjectsDelegate

extension BarcodeScanner: AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: - Functions
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        guard metadataObjects != nil && metadataObjects.count != 0 else {
            codeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR / Barcode is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            codeFrameView?.frame = barCodeObject!.bounds
            
            searchForPriceAndName(of: metadataObj.stringValue)

//            switch metadataObj.type {
//            case AVMetadataObjectTypeQRCode:    handleQRCode(from: metadataObj)
//            case AVMetadataObjectTypeEAN8Code:  handleEAN8Code(from: metadataObj)
//            case AVMetadataObjectTypeUPCECode:  handleUPCECode(from: metadataObj)
//            case AVMetadataObjectTypeEAN13Code: handleEAN13andUPCACode(from: metadataObj)
//            default: return
//            }
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
            }
        }
        
//        captureSession?.stopRunning()
    }
}
