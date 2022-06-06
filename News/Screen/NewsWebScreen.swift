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

        
    let url: String
    required init(url: String){
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let window = UIWindow(frame:
                            UIScreen.main.bounds)
    override func viewDidLoad() {
        super.viewDidLoad()
       
      
        let myURL = URL(string: self.url)
        let myRequest = URLRequest(url: myURL!)
    
        webView.load(myRequest)
        navigationConfig()


    }
    
    
    
    
    private func navigationConfig(){
        self.title  = "新聞"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", primaryAction: UIAction(handler: {
            act in
            self.dismiss(animated: true)}))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"))
       
        let menu = UIMenu(children: [
            UIAction(title: "分享",image: UIImage(systemName: "star") ,handler: { action in
                let activityViewController = UIActivityViewController(activityItems: [self.url], applicationActivities: nil)
                self.present(activityViewController, animated: true)
               
            }),
            UIAction(title: "稍後閱讀",image: UIImage(systemName: "arrow.down.doc") ,handler: { action in
                print("Edit Pins")
            }),
            
        
        ])
        navigationItem.rightBarButtonItem?.menu = menu
    }
  
    
}
