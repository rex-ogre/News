//
//  SettingTimeCell.swift
//  News
//
//  Created by 陳冠雄 on 2022/3/25.
//

import UIKit

class SettingTimeCell: UIView {
    
    let Label: UILabel = {
        
        let Label = UILabel()
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    let DateTimePicker: UIDatePicker = {
        let DateTimePicker = UIDatePicker()
        DateTimePicker.translatesAutoresizingMaskIntoConstraints = false
        
        return DateTimePicker
    }()
    
    
    let dateFormatterGet = DateFormatter()
    
    
    let coreTime = CoreDataManager.shared.dailytime
    
    
    var time :String {
        
        let timeZone = NSTimeZone.local
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "HH:mm"
        let date = formatter.string(from: DateTimePicker.date)
        
        return date
        
    }
    
    let Title:String
    private func config(){
        
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(DateTimePicker)
        self.addSubview(Label)
        
        
        //MARK: Self Setting
        self.layer.cornerRadius = 0
//        self.widthAnchor.constraint(equalToConstant: 350).isActive = true
        self.heightAnchor.constraint(equalToConstant: 75).isActive = true
        self.backgroundColor = .systemFill
        //MARK: Label Setting
        Label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        Label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        Label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        Label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        Label.text = self.Title
        
        //MARK: DateTime Setting
        DateTimePicker.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        DateTimePicker.datePickerMode = .time
        DateTimePicker.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        
    }
    required  init(frame: CGRect,title: String) {
        self.Title = title
        super.init(frame: frame)
        config()
        
        dateFormatterGet.dateFormat = "HH:mm"
        let date = dateFormatterGet.date(from: coreTime)
        self.DateTimePicker.date = date!
        self.DateTimePicker.addTarget(self, action: #selector(dateTimeChange), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dateTimeChange(){
        
        CoreDataManager.shared.changeTime(container: CoreDataManager.container, dateTime: self.time)
        if CoreDataManager.shared.settingConfig[2] == true{
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            let content = UNMutableNotificationContent()
            content.title = "新聞推送"
            
            content.body = "快點查看最新新聞"
            
            
            content.sound = UNNotificationSound.default
            var date = DateComponents()
            
            date.hour = Int(self.time.prefix(2))
            date.minute =  Int(self.time.suffix(2))
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            
            let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                print(date)
                print("成功建立通知...")
            })
        }
        
    }
}
