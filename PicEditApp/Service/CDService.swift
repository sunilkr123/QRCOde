//
//  CDService.swift
//  PicEditApp
//
//  Created by MacHD on 26/09/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation
import CoreData
class CDService: NSObject {
  private override init(){}
  static let CDShared = CDService()
  let ManagedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func InsertData(tpye:String,Qrcodetext:String){
        let date = Date()
        let dateformator = DateFormatter()
        dateformator.dateFormat = "dd, MMM, yyyy"
        let currentdate = dateformator.string(from: date)
        let Entity = NSEntityDescription.entity(forEntityName: "History", in: ManagedContext)
        let history = NSManagedObject(entity:Entity!, insertInto: ManagedContext)
        history.setValue(Qrcodetext, forKey: "qrcodetext")
        history.setValue(currentdate, forKey: "date")
        history.setValue(tpye, forKey: "type")
        do {
            try ManagedContext.save()
            print("saved")
        }catch{
            print("something went wrong")
        }
    }
    
    func Fetchdata() -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        var array = [NSManagedObject]()
        do{
            try array = ManagedContext.fetch(request) as! [NSManagedObject]
        }catch{
            print("some error occured\(error)")
        }
        return array
    }
    
    func DeleteObjectFromCoreData(Managedobj:NSManagedObject){
        ManagedContext.delete(Managedobj)
        do {
            try ManagedContext.save()
            print("saved")
        }catch{
            print("something went wrong")
        }
    }
    
    func canOpenURL(_ string: String?) -> Bool {
        guard let urlString = string,
            let url = URL(string: urlString)
            else { return false }
        if !UIApplication.shared.canOpenURL(url) { return false }
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
}
