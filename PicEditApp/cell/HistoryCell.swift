//
//  HistoryCell.swift
//  PicEditApp
//
//  Created by MacHD on 26/09/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit
import CoreData
class HistoryCell: UITableViewCell {
    @IBOutlet weak var txttypelabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var QRCodetextlabel: UILabel!
   @IBOutlet weak var IcomImageivew: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func SetData(obj:NSManagedObject){
        txttypelabel.text = obj.value(forKey: "type") as! String
        datelabel.text = obj.value(forKey: "date") as! String
        QRCodetextlabel.text = obj.value(forKey: "qrcodetext") as! String
        if CDService.CDShared.canOpenURL( QRCodetextlabel.text!){
          IcomImageivew.image = UIImage(named: "link")
            txttypelabel.text = "Weblink"
        }else{
          IcomImageivew.image = UIImage(named: "Text")
             txttypelabel.text = "Text"
        }
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
