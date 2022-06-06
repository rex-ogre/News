//
//  NewsViewModel.swift
//  News
//
//  Created by 陳冠雄 on 2022/3/30.
//
import HTMLKit
import Foundation
import  Combine

import SwiftSoup
class NewsViewModel {
    
    var NewsList: [news] = [news]()
    
    var storedNews:[String:[news]] = [:]
    

    
    func clearOldData(){
        NewsList.removeAll()
    }

    
    func loadTopData(completion: @escaping ()->Void){
            APICaller.shared.fetchNews{i in self.NewsList = i
                completion()
            }
                
    }
    
    func loadTopicData(topic: String,completion: @escaping ()->Void){
      
        APICaller.shared.FetchTopicNews(topic: topic, completion: {
            i in self.NewsList = i
                completion()})

    }
    

}






