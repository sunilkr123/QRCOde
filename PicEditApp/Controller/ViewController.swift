//
//  ViewController.swift
//  PicEditApp
//
//  Created by MacHD on 25/09/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    @IBAction func GotoQRCode(_ sender: UIBarButtonItem) {
        let obj = storyboard?.instantiateViewController(withIdentifier: "QRCodeViewController") as! QRCodeViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
   
    @IBAction func GenerateQRCode(_ sender: Any) {
        let obj = storyboard?.instantiateViewController(withIdentifier: "QRCodeGeneratorViewController") as!  QRCodeGeneratorViewController
     self.navigationController?.pushViewController(obj, animated: true)
    }
    
    
}

