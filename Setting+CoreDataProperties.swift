//
//  Setting+CoreDataProperties.swift
//  News
//
//  Created by 陳冠雄 on 2022/6/9.
//
//

import Foundation
import CoreData


extension Setting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Setting> {
        return NSFetchRequest<Setting>(entityName: "Setting")
    }

    @NSManaged public var notificaion: Bool
    @NSManaged public var darkmode: Bool
    @NSManaged public var dailynotificaion: Bool
    @NSManaged public var rec_time: String?

}

extension Setting : Identifiable {

}
