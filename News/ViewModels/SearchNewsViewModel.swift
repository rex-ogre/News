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
    var NewsList: [Int:news] = [:]
    var newsImage: [Int:UIImage] = [:]
    var NewsTitle: [Int:String] = [:]
    
    
    func loadQuery(query: String,config:@escaping ()->Void){
        APICaller.shared.FetchNewsQuery(query: query, completion: {
            result in
            switch result{
            case .success(let temp):
                return
                
//                if temp.count>25{
//
//
//                // 先load 封面的資料 在load之後的
//                let d2 = DispatchQueue(label: "d2",qos: DispatchQoS.userInteractive)
//
//
//
//                for index in 0...8{
//                    self.NewsList[index] = news(Url: temp[index])
//
//                }
//
//                d2.asyncAfter(deadline: .now()+1){
//                    // after first batch parsed , parse second batch
//                    for index in 8...25{
//                        self.NewsList[index] = news(Url: temp[index])
//                        self.parseUrl(news: temp[index], index: index)
//                    }
//
//                    config()
//                    }
//
//                } else{
//                    print("結果太少")
//                }
//
                
            case .failure(let error):
                print(error)
            }
            
        })
    }
    func parseUrl(news: String,index: Int){
//        DispatchQueue.main.async {
//            LPMetadataProvider().startFetchingMetadata(for: URL( string:news)!)  {
//                (linkMetadata, error) in
//                guard let linkMetadata = linkMetadata,
//                      let imageProvider = linkMetadata.imageProvider else { return }
//                
//                imageProvider.loadObject(ofClass: UIImage.self) {
//                    [self] (image, error) in
//                    guard error == nil else {
//                        // handle error
//                        return
//                    }
//                    if let image = image as? UIImage {
//                        // do something with image
//                        self.newsImage[index] = image
//                        self.NewsTitle[index] = linkMetadata.title!
//                        
//                        
//                        
//                    } else {
//                        print("no image available")
//                    }
//                }
//                
//            }
//        }
    }
    
    
}
