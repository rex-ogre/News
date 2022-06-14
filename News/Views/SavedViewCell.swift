//
//  HomeTableViewCell.swift
//  News
//
//  Created by 陳冠雄 on 2022/3/7.
//

import UIKit

class SavedTableViewCell: UITableViewCell {
    
    static let identifier = "SavedTableViewCell"
    
    var new: news?
    var saveTagGesture: UITapGestureRecognizer?
    var tapGesture:UITapGestureRecognizer?
    
    private let Image : UIImageView = {
      
        let Image = UIImageView()
        Image.translatesAutoresizingMaskIntoConstraints = false
        Image.image = UIImage(systemName: "camera")
        Image.tintColor = .systemFill
        return Image
    }()
    private let TimeLabel: UILabel = {
        let TimeLabel = UILabel()
        TimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        TimeLabel.font = UIFont(name: "Helvetica-Light", size: 15)
        TimeLabel.textColor = .systemFill
        return TimeLabel
    }()
    private let SaveIcon: UIImageView = {
        let SaveIcon = UIImageView()
        SaveIcon.translatesAutoresizingMaskIntoConstraints = false
        SaveIcon.isUserInteractionEnabled = true
        SaveIcon.image = UIImage(systemName: "bookmark")
        return SaveIcon
    }()
    
    
    private let TitleLabel: UILabel = {
        let TitleLabel = UILabel()
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        TitleLabel.numberOfLines = 5
//        TitleLabel.textColor = .systemBackground
        return TitleLabel
    }()
    
    private func applyConstraints(){
        //MART Image Layout
        
        
        let ImageLayoutLeading = NSLayoutConstraint(item: Image, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        
        let ImageLayoutCenterY = NSLayoutConstraint(item: Image, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        let ImageLayoutHeight = NSLayoutConstraint(item: Image, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 150)
        let ImageLayoutWidth = NSLayoutConstraint(item: Image, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 150)
        NSLayoutConstraint.activate([ImageLayoutCenterY,ImageLayoutHeight,ImageLayoutWidth,ImageLayoutLeading])
        //MARK: TitleLabel Layout
        
        
        let TitleLabelLayoutCenterY = NSLayoutConstraint(item: TitleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        let TitleLabelLayoutLeading = NSLayoutConstraint(item: TitleLabel, attribute: .leading, relatedBy: .equal, toItem: Image, attribute: .trailing, multiplier: 1.0, constant: 20)
            
        let TitleLabelLayoutWidth = NSLayoutConstraint(item: TitleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 150)
        let TitleLabelLayoutHeight = NSLayoutConstraint(item: TitleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 150)
        NSLayoutConstraint.activate([TitleLabelLayoutWidth,TitleLabelLayoutHeight,TitleLabelLayoutLeading,TitleLabelLayoutCenterY])
        
        
        //MARK: TimeLabel Layout
        let TimeLabelWidth = NSLayoutConstraint(item: TimeLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 150)
        let TimeLabelHeight = NSLayoutConstraint(item: TimeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 150)
        let TimeLabelBottom = NSLayoutConstraint(item: TimeLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 40)
        let TimeLabelLeading = NSLayoutConstraint(item: TimeLabel, attribute: .leading, relatedBy: .equal, toItem: Image, attribute: .trailing, multiplier: 1.0, constant: 20)
        NSLayoutConstraint.activate([TimeLabelWidth,TimeLabelHeight,TimeLabelLeading,TimeLabelBottom])
        
        //MARK: SaveIcon Layout
//        let SaveIconBottom = NSLayoutConstraint(item: SaveIcon, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -20)
//        let SaveIconTralling = NSLayoutConstraint(item: SaveIcon, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -20)
//        NSLayoutConstraint.activate([SaveIconBottom,SaveIconTralling])
        

        
     
        
    }
    
   
    
    
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemFill
        
        self.addSubview(TitleLabel)
        self.addSubview(Image)
        self.addSubview(TimeLabel)
//         self.addSubview(self.SaveIcon)
        applyConstraints()
         
         tapGesture?.delegate = self
         saveTagGesture?.delegate = self
         tapGesture =
         UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:)))
         
         self.addGestureRecognizer(tapGesture!)
        
        
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() -> Void {
        self.Image.image =  nil
        self.TitleLabel.text = nil
    }
    
    @objc func handleTap(tap: UITapGestureRecognizer) {
      let vc = self.window?.rootViewController
    
        let secondVc = UINavigationController(rootViewController: NewsWebScreen(new: self.new!))
  
        secondVc.modalPresentationStyle = .fullScreen
        
        if tap.state == .ended {
            vc!.present(secondVc, animated: true, completion: nil)
        
        }
    }
    @objc func saveTap(tap: UITapGestureRecognizer){
        
        CoreDataManager.shared.createNews(container: CoreDataManager.container, title: self.new!.title, url: self.new!.link, image: self.new!.image!,guid: self.new!.id)
        saveTagConfig()
    }
    @objc func removeTap(tap: UITapGestureRecognizer){
        
        CoreDataManager.shared.deleteNews(container: CoreDataManager.container,guid: self.new!.id)
        saveTagConfig()
    }
    
    public func config(new: news){
        self.new = new
        self.saveTagConfig()
        guard let image = self.new!.image else{return}
     
        self.TitleLabel.text = self.new!.title
        
        
        guard (self.Image.kf.setImage(with: URL(string: image)) != nil) else{
            return
        }
        if self.new?.image == "" { self.Image.image = UIImage(systemName: "camera") }
        
    }
    
    func saveTagConfig(){
        
       
        let temp = CoreDataManager.shared.compareNews(container: CoreDataManager.container, guid: self.new!.id)
     
        
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
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            
        // Configure the view for the selected state
    }

}
extension SavedTableViewCell{
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("?")
        
        if gestureRecognizer == otherGestureRecognizer{
            
            return false
            
        }
        
        return true
    }
}
