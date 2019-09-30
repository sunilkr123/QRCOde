//
//  ScanHomeViewController.swift
//  PicEditApp
//
//  Created by MacHD on 25/09/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit
import AVFoundation

class ScanHomeViewController: UIViewController{

    @IBOutlet weak var SideMenu: UIBarButtonItem!
    @IBOutlet weak var Square: UIImageView!
    
    @IBOutlet weak var scanbtn: UIButton!
    @IBOutlet weak var generatebtn: UIButton!
    var Video = AVCaptureVideoPreviewLayer()
    var session = AVCaptureSession()
    override func viewDidLoad() {
        super.viewDidLoad()
        //scanbtn.layer.cornerRadius = 5
       //  generatebtn.layer.cornerRadius = 5
         OpenSideMenu()
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
         StartScanning()
    }

    @IBAction func ScanQRCode(_ sender: UIButton) {
        let obj = storyboard?.instantiateViewController(withIdentifier: "QRCodeViewController") as! QRCodeViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func GenerateQRCode(_ sender: Any) {
        let obj = storyboard?.instantiateViewController(withIdentifier: "QRCodeGeneratorViewController") as!  QRCodeGeneratorViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
}

///to scan the QR Code
extension ScanHomeViewController:AVCaptureMetadataOutputObjectsDelegate{
 
    func StartScanning(){
        //Define capture device
        let CaptureDevice =  AVCaptureDevice.default(for:AVMediaType.video)
        do{
            let input = try AVCaptureDeviceInput(device:CaptureDevice!)
            session.addInput(input)
        }catch{
            print("Some Error occured")
        }
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        Video = AVCaptureVideoPreviewLayer(session: session)
        Video.frame = view.layer.bounds
        view.layer.addSublayer(Video)
        Square.layer.borderWidth = 2
        Square.layer.borderColor = UIColor.blue.cgColor
        self.view.bringSubviewToFront(Square)
        session.startRunning()
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0{
            if let objects = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if objects.type == AVMetadataObject.ObjectType.qr{
                    let obj = storyboard?.instantiateViewController(withIdentifier: "QRCodeDetailsViewController") as!    QRCodeDetailsViewController
                    obj.QRCodeText = objects.stringValue!
                    obj.ComingFromHome = true
                    self.navigationController?.pushViewController(obj, animated: true)
                    let alert = UIAlertController(title: "QR Code", message: objects.stringValue, preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "Retake", style: UIAlertAction.Style.default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
                        UIPasteboard.general.string = objects.stringValue
                    }))
                   // present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
         session.stopRunning()
    }
    
}





//for side menu revealviewcontroller
extension ScanHomeViewController:SWRevealViewControllerDelegate{
   func OpenSideMenu()  {
        //Actions for the SideMenu.
        SideMenu.target = revealViewController()
        SideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        //set the delegate to teh SWRevealviewcontroller
        revealViewController().delegate = self
        self.revealViewController().rearViewRevealWidth = 150
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    //for dissable homescreen
    public func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
         let tagId = 112151
        if revealController.frontViewPosition == FrontViewPosition.right {
            let lock = self.view.viewWithTag(tagId)
            UIView.animate(withDuration: 0.25, animations: {
               lock?.alpha = 0
            }, completion: {(finished: Bool) in
                lock?.removeFromSuperview()
            })
            lock?.removeFromSuperview()
        } else if revealController.frontViewPosition == FrontViewPosition.left {
            let lock = UIView(frame: self.view.bounds)
            lock.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            lock.tag = tagId
            lock.alpha = 0
            lock.backgroundColor = UIColor.black
            lock.addGestureRecognizer(UITapGestureRecognizer(target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
             self.view.addSubview(lock)
             UIView.animate(withDuration: 0.75, animations: {
            lock.alpha = 0.333})
        }}
}
