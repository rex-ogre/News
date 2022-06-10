//
//  SavedViewmodel.swift
//  News
//
//  Created by 陳冠雄 on 2022/6/6.
//

import Foundation


class SavedViewmodel{
    var NewsList: [news] = []
    
    
    func loadData(config: @escaping () -> Void){
        self.NewsList = CoreDataManager.shared.readNews(container: CoreDataManager.container)
        config()
    }
    
}
