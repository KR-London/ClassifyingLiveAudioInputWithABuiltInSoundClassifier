//
//  ViewController.swift
//  Sarcastic-Pet
//
//  Created by Kanishka on 13/06/21.
//

import UIKit
import AVFoundation
import ViewAnimator

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var captureSession = AVCaptureSession()
    let output = AVCaptureVideoDataOutput()
    let composition = AVMutableComposition()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    //add the subtitles variable here
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
       askForPermissions()
        
        let spinnyView = UIView()
        
        spinnyView.layer.addSublayer(previewLayer)
        
        
        view.addSubview(spinnyView)
        
        spinnyView.translatesAutoresizingMaskIntoConstraints = false
        
        spinnyView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        spinnyView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        spinnyView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        spinnyView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let zoomAnimation = AnimationType.zoom(scale: 0.2)
        let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
        UIView.animate(views: [spinnyView],
                       animations: [zoomAnimation, rotateAnimation],
                       duration: 0.5)
  }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = .clear
        previewLayer.frame = view.bounds
    }
    
    
    func askForPermissions(){
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .denied: updateCameraPermissions()
        case .authorized: prepareCamera()
        case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (granted) in
                    guard granted else {return}
                }
                self.prepareCamera()
                print("not determined")
        case .restricted:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                guard granted else {return}
            }
            self.prepareCamera()
        default: print("show the controller")
        }
    }
    
    func updateCameraPermissions(){
        let alertController = UIAlertController(title: "Error", message: "Camera is denied", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                                  
        alertController.addAction(UIAlertAction(title:"Settings", style: .cancel){ _ in
                if let url = URL(string: UIApplication.openSettingsURLString){
            UIApplication.shared.open(url, options: [:], completionHandler: {_ in })
                                    }
                                  })
    }
    
    func prepareCamera(){
    let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video){
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input){session.addInput(input)}
                if session.canAddOutput(output){ session.addOutput(output)}
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.captureSession = session
            }
            catch {
                
            }
        }
    }
    
//    func showCamera(){
//        let picker = UIImagePickerController()
//              picker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
//        picker.sourceType = .camera
//              present(picker, animated: true, completion: nil)
//    }
// 
      
    
    
}

