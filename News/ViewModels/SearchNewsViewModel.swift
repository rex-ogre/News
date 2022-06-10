//
//  SearchNewsViewModel.swift
//  News
//
//  Created by 陳冠雄 on 2022/5/10.
//



import HTMLKit
import Foundation
import  Combine

import SwiftSoup
class SearchNewsViewModel{
    var NewsList: [news] = []

    
    func loadQuery(query: String,config:@escaping ()->Void){
        APICaller.shared.FetchNewsQuery(query: query, completion: {
            result in
   
            self.NewsList = result
            config()
        })
    }

    
}
