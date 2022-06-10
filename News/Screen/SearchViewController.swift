//
//  SearchViewController.swift
//  News
//
//  Created by 陳冠雄 on 2022/2/27.
//

import UIKit
import Foundation
class SearchViewController: UIViewController  {
  
    private let fullScreenSize = UIScreen.main.bounds.size
    private var viewModel: SearchNewsViewModel
    let TitleLabel = UILabel()
    let SearchBar = UISearchBar()
    var TableView = UITableView()
    var loadingView: LoadingView = LoadingView()
    let ErrorLabel = UILabel()
    
    
    init(viewModel: SearchNewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
//    let SearchController = SearchViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        //MARK: Title Label
        self.view.addSubview(SearchBar)
        self.view.addSubview(TitleLabel)
        TitleLabel.text = "搜尋"
        TitleLabel.font = UIFont(name: "Thonburi-Bold", size: 24)
        TitleLabel.tintColor = .systemBackground
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        TitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        TitleLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        TitleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        TitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    
       
        //MARK: SearchBar Layout
  
        SearchBar.translatesAutoresizingMaskIntoConstraints = false
        SearchBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
        SearchBar.widthAnchor.constraint(equalToConstant: fullScreenSize.width).isActive = true
        SearchBar.topAnchor.constraint(equalTo: TitleLabel.bottomAnchor, constant: 10).isActive = true
        SearchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        SearchBar.barTintColor = .systemFill
        SearchBar.searchBarStyle = .minimal
        SearchBar.searchTextField.backgroundColor = .systemFill
        SearchBar.delegate = self

        //MARK: Search Table View config

        self.view.addSubview(TableView)

        TableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        TableView.contentInset =  UIEdgeInsets(top: -22, left: 0, bottom: 150, right: 0)
        TableView.delegate = self
        TableView.dataSource = self
        TableView.separatorStyle = .singleLine
       
        self.view.addSubview(TableView)
        TableView.translatesAutoresizingMaskIntoConstraints = false
        TableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 65 ,right: 0)
        NSLayoutConstraint(item: TableView, attribute: .top, relatedBy: .equal, toItem: self.SearchBar, attribute: .bottom, multiplier: 1.0, constant: 30).isActive = true
        NSLayoutConstraint(item: TableView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: fullScreenSize.width).isActive = true
        NSLayoutConstraint(item: TableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: fullScreenSize.height-100).isActive = true
        
        
        
        
        
        
    //Looks for single or multiple taps.
     let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

    //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
    //tap.cancelsTouchesInView = false

    view.addGestureRecognizer(tap)
    }
 
    
    
    
    //MARK: LoadingView
    private func configLoadingView(){
        self.view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.heightAnchor.constraint(equalToConstant: fullScreenSize.height).isActive  = true
        loadingView.widthAnchor.constraint(equalToConstant: fullScreenSize.width).isActive  = true
    }
    
    //MARK: Error Screen
    private func configError(){
        
        ErrorLabel.text =  "找不到相關新聞，請更換關鍵字"
        self.view.addSubview(ErrorLabel)
        ErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        ErrorLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        ErrorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
    
    }

}
extension SearchViewController: UISearchBarDelegate{
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.configLoadingView()
        self.loadingView.activityIndicator.startAnimating()
        var temp: String  = searchBar.text!
        temp = temp.replacingOccurrences(of: " ",with: "")
        self.viewModel.loadQuery(query: temp){
            DispatchQueue.main.async {
           
                self.loadingView.activityIndicator.stopAnimating()
                self.loadingView.removeFromSuperview()
                if (self.viewModel.NewsList.count == 0 ){
                    self.configError()
                    
                } else if self.ErrorLabel.isDescendant(of: self.view){
                     
                        self.ErrorLabel.removeFromSuperview()
                    
                }
                self.TableView.reloadData()
            }
            
        }
  
  
      }
}





extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        
        return self.viewModel.NewsList.count > 30 ? 30 : self.viewModel.NewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
        tableView.dequeueReusableCell(
            withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        cell.config(new: self.viewModel.NewsList[indexPath.row])
      
    
              return cell
        
          
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    

   

}
