//
//  SettingViewController.swift
//  News
//
//  Created by 陳冠雄 on 2022/2/27.
//

import UIKit

import WebKit
class SettingViewController: UIViewController,WKUIDelegate {
    let NavigationBar:UINavigationBar = UINavigationBar()
    
    private let fullScreenSize = UIScreen.main.bounds.size
    private let ADView = UIView()
    private let NotificationsCell = SettingCell(frame: .null, title: "通知")
    private let DailyNotifyCell = SettingCell(frame: .null, title: "每日推薦")
    private let DarkMode =  SettingCell(frame: .null, title: "暗色模式")
    private let NotifyTiemPicker:SettingTimeCell = SettingTimeCell(frame: .null, title: "推薦時間")
    private let CleanCaheButton:UIButton = UIButton()
    
    var webView: WKWebView!
     
     override func loadView() {
         let webConfiguration = WKWebViewConfiguration()
         webView = WKWebView(frame: .zero, configuration: webConfiguration)
         webView.uiDelegate = self
         view = webView
         
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray
        ADViewConfig()
        NotificationsViewConfig()
        DarkModeCell()
        DailyNotify()
        NotifyTime()
        CleanCahe()
        // Do any additional setup after loading the view.
    }
 
    
    override func viewWillLayoutSubviews() {
    
        //MARK: NavigationBar Setting
        let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.fullScreenSize.width, height: 44))
        self.view.addSubview(navigationBar);
        navigationBar.backgroundColor = .systemGray
        navigationBar.isTranslucent = false
        let navigationItem = UINavigationItem(title: "設定")
        navigationBar.setItems([navigationItem], animated: false)
     }
    
    
    
    private func ADViewConfig(){
        ADView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(ADView)
        ADView.backgroundColor = .systemGreen
        ADView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        ADView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        ADView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        ADView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        
      
        
    }
    
    
    

    private func NotificationsViewConfig(){
        NotificationsCell.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(NotificationsCell)
        NotificationsCell.topAnchor.constraint(equalTo: self.ADView.bottomAnchor, constant: 30).isActive = true
        NotificationsCell.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
     
    }
    private func DarkModeCell(){
        self.view.addSubview(DarkMode)
        DarkMode.translatesAutoresizingMaskIntoConstraints = false
        DarkMode.topAnchor.constraint(equalTo: self.NotificationsCell.bottomAnchor, constant: 0).isActive = true
        DarkMode.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    private func DailyNotify(){
        self.view.addSubview(DailyNotifyCell)
        DailyNotifyCell.translatesAutoresizingMaskIntoConstraints = false
        DailyNotifyCell.topAnchor.constraint(equalTo: self.DarkMode.bottomAnchor, constant: 0).isActive = true
        DailyNotifyCell.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    private func NotifyTime(){
    
        NotifyTiemPicker.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(NotifyTiemPicker)
        
        NotifyTiemPicker.topAnchor.constraint(equalTo: DailyNotifyCell.bottomAnchor, constant: 0).isActive = true
        NotifyTiemPicker.centerXAnchor.constraint(equalTo: NotificationsCell.centerXAnchor).isActive = true
        
        
    }
    
    private func CleanCahe(){
        CleanCaheButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(CleanCaheButton)
        CleanCaheButton.topAnchor.constraint(equalTo: NotifyTiemPicker.bottomAnchor, constant: 40).isActive = true
        CleanCaheButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        CleanCaheButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        CleanCaheButton.layer.cornerRadius = 20
        CleanCaheButton.centerXAnchor.constraint(equalTo: NotifyTiemPicker.centerXAnchor).isActive = true
        CleanCaheButton.backgroundColor = .black
        CleanCaheButton.setTitle("清除快取", for: .normal)
        
    }
    
    
    
    
}

