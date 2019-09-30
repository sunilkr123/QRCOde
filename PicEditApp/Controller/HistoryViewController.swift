//
//  HistoryViewController.swift
//  PicEditApp
//
//  Created by MacHD on 26/09/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit
import CoreData
class HistoryViewController: UITableViewController {
    
  @IBOutlet weak var Menu: UIBarButtonItem!
    var arrHistory = [NSManagedObject]()
    let ManagerContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
         OpenSideMenu()
        self.arrHistory = CDService.CDShared.Fetchdata()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
     
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHistory.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.selectionStyle = .none
        cell.SetData(obj: arrHistory[indexPath.row])
       tableView.tableFooterView = UIView()
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = storyboard?.instantiateViewController(withIdentifier: "QRCodeDetailsViewController") as!    QRCodeDetailsViewController
        let qrtext = (arrHistory[indexPath.row].value(forKey: "qrcodetext")) as! String
        obj.QRCodeText = qrtext
        self.navigationController?.pushViewController(obj, animated: true)
    }
     //this method handles row deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            CDService.CDShared.DeleteObjectFromCoreData(Managedobj:arrHistory[indexPath.row])
            arrHistory.remove(at: indexPath.row)
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
//    func FetchDataFromCoreData(){
//       
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
//        do{
//           self.arrHistory = try ManagerContext.fetch(request) as! [NSManagedObject]
//            print("  self.arrHistory \(  self.arrHistory.count)")
//            self.tableView.reloadData()
//          }catch{
//            print("something wen twrong \(error)")
//        }
//    }
    
}

//for side menu revealviewcontroller
extension HistoryViewController:SWRevealViewControllerDelegate{
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
