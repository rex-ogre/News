//
//  SavedViewController.swift
//  News
//
//  Created by 陳冠雄 on 2022/2/27.
//

import UIKit
import CoreData
class SavedViewController: UIViewController, UIScrollViewDelegate {
    private let fullScreenSize = UIScreen.main.bounds.size
    let myScrollView : UIScrollView = UIScrollView()
    var container: NSPersistentContainer!
    
    private func createPersistentContainer() {
         func parseEntities(container: NSPersistentContainer) {
            let entities = container.managedObjectModel.entities
            print("Entity count = \(entities.count)\n")
            for entity in entities {
                print("Entity: \(entity.name!)")
                for property in entity.properties {
                    print("Property: \(property.name)")
                }
                print("")
            }
        }
        let container = NSPersistentContainer(name: "News")
        parseEntities(container: container)
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error: \(error)")
            }
            self.createBook(container: container, title: "123", url: "ds")
            self.readBooks(container: container)
        }
    }
    private func readBooks(container: NSPersistentContainer) {
        let context = container.viewContext
        let fetchBooks = NSFetchRequest<Newsmodel>(entityName: "Newsmodel")
        fetchBooks.predicate = NSPredicate(format: "title = \"123\"")
        do {
            let books = try context.fetch(fetchBooks)
            if !books.isEmpty {
                print("刪除成功")
                            context.delete(books[0])
                       if context.hasChanges {
                           try context.save()
                           print("Update success.")
                       }
                   }
        } catch {
            print("\(error)")
        }
    }

    private func createBook(container: NSPersistentContainer,
                            title: String, url: String) {
        let context = container.viewContext
        let newsmodel = NSEntityDescription.insertNewObject(forEntityName: "Newsmodel",
                                                        into: context) as! Newsmodel
        newsmodel.title = title
        newsmodel.url = url
        newsmodel.image = "hi".data(using: .ascii)!
        if context.hasChanges {
            do {
                try context.save()
                print("Insert news(\(title)) successful.")
            } catch {
                print("\(error)")
            }
        }
    }

    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
      
        createPersistentContainer()
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
