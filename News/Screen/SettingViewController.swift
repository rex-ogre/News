//
//  SettingViewController.swift
//  News
//
//  Created by 陳冠雄 on 2022/2/27.
//

import UIKit
import UserNotifications
import GoogleMobileAds

class SettingViewController: UIViewController {
    let NavigationBar:UINavigationBar = UINavigationBar()

    private var fullScreenSize = UIScreen.main.bounds.size
   
    var NotificationsCell: SettingCell?
    
    var bannerView: GADBannerView  = {
     let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
          bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        return bannerView
    }()
    let ScrollView : UIScrollView = {
        let ScrollView = UIScrollView()
        ScrollView.isUserInteractionEnabled = true
        ScrollView.isScrollEnabled = true
        ScrollView.bounces = true
        ScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return ScrollView
    }()

    
    var DarkMode: SettingCell?
    private var DailyNotifyCell : SettingCell?

    private let NotifyTiemPicker:SettingTimeCell = {
        let NotifyTiemPicker = SettingTimeCell(frame: .null, title: "推薦時間")
        return NotifyTiemPicker
    }()

    let header: UILabel = {
        let header = UILabel()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.text = "設定"
        header.font = UIFont(name: "Thonburi-Bold", size: 24)
        return header
    }()
   

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
       
        NotificationsViewConfig()
        DarkModeCell()
        DailyNotify()
        NotifyTime()
        headerConfig()
        self.view.addSubview(ScrollView)
        ScrollView.addSubview(NotificationsCell!)
        ScrollView.addSubview(DarkMode!)
        ScrollView.addSubview(DailyNotifyCell!)
        ScrollView.addSubview(NotifyTiemPicker)
       
//        ScrollView.backgroundColor = .blue
        
        applyContraint()
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        ScrollView.delegate = self
//        addBannerViewToView(bannerView)
        
       
        
    }






    private func NotificationsViewConfig(){

        self.NotificationsCell = SettingCell(frame: .null,
                                                 title: "通知",
                                                 on: {

                CoreDataManager.shared.Switch(container: CoreDataManager.container, settingIndex: 0, isOn: true)

            },
                                                 off: {
                CoreDataManager.shared.Switch(container: CoreDataManager.container, settingIndex: 0, isOn: false)

            })
        self.NotificationsCell!.Switch.isOn = CoreDataManager.shared.settingConfig[0]

        self.NotificationsCell!.translatesAutoresizingMaskIntoConstraints = false



    }
    private func DarkModeCell(){



        self.DarkMode = SettingCell(frame: .null,
                                    title: "暗色模式",
                                    on: {
            CoreDataManager.shared.Switch(container: CoreDataManager.container, settingIndex: 1, isOn: true)
            self.view.overrideUserInterfaceStyle = .dark
            self.view.window?.overrideUserInterfaceStyle = .dark},
                                    off: {
            CoreDataManager.shared.Switch(container: CoreDataManager.container, settingIndex: 1, isOn: false)
            self.view.overrideUserInterfaceStyle = .light
            self.view.window?.overrideUserInterfaceStyle  = .light}
        )
        self.DarkMode!.Switch.isOn = CoreDataManager.shared.settingConfig[1]
        self.DarkMode!.translatesAutoresizingMaskIntoConstraints = false

//        self.view.addSubview(self.DarkMode!)
        
    }
    private func DailyNotify(){

        self.DailyNotifyCell = SettingCell(frame: .null,
                                           title: "每日提醒",
                                           on: {
            CoreDataManager.shared.Switch(container: CoreDataManager.container, settingIndex: 2, isOn: true)
            self.notifications()

        },
                                           off: {
            CoreDataManager.shared.Switch(container: CoreDataManager.container, settingIndex: 2, isOn: false)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()}
        )
        self.DailyNotifyCell!.Switch.isOn = CoreDataManager.shared.settingConfig[2]


//        self.view.addSubview(self.DailyNotifyCell!)
        self.DailyNotifyCell!.translatesAutoresizingMaskIntoConstraints = false

    }
    private func NotifyTime(){

        NotifyTiemPicker.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(NotifyTiemPicker)




    }

    private func headerConfig(){
        self.view.addSubview(self.header)

    }

    private func applyContraint(){
        
        
        let NotificationsCellConstraints =  [
            self.NotificationsCell!.topAnchor.constraint(equalTo: self.ScrollView.topAnchor, constant: 200),
            self.NotificationsCell!.centerXAnchor.constraint(equalTo: self.ScrollView.centerXAnchor),
            self.NotificationsCell!.leadingAnchor.constraint(equalTo: self.ScrollView.leadingAnchor, constant: 20),
            self.NotificationsCell!.trailingAnchor.constraint(equalTo: self.ScrollView.trailingAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(NotificationsCellConstraints)
        let DarkModeConstraints = [
            self.DarkMode!.topAnchor.constraint(equalTo: self.NotificationsCell!.bottomAnchor, constant: 0),
            self.DarkMode!.centerXAnchor.constraint(equalTo: self.ScrollView.centerXAnchor),
            self.DarkMode!.leadingAnchor.constraint(equalTo: self.ScrollView.leadingAnchor, constant: 20),
            self.DarkMode!.trailingAnchor.constraint(equalTo: self.ScrollView.trailingAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(DarkModeConstraints)
        let DailyNotifyCellConstraints = [
            self.DailyNotifyCell!.topAnchor.constraint(equalTo: self.DarkMode!.bottomAnchor, constant: 0),
            self.DailyNotifyCell!.centerXAnchor.constraint(equalTo: self.ScrollView.centerXAnchor),
            self.DailyNotifyCell!.leadingAnchor.constraint(equalTo: self.ScrollView.leadingAnchor, constant: 20),
            self.DailyNotifyCell!.trailingAnchor.constraint(equalTo: self.ScrollView.trailingAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(DailyNotifyCellConstraints)
        

        let NotifyTiemPickerConstraints = [
            self.NotifyTiemPicker.topAnchor.constraint(equalTo: self.DailyNotifyCell!.bottomAnchor, constant: 0),
            self.NotifyTiemPicker.centerXAnchor.constraint(equalTo: self.ScrollView.centerXAnchor),
            self.NotifyTiemPicker.leadingAnchor.constraint(equalTo: self.ScrollView.leadingAnchor, constant: 20),
            self.NotifyTiemPicker.trailingAnchor.constraint(equalTo: self.ScrollView.trailingAnchor, constant: -20),
            self.NotifyTiemPicker.bottomAnchor.constraint(equalTo: self.ScrollView.bottomAnchor, constant: -150),
        ]

        NSLayoutConstraint.activate(NotifyTiemPickerConstraints)


        
        let headerConstraints = [
            self.header.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 50),
            self.header.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,constant: 0),
            self.header.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(headerConstraints)
        
        
        
        ScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: 0).isActive = true
        ScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 0).isActive = true
        ScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        ScrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
       
    }



    func notifications(){
        if (self.NotificationsCell!.Switch.isOn){
            let content = UNMutableNotificationContent()
            content.title = "新聞推送"

            content.body = "快點查看最新新聞"


            content.sound = UNNotificationSound.default
            var date = DateComponents()

            date.hour = Int(self.NotifyTiemPicker.time.prefix(2))
            date.minute =  Int(self.NotifyTiemPicker.time.suffix(2))
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

            let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                print(date)
                print("成功建立通知...")

            })}

    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            fullScreenSize = size
            ScrollView.contentSize = CGSize(width: size.width, height: size.height*3)
        } else {
            fullScreenSize = size
            ScrollView.contentSize  = CGSize(width: size.width, height: size.height*1.1)

        }

    }

//    func addBannerViewToView(_ bannerView: GADBannerView) {
//      bannerView.translatesAutoresizingMaskIntoConstraints = false
//      view.addSubview(bannerView)
//      view.addConstraints(
//        [NSLayoutConstraint(item: bannerView,
//                            attribute: .bottom,
//                            relatedBy: .equal,
//                            toItem: bottomLayoutGuide,
//                            attribute: .top,
//                            multiplier: 1,
//                            constant: 0),
//         NSLayoutConstraint(item: bannerView,
//                            attribute: .centerX,
//                            relatedBy: .equal,
//                            toItem: view,
//                            attribute: .centerX,
//                            multiplier: 1,
//                            constant: 0)
//        ])
//     }
}

   

extension SettingViewController: GADBannerViewDelegate{
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
          UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
          })
//        addBannerViewToView(bannerView)
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
}
extension SettingViewController:UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
     
    }
    
    
}
