//
//  NewsWebScreen.swift
//  News
//
//  Created by 陳冠雄 on 2022/6/5.
//

import Foundation
import WebKit
import Social

class NewsWebScreen: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!

    
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

        
    let new: news
    required init(new: news){
        self.new = new
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let window = UIWindow(frame:
                            UIScreen.main.bounds)
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let myURL = URL(string: self.new.link)
        let myRequest = URLRequest(url: myURL!)
    
        webView.load(myRequest)
        navigationConfig()


    }
    
    
    
    
    private func navigationConfig(){
        let temp = CoreDataManager.shared.compareNews(container: CoreDataManager.container, guid: self.new.id)
        self.title  = "新聞"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", primaryAction: UIAction(handler: {
            act in
            self.dismiss(animated: true)}))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"))
       
        let menu = UIMenu(children: [
            UIAction(title: "分享",image: UIImage(systemName: "star") ,handler: { action in
                let activityViewController = UIActivityViewController(activityItems: [self.new.link], applicationActivities: nil)
                self.present(activityViewController, animated: true)
               
            }),
            temp == false ?
            UIAction(title: "稍後閱讀",image: UIImage(systemName: "arrow.down.doc") ,handler: { action in
                CoreDataManager.shared.createNews(container: CoreDataManager.container, title: self.new.title, url: self.new.link, image: self.new.image ?? "",guid: self.new.id)
                self.navigationConfig()
            }) :  UIAction(title: "取消儲存",image: UIImage(systemName: "arrowshape.turn.up.backward") ,handler: { action in
                CoreDataManager.shared.deleteNews(container: CoreDataManager.container, guid: self.new.id)
                self.navigationConfig()
            })  ,
        ])
        navigationItem.rightBarButtonItem?.menu = menu
    }
  
    
}
