//
//  SideMenu.swift
//  PicEditApp
//
//  Created by MacHD on 25/09/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit

class SideMenu: UITableViewController {

    var MenuList = ["Scan","Generate","History","Setting","Share","Like"]
    override func viewDidLoad() {
        super.viewDidLoad()

    }
  override func numberOfSections(in tableView: UITableView) -> Int {
    
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        tableView.tableFooterView = UIView()
       cell.textLabel?.text = MenuList[indexPath.row]
       cell.selectionStyle = .none
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{//SW
            let obj = storyboard?.instantiateViewController(withIdentifier: "SW") as!  SWRevealViewController
           present(obj, animated: true, completion: nil)
        }else if indexPath.row == 1{
           performSegue(withIdentifier: "Generator", sender: self)
        }else if indexPath.row == 2{
         performSegue(withIdentifier: "History", sender: self)
        }
    }


}
