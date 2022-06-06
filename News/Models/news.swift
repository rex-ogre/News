//
//  News.swift
//  News
//
//  Created by 陳冠雄 on 2022/3/30.
//

import Foundation
import UIKit


class news {
    let title: String
    let link: String
    let id: String
    var image: String?
    
    init(title: String, link: String, id: String) {
        self.title = title
        self.link = link
        self.id = id
    }

}
