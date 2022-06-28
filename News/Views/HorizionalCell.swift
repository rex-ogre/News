//
//  ViewController.swift
//  News
//
//  Created by 陳冠雄 on 2022/3/5.
//

import UIKit
import Kingfisher

class HorizionalCell: UIView {
    private let fullScreenSize = UIScreen.main.bounds.size
    var tapGesture:UITapGestureRecognizer?
    var saveTagGesture: UITapGestureRecognizer?
    var new: news {
        didSet{
            self.config()
        }
    }
    private let Title : UILabel =  {
        let Title = UILabel()
        Title.font = .systemFont(ofSize: 12, weight: .semibold)
        Title.textColor = .white
        Title.numberOfLines = 3
        Title.adjustsFontSizeToFitWidth = true
        Title.adjustsFontForContentSizeCategory = true
        Title.lineBreakMode = .byClipping
        Title.translatesAutoresizingMaskIntoConstraints = false
        Title.text = ""
        Title.textColor = .white
        return Title
    }()
    
    private let PreviewImage: UIImageView =  {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 350, height: 250))
        
        imageView.isUserInteractionEnabled = true
        
        
        return imageView
    }()
    
    
    
    
    private var SaveIcon: UIImageView = {
        let Icon = UIImageView()
        
        
        Icon.image = UIImage(systemName: "bookmark")
        Icon.tintColor = .white
        Icon.isUserInteractionEnabled =  true
        Icon.translatesAutoresizingMaskIntoConstraints = false
        return Icon
    }()
    
    private func applyConstraints() {
        //MARK: Self Layout
        self.layer.cornerRadius = 20
        let HorizionalCellWidth = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 350.0)
        let HorizionalCellHeight = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 250)
        NSLayoutConstraint.activate([HorizionalCellWidth,HorizionalCellHeight])
        
        
        
        //MARK: Title Layout
        let TitleBottom = Title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        let TitleLeading = Title.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20)
        Title.widthAnchor.constraint(equalToConstant: 200).isActive = true
        NSLayoutConstraint.activate([TitleBottom,TitleLeading])
        //MARK: Icon Layout
        let IconLtraling = SaveIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        let IconTop = SaveIcon.topAnchor.constraint(equalTo: topAnchor,constant: 20)
        
        NSLayoutConstraint.activate([IconLtraling,IconTop])
        
        
        
    }
    
    
    
    
    required init(frame: CGRect,new:news) {
        
        self.new = new
        
        super.init(frame: frame)
        
        self.addSubview(PreviewImage)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .gray
        
        config()
        
        self.Title.text = new.title
        
        self.addSubview(Title)
        self.addSubview(SaveIcon)
        applyConstraints()
     
            
    }
    
    
    @objc func saveTap(tap: UITapGestureRecognizer){
        
        CoreDataManager.shared.createNews(container: CoreDataManager.container, title: self.new.title, url: self.new.link, image: self.new.image!,guid: self.new.id)
        saveTagConfig()
    }
    @objc func removeTap(tap: UITapGestureRecognizer){
        
        CoreDataManager.shared.deleteNews(container: CoreDataManager.container,guid: self.new.id)
        saveTagConfig()
    }
    
    
    
    @objc func handleTap(tap: UITapGestureRecognizer) {
        let vc = self.window?.rootViewController
        
        let secondVc = UINavigationController(rootViewController: NewsWebScreen(new: self.new))
        
        secondVc.modalPresentationStyle = .fullScreen
        if tap.state == .ended {
            vc!.present(secondVc, animated: true, completion: nil)
            
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
  
    
    func config(){
        saveTagConfig()
        guard let image =  self.new.image  else{return  }
       
        self.PreviewImage.kf.setImage(with: URL(string: image)!)
        self.Title.text = new.title
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:)))
        self.PreviewImage.addGestureRecognizer(self.tapGesture!)
    }
    
    func saveTagConfig(){
        
       
        let temp = CoreDataManager.shared.compareNews(container: CoreDataManager.container, guid: self.new.id)
       
        
        if temp {
            self.SaveIcon.image = UIImage(systemName: "bookmark.fill")
            self.saveTagGesture = UITapGestureRecognizer(target: self, action: #selector(removeTap(tap:)))
            self.SaveIcon.addGestureRecognizer(self.saveTagGesture!)
        } else{
            self.SaveIcon.image = UIImage(systemName: "bookmark")
           
            self.saveTagGesture = UITapGestureRecognizer(target: self, action: #selector(saveTap(tap:)))
            self.SaveIcon.addGestureRecognizer(self.saveTagGesture!)
        }
        
    }
    
    func maskRoundedImage(image: UIImage, radius: CGFloat) -> UIImage {
        let imageView: UIImageView = UIImageView(image: image)
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }
    
}
extension HorizionalCell: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == otherGestureRecognizer   {
            
            return false
            
        }
        
        return true
    }
}
