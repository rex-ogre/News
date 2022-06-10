//
//  Newsmodel+CoreDataProperties.swift
//  News
//
//  Created by 陳冠雄 on 2022/6/9.
//
//

import Foundation
import CoreData


extension Newsmodel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Newsmodel> {
        return NSFetchRequest<Newsmodel>(entityName: "Newsmodel")
    }

    @NSManaged public var image: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var guid: String?

}

extension Newsmodel : Identifiable {

}
