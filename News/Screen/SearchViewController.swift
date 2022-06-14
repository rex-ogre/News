//
//  SearchViewController.swift
//  News
//
//  Created by 陳冠雄 on 2022/2/27.
//

import UIKit
import Foundation
class SearchViewController: UIViewController  {
    
    private var fullScreenSize = UIScreen.main.bounds.size
    private var viewModel: SearchNewsViewModel
    let TitleLabel : UILabel = {
        let TitleLabel = UILabel()
        TitleLabel.text = "搜尋"
        TitleLabel.font = UIFont(name: "Thonburi-Bold", size: 24)
        TitleLabel.tintColor = .systemBackground
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return TitleLabel
    }()
    let SearchBar : UISearchBar = {
        let SearchBar = UISearchBar()
        SearchBar.translatesAutoresizingMaskIntoConstraints = false
        
        SearchBar.barTintColor = .systemFill
        SearchBar.searchBarStyle = .minimal
        SearchBar.searchTextField.backgroundColor = .systemFill
        return SearchBar
    }()
    var TableView : UITableView = {
        let TableView = UITableView()
        TableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        TableView.contentInset =  UIEdgeInsets(top: -22, left: 0, bottom: 150, right: 0)
        
        TableView.separatorStyle = .singleLine
        TableView.tableFooterView = nil
        
        TableView.translatesAutoresizingMaskIntoConstraints = false
        TableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 65 ,right: 0)
        return TableView
    }()
    var loadingView: LoadingView = LoadingView()
    let ErrorLabel = UILabel()
    
    
    init(viewModel: SearchNewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        
        self.view.addSubview(SearchBar)
        self.view.addSubview(TitleLabel)
        self.view.addSubview(TableView)
        
        
        SearchBar.delegate = self
        
        self.view.addSubview(TableView)
        TableView.delegate = self
        TableView.dataSource = self
        
        
        applyConstrant()
        
        
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func applyConstrant(){
        //MARK: Title Label
        
        
        TitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        TitleLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        TitleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        TitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        //MARK: SearchBar
        SearchBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
        //        SearchBar.widthAnchor.constraint(equalToConstant: fullScreenSize.width).isActive = true
        SearchBar.topAnchor.constraint(equalTo: TitleLabel.bottomAnchor, constant: 10).isActive = true
        SearchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        SearchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        SearchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //MARK: TableView
        NSLayoutConstraint(item: TableView, attribute: .top, relatedBy: .equal, toItem: self.SearchBar, attribute: .bottom, multiplier: 1.0, constant: 30).isActive = true
        //        NSLayoutConstraint(item: TableView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: fullScreenSize.width).isActive = true
        //        NSLayoutConstraint(item: TableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: fullScreenSize.height-100).isActive = true
        NSLayoutConstraint(item: TableView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: TableView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: TableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    
    
    
    
  
    //MARK: LoadingView
    private func configLoadingView(){
        self.view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.heightAnchor.constraint(equalToConstant: fullScreenSize.height).isActive  = true
        loadingView.widthAnchor.constraint(equalToConstant: fullScreenSize.width).isActive  = true
        loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        loadingView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
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
