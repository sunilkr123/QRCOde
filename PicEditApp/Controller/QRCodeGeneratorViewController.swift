//
//  QRCodeGeneratorViewController.swift
//  PicEditApp
//
//  Created by MacHD on 25/09/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit

class QRCodeGeneratorViewController: UIViewController {
    @IBOutlet weak var QRtextField: UITextField!
    @IBOutlet weak var QRImage: UIImageView!
    @IBOutlet weak var SaveImage: UIButton!
    @IBOutlet weak var Menu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SaveImage.isHidden = true
        OpenSideMenu()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func GenerateQRcode(_ sender: Any) {
        if QRtextField.text!.isEmpty != true && QRtextField.text! != nil{
        if let MyString = QRtextField.text{
            let data = MyString.data(using: .ascii,allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey:"InputMessage")
            let ciImage = filter?.outputImage
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let transformImage = ciImage?.transformed(by: transform)
            let image = UIImage(ciImage: transformImage!)
            QRImage.image = image
             SaveImage.isHidden = false
        }
        }else{
            let alert = UIAlertController(title: "Warning!", message: "Text Field is balnk", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
           present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func SaveImageIntoGallery(_ sender: Any) {
        let layer = QRImage.layer
        let scale = QRImage.contentScaleFactor
        UIGraphicsBeginImageContextWithOptions((layer.frame.size), false, scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(screenShot!, nil, nil, nil)
        
    }
    
}

//for side menu revealviewcontroller
extension QRCodeGeneratorViewController:SWRevealViewControllerDelegate{
    func OpenSideMenu()  {
        //Actions for the SideMenu.
        Menu.target = revealViewController()
        Menu.action = #selector(SWRevealViewController.revealToggle(_:))
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
