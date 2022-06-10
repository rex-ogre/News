//
//  CoreData.swift
//  News
//
//  Created by 陳冠雄 on 2022/6/6.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    static let container = NSPersistentContainer(name: "News")
    
    var dailytime:String = ""
    var settingConfig:[Bool] = []
    
    //MARK: check Entity's Info
    func parseEntities(container: NSPersistentContainer) {
       let entities = container.managedObjectModel.entities
       print("Entity count = \(entities.count)\n")
       for entity in entities {
           print("Entity: \(entity.name!)")
           for property in entity.properties {
               print("Property: \(property.name)")
           }

       }


   }
     func createPersistentContainer() {
        
      
         parseEntities(container: CoreDataManager.container)
         
         CoreDataManager.container.loadPersistentStores { (description, error) in
             print("load success")
            if let error = error {
                fatalError("Error: \(error)")
            }
        }
         
         let context = CoreDataManager.container.viewContext
         let fetchSetting = NSFetchRequest<Setting>(entityName: "Setting")
         do {
             let setting = try context.fetch(fetchSetting)
         
             if !setting.isEmpty {
                
                 for i in setting {
                     print("找到已存在資料")
                     print(i.dailynotificaion)
                     settingConfig.append(i.notificaion)
                     settingConfig.append(i.darkmode)
                     settingConfig.append(i.dailynotificaion)
                     dailytime = i.rec_time!
                 }
             
                
                 
             } else{
                 
                 
                 let setting = NSEntityDescription.insertNewObject(forEntityName: "Setting",
                                                                 into: context) as! Setting
                 
                
                 settingConfig = [true,false,false]
                 
                 
                 dailytime = "00:00"
                 setting.notificaion = settingConfig[0]
                 setting.darkmode = settingConfig[1]
                 setting.dailynotificaion = settingConfig[2]
                 setting.rec_time = dailytime
                 
                 if context.hasChanges {
                     do {
                         try context.save()
                         
                         print("Insert setting successful.")
                    
                     } catch {
                         print("\(error)")
                     }
                 }
                 
             }
         } catch {
             print("\(error)")
         }
    }
    
    
    // search NEWS
    func readNews(container: NSPersistentContainer) -> [news] {
        let context = container.viewContext
        var newsList: [news] = []
        

        let fetchNews = NSFetchRequest<Newsmodel>(entityName: "Newsmodel")

        do {
            let newsModel = try context.fetch(fetchNews)
        
            if !newsModel.isEmpty {
               
                for i in newsModel {
                    let temp = news(title: i.title!, link: i.url!, id: i.guid!)
                    temp.image = i.image
                    newsList.append(temp)
                }
                
               
                
            }
        } catch {
            print("\(error)")
        }
        return newsList
    }

    
    //MARK: create News
     func createNews(container: NSPersistentContainer,
                     title: String, url: String,image: String,guid:String) {
        let context = container.viewContext
        let newsmodel = NSEntityDescription.insertNewObject(forEntityName: "Newsmodel",
                                                        into: context) as! Newsmodel
        newsmodel.title = title
        newsmodel.url = url
        newsmodel.guid = guid
        newsmodel.image = image
        if context.hasChanges {
            do {
                try context.save()
                
                print("Insert news(\(title)) successful.")
                print(url)
                print(guid)
                print(image)
                
            } catch {
                print("\(error)")
            }
        }
    }



    //MARK: Delete News
    func deleteNews(container: NSPersistentContainer,guid: String){
        let context = container.viewContext
        let fetchNews = NSFetchRequest<Newsmodel>(entityName: "Newsmodel")
        fetchNews.predicate = NSPredicate(format: "guid = '\(guid)'")
        
        do {
            let news = try context.fetch(fetchNews)
            
            for new in news {
                print("delete")
                context.delete(new)
            }
            if context.hasChanges {
                try context.save()
            }
            
        } catch {
            print("\(error)")
        }

      
    }
    // compare NEWS
    func compareNews(container: NSPersistentContainer,guid:String) -> Bool {
        let context = container.viewContext
        
      
        let fetchNews = NSFetchRequest<Newsmodel>(entityName: "Newsmodel")
        fetchNews.predicate = NSPredicate(format: "guid = '\(guid)'")
        
        do {
            let newsModel = try context.fetch(fetchNews)
                
            if !newsModel.isEmpty {
               
                return true
    
            
                
            } else{
                return false
            }
        } catch {
            print("\(error)")
            return false
            
        }
       
    }
    func Switch(container: NSPersistentContainer,settingIndex: Int,isOn:Bool){
        let context = CoreDataManager.container.viewContext
        let fetchSetting = NSFetchRequest<Setting>(entityName: "Setting")
        do {
            let setting = try context.fetch(fetchSetting)
            if !setting.isEmpty {
                switch settingIndex{
                case 0:
                    setting[0].notificaion = isOn
                    print(setting[0])
                    settingConfig[settingIndex] = isOn
                case 1:
                    setting[0].darkmode = isOn
                    settingConfig[settingIndex] = isOn
                case 2:
                    setting[0].dailynotificaion = isOn
                    settingConfig[settingIndex] = isOn
                default:
                    return
                }
                if context.hasChanges {
                    try context.save()
                    print(setting[0].notificaion)
                    print("Update success.")
                }
            }
        } catch {
            print("\(error)")
        }
    }
    func changeTime(container: NSPersistentContainer,dateTime: String){
        let context = CoreDataManager.container.viewContext
        let fetchSetting = NSFetchRequest<Setting>(entityName: "Setting")
        do {
            let setting = try context.fetch(fetchSetting)
            if !setting.isEmpty {
                setting[0].rec_time = dateTime
                if context.hasChanges {
                    try context.save()
                    print(setting[0].notificaion)
                    print("Update success.")
                }
            }
        } catch {
            print("\(error)")
        }
    }
}
