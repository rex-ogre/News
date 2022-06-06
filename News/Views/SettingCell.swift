//
//  SettingCell.swift
//  News
//
//  Created by 陳冠雄 on 2022/3/24.
//

import UIKit

class SettingCell: UIView {
    let Label: UILabel = UILabel()
    let Switch: UISwitch = UISwitch()
    let Title:String
    private func config(){
    Label.translatesAutoresizingMaskIntoConstraints = false
    Switch.translatesAutoresizingMaskIntoConstraints = false
    self.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(Switch)
    self.addSubview(Label)
    
    
    //MARK: Self Setting
    self.layer.cornerRadius = 0.0
    self.widthAnchor.constraint(equalToConstant: 350).isActive = true
    self.heightAnchor.constraint(equalToConstant: 75).isActive = true
    self.backgroundColor = .black
    //MARK: Label Setting
    Label.widthAnchor.constraint(equalToConstant: 100).isActive = true
    Label.heightAnchor.constraint(equalToConstant: 50).isActive = true
    Label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    Label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        Label.text = self.Title
        Label.textColor = .white
    //MARK: Switch Setting
    Switch.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    Switch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40).isActive = true
    
    }
    required  init(frame: CGRect,title: String) {
        self.Title = title
        super.init(frame: frame)
        config()
        
    }
     required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
