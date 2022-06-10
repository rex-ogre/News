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

    private let fullScreenSize = UIScreen.main.bounds.size
    private let ADView = UIView()
    var NotificationsCell: SettingCell?
    var bannerView: GADBannerView  = {
     let    bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
          bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        return bannerView
    }()


    var DarkMode: SettingCell?
    private var DailyNotifyCell : SettingCell?

    private let NotifyTiemPicker:SettingTimeCell = {
        let NotifyTiemPicker = SettingTimeCell(frame: .null, title: "推薦時間")
        return NotifyTiemPicker
    }()

    private let CleanCaheButton:UIButton = UIButton()
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
        ADViewConfig()
        NotificationsViewConfig()
        DarkModeCell()
        DailyNotify()
        NotifyTime()
        headerConfig()
        applyContraint()
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
    }



    private func ADViewConfig(){
        ADView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(ADView)




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
        self.view.addSubview(self.NotificationsCell!)


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

        self.view.addSubview(self.DarkMode!)
    }
    private func DailyNotify(){



        self.DailyNotifyCell = SettingCell(frame: .null,
                                           title: "每日提醒",
                                           on: {
            CoreDataManager.shared.Switch(container: CoreDataManager.container, settingIndex: 2, isOn: true)
            self.notificain()

        },
                                           off: {
            CoreDataManager.shared.Switch(container: CoreDataManager.container, settingIndex: 2, isOn: false)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()}
        )
        self.DailyNotifyCell!.Switch.isOn = CoreDataManager.shared.settingConfig[2]


        self.view.addSubview(self.DailyNotifyCell!)
        self.DailyNotifyCell!.translatesAutoresizingMaskIntoConstraints = false

    }
    private func NotifyTime(){

        NotifyTiemPicker.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(NotifyTiemPicker)




    }

    private func headerConfig(){
        self.view.addSubview(self.header)

    }

    private func applyContraint(){

        ADView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        ADView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        ADView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        ADView.widthAnchor.constraint(equalToConstant: 400).isActive = true



        NotificationsCell!.topAnchor.constraint(equalTo: self.ADView.bottomAnchor, constant: 30).isActive = true
        NotificationsCell!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true


        DarkMode!.topAnchor.constraint(equalTo: self.NotificationsCell!.bottomAnchor, constant: 0).isActive = true
        DarkMode!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        DailyNotifyCell!.topAnchor.constraint(equalTo: self.DarkMode!.bottomAnchor, constant: 0).isActive = true
        DailyNotifyCell!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        NotifyTiemPicker.topAnchor.constraint(equalTo: DailyNotifyCell!.bottomAnchor, constant: 0).isActive = true
        NotifyTiemPicker.centerXAnchor.constraint(equalTo: NotificationsCell!.centerXAnchor).isActive = true


        let headerConstraints = [
            self.header.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 50),
            self.header.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,constant: 0),
            self.header.heightAnchor.constraint(equalToConstant: 50)
        ]

        NSLayoutConstraint.activate(headerConstraints)
    }



    func notificain(){
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

    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: bottomLayoutGuide,
                            attribute: .top,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
     }
}

   

extension SettingViewController: GADBannerViewDelegate{
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
          UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
          })
        addBannerViewToView(bannerView)
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
