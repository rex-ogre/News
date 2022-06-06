//
//  Newsmodel+CoreDataProperties.swift
//  News
//
//  Created by 陳冠雄 on 2022/6/3.
//
//

import Foundation
import CoreData


extension Newsmodel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Newsmodel> {
        return NSFetchRequest<Newsmodel>(entityName: "Newsmodel")
    }

    @NSManaged public var image: Data?
    @NSManaged public var title: String?
    @NSManaged public var url: String?

}

extension Newsmodel : Identifiable {

}
