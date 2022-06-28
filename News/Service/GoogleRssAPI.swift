//
//  GoogleRssAPI.swift
//  News
//
//  Created by 陳冠雄 on 2022/4/10.
//

import Foundation
import HTMLKit
import Combine
import SwiftSoup
import SwiftUI
enum APIError: Error {
    case failedTogetData
}

class APICaller{
    static let shared = APICaller()
    
    func fetchNews(completion: @escaping (_ news: [news])-> Void)  {
        let url = URL(string: "https://news.google.com/news/rss/headlines/section/topic/WORLD?hl=zh-TW&gl=TW&ceid=TW:zh-Hant")!
        var newsList: [news] = []
 
        let task = URLSession.shared.dataTask(with: url) {
            data,res,_ in
            print("請求資料成功")
            guard let xmlString = String(data: data!, encoding: .utf8),
                  let document = try? SwiftSoup.parse(xmlString, "", Parser.xmlParser()) else { return }
        
            document.children().forEach { rss in
                rss.children().forEach { channel in
                    for item in channel.children() where item.nodeName() == "item" {
                        let title = (try? item.children().first(where: { $0.nodeName() == "title" })?.text()) ?? ""
                        let link = (try? item.children().first(where: { $0.nodeName() == "link" })?.text()) ?? ""
                        let id = (try? item.children().first(where: { $0.nodeName() == "guid" })?.text()) ?? ""
                        newsList.append(news(title: title, link: link, id: id))
                    }
                }
            }
            let taskGroup = DispatchGroup()
            for new in newsList {
                taskGroup.enter()
                    let url = URL(string: new.link)!
                    let task = URLSession.shared.dataTask(with: url) {
                    data,res,_ in
                    guard let htmlString = String(data: data!, encoding: .utf8),
                          let document = try? SwiftSoup.parse(htmlString) else {
                        return
                    }
                    let elements = try! document.getElementsByTag("meta")
                    for element in elements {
                        if let property = try? element.attr("property"),
                           property == "og:image",
                           let imageLink = try? element.attr("content") {
                            new.image = imageLink
                        }
                    }
                        
                        
                        taskGroup.leave()
                    }
                
                task.resume()
                
              
            }
            taskGroup.notify(queue: .main){
                
                completion(newsList)
            }
        }
        task.resume()
       

    }
    
    func FetchTopicNews(topic: String,completion: @escaping (_ news: [news])-> Void){
        let url = URL(string: "https://news.google.com/news/rss/headlines/section/topic/\(topic)?hl=zh-TW&gl=TW&ceid=TW:zh-Hant")!
        var newsList: [news] = []
 
        let task = URLSession.shared.dataTask(with: url) {
            data,res,_ in
    
            guard let xmlString = String(data: data!, encoding: .utf8),
                  let document = try? SwiftSoup.parse(xmlString, "", Parser.xmlParser()) else { return }
        
            document.children().forEach { rss in
                rss.children().forEach { channel in
                    for item in channel.children() where item.nodeName() == "item" {
                        let title = (try? item.children().first(where: { $0.nodeName() == "title" })?.text()) ?? ""
                        let link = (try? item.children().first(where: { $0.nodeName() == "link" })?.text()) ?? ""
                        let id = (try? item.children().first(where: { $0.nodeName() == "guid" })?.text()) ?? ""
                        newsList.append(news(title: title, link: link, id: id))
                    }
                }
            }
            let taskGroup = DispatchGroup()
       
            //MARK: 避免load太多資料
            for new in (newsList.count>30) ? newsList[0...30] : newsList[0...newsList.count-1] {
                taskGroup.enter()
                    let url = URL(string: new.link)!
                    let task = URLSession.shared.dataTask(with: url) {
                    data,res,_ in
                       
                        guard let htmlString = String(data: data  ?? Data(), encoding: .utf8),
                        
                          let document = try? SwiftSoup.parse(htmlString) else {
                        return
                    }
                    let elements = try! document.getElementsByTag("meta")
                    for element in elements {
                        if let property = try? element.attr("property"),
                           property == "og:image",
                           let imageLink = try? element.attr("content") {
                            new.image = imageLink
                        }
                    }
                        taskGroup.leave()
                    }
                task.resume()
                
              
            }
            taskGroup.notify(queue: .main){
                
                completion(newsList)
            }
        }
        task.resume()
    }
    
    
    
    func FetchNewsQuery(query: String,completion: @escaping (_ news: [news])-> Void){
        
 
        let url =  URL(string:  "https://news.google.com/rss/search?q=\(query)&hl=zh-TW&gl=TW&ceid=TW:zh-Hant")!
        var newsList: [news] = []
 
        let task = URLSession.shared.dataTask(with: url) {
            data,res,_ in
    
            guard let xmlString = String(data: data!, encoding: .utf8),
                  let document = try? SwiftSoup.parse(xmlString, "", Parser.xmlParser()) else { return }
        
            document.children().forEach { rss in
                rss.children().forEach { channel in
                    for item in channel.children() where item.nodeName() == "item" {
                        let title = (try? item.children().first(where: { $0.nodeName() == "title" })?.text()) ?? ""
                        let link = (try? item.children().first(where: { $0.nodeName() == "link" })?.text()) ?? ""
                        let id = (try? item.children().first(where: { $0.nodeName() == "guid" })?.text()) ?? ""
                        newsList.append(news(title: title, link: link, id: id))
                    }
                }
            }
            let taskGroup = DispatchGroup()
       
            //MARK: 若沒資料提前結束
            guard newsList.count > 0 else {
                taskGroup.notify(queue: .main){
                    
                    completion(newsList)
                }
                return
            }
            for new in (newsList.count>30) ? newsList[0...30] : newsList[0...newsList.count-1] {
                taskGroup.enter()
                    let url = URL(string: new.link)!
                    let task = URLSession.shared.dataTask(with: url) {
                    data,res,_ in
                    guard let htmlString = String(data: data!, encoding: .utf8),
                          let document = try? SwiftSoup.parse(htmlString) else {
                        return
                    }
                    let elements = try! document.getElementsByTag("meta")
                    for element in elements {
                        if let property = try? element.attr("property"),
                           property == "og:image",
                           let imageLink = try? element.attr("content") {
                            new.image = imageLink
                        }
                    }
                        taskGroup.leave()
                    }
                task.resume()
                
              
            }
            taskGroup.notify(queue: .main){
                
                completion(newsList)
            }
        }
        task.resume()
    }
    
}
