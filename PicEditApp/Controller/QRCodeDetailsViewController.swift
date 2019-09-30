//
//  QRCodeDetailsViewController.swift
//  PicEditApp
//
//  Created by MacHD on 26/09/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit
import CoreData

class QRCodeDetailsViewController: UIViewController {
    @IBOutlet weak var txtLabeleQrCodeType: UILabel!
    @IBOutlet weak var qrcodetxtTextView: UITextView!
    @IBOutlet weak var QRCodeImageView: UIImageView!
    @IBOutlet weak var IcomImageivew: UIImageView!
    
    @IBOutlet weak var copyBtn: UIButton!
    
    @IBOutlet weak var Menu: UIBarButtonItem!
    
    var QRCodeText = ""
    var ComingFromHome = false
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewDidLoadStufs()
       }
    
    @IBAction func Searchtext(_ sender: UIButton) {
    let url = URL(string: "https://www.google.com/#q=\(QRCodeText.stringByRemovingWhitespaces)")
        print("url is ",url)
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func openUrl(_ sender: Any) {
        if CDService.CDShared.canOpenURL(QRCodeText){
            let url = URL(string: QRCodeText)
            UIApplication.shared.openURL(url!)
        }
    }
    
    @IBAction func ShareThis(_ sender: Any) {
        
    }
    
    @IBAction func Copybtn(_ sender: Any) {
       UIPasteboard.general.string = qrcodetxtTextView.text!
        if UIPasteboard.general.string! != nil{
            print("cpoied data is ", UIPasteboard.general.string!)
         copyBtn.setTitle("Copied", for: UIControl.State.normal)
        }
    }
    
}

//for side menu revealviewcontroller
extension QRCodeDetailsViewController:SWRevealViewControllerDelegate{
    
    func ViewDidLoadStufs(){
        qrcodetxtTextView.text = QRCodeText
        if CDService.CDShared.canOpenURL(QRCodeText){
            IcomImageivew.image = UIImage(named: "link")
            txtLabeleQrCodeType.text = "Weblink"
        }else{
            IcomImageivew.image = UIImage(named: "Text")
             txtLabeleQrCodeType.text = "Text"
        }
        if QRCodeText.isEmpty != true && QRCodeText != nil{
            let data = QRCodeText.data(using: .ascii,allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey:"InputMessage")
            let ciImage = filter?.outputImage
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let transformImage = ciImage?.transformed(by: transform)
            let image = UIImage(ciImage: transformImage!)
            QRCodeImageView.image = image
            if  image != nil{
                if ComingFromHome == true{
                    CDService.CDShared.InsertData(tpye: "Text", Qrcodetext: qrcodetxtTextView.text!)
                }
                
            }
            
        }
        OpenSideMenu()
    }
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
extension String {
    var stringByRemovingWhitespaces: String {
        return components(separatedBy: .whitespaces).joined()
    }
}

//str.stringByRemovingWhitespaces  // Hearmecalling
//    func SaveDateIntoCoreData(){
//        //Accesing the coredata
//        let ManagerContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        //Accessing Entity(Tbale)
//        let entity = NSEntityDescription.entity(forEntityName: "History", in: ManagerContext)
//        //Going inot entity
//        let Hitory = NSManagedObject(entity: entity!, insertInto: ManagerContext)
//        let Qrcodetext =  qrcodetxtTextView.text!
//        let image = QRCodeImageView.image!
//       /// let Imagedata:Data = (image.pngData() as? Data)!
//        let date = Date()
//        let dateformator = DateFormatter()
//        dateformator.dateFormat = "dd, MMM, yyyy"
//        let currentdate = dateformator.string(from: date)
//        // insert data into Entity
////        History.setValue(Qrcodetext, forKey: "qrcodetext")
////        History.setValue(currentdate, forKey: "date")
////        History.setValue("Text", forKey: "type")
//        Hitory.setValue(Qrcodetext, forKey: "qrcodetext")
//        Hitory.setValue(currentdate, forKey: "date")
//        Hitory.setValue("Text", forKey: "type")
//       // History.setValue(Imagedata, forKey: "qrcodeimage")
//        // Save data into table
//        do {
//            try ManagerContext.save()
//            print("saved")
//        }catch{
//            print("something went wrong")
//        }
//    }
