//
//  HomeTableViewCell.swift
//  News
//
//  Created by 陳冠雄 on 2022/3/7.
//

import UIKit
import LinkPresentation
class SearchTableViewCell: UITableViewCell {
    
    static let identifier = "SearchTableViewCell"
    
    var Url: URL? = nil
    
    var index:Int = 0
    var viewModel: SearchNewsViewModel? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    private let Image : UIImageView = {
      
        let Image = UIImageView()
        Image.translatesAutoresizingMaskIntoConstraints = false
        Image.image = UIImage(systemName: "face.smiling.fill")
        Image.tintColor = .white
        return Image
    }()
    private let TimeLabel: UILabel = {
        let TimeLabel = UILabel()
        TimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        TimeLabel.font = UIFont(name: "Helvetica-Light", size: 15)
        TimeLabel.textColor = .gray
        return TimeLabel
    }()
    
    
    private let TitleLabel: UILabel = {
        let TitleLabel = UILabel()
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        TitleLabel.numberOfLines = 5
        TitleLabel.textColor = .white
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
        
        
     
        
    }
    
    
    
    
    
    
    
      override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .black
        self.addSubview(TitleLabel)
        self.addSubview(Image)
        self.addSubview(TimeLabel)
        
        applyConstraints()
        
          
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() -> Void {
        self.Image.image =  nil
        self.TitleLabel.text = nil
    }
    
    
    
    
    public func config(index: Int,url: String,viewModel : SearchNewsViewModel){
        self.Url = URL(string: url)!
        self.index = index
        self.viewModel = viewModel
        LoadURL()
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            
        // Configure the view for the selected state
    }
    func LoadURL(){
   
//        self.Image.image =  self.viewModel?.newsImage[self.index]
//        self.TitleLabel.text =  self.viewModel?.NewsTitle[self.index]
        
        if self.viewModel?.newsImage[self.index] == nil
        {
        LPMetadataProvider().startFetchingMetadata(for: Url!)  { (linkMetadata, error) in
        guard let linkMetadata = linkMetadata, let imageProvider = linkMetadata.imageProvider else { return }

 
        imageProvider.loadObject(ofClass: UIImage.self) { [self] (image, error) in
            guard error == nil else {
                // handle error
                return
            }
        
            if let image = image as? UIImage {
                // do something with image
                DispatchQueue.main.async {
                    self.viewModel?.newsImage[self.index] = image
                    self.viewModel?.NewsTitle[self.index] = linkMetadata.title!
                    self.Image.image =  self.viewModel?.newsImage[self.index]
                    self.TitleLabel.text =  self.viewModel?.NewsTitle[self.index]
                   
                }
                
            } else {
                print("no image available")
            }
        }
    }
        } else{
         
            self.Image.image =  self.viewModel?.newsImage[self.index]
            self.TitleLabel.text =  self.viewModel?.NewsTitle[self.index]
        }
    }
    
}
