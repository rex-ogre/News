

import Foundation
import UIKit

class LoadingView: UIView{
    
    
    
    required  override init(frame: CGRect) {
       
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        configActivityIndicator()
        
    }
     required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    
    var activityIndicator:UIActivityIndicatorView = {
        //
       
           let activityIndicator = UIActivityIndicatorView(
                style:.large)
       
        activityIndicator.color = UIColor.white
        return activityIndicator
    }()
    
    
    //MARK: ActivityIndicator
    private func configActivityIndicator(){
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.heightAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

    
    }
    
}
