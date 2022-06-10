//
//  SavedViewController.swift
//  News
//
//  Created by 陳冠雄 on 2022/2/27.
//

import UIKit
import CoreData
class SavedViewController: UIViewController, UIScrollViewDelegate {
 
    private let fullScreenSize = UIScreen.main.bounds.size
    let viewModel : SavedViewmodel

    let header: UILabel = {
        let header = UILabel()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.text = "稍後觀看"
        header.font = UIFont(name: "Thonburi-Bold", size: 24)
        return header
    }()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SavedTableViewCell.self, forCellReuseIdentifier: SavedTableViewCell.identifier)
        tableView.separatorStyle = .singleLine
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 150 ,right: 0)
        return tableView
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(header)
        self.view.addSubview(tableView)
        applyConstraints()
        
        
        self.viewModel.loadData(config: {
    
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
           
        })
        
    }
   

 

    
    init(viewModel: SavedViewmodel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    private func applyConstraints(){
        
        //MARK: header
        let headerConstraints = [
            self.header.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 50),
            self.header.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,constant: 0),
            self.header.heightAnchor.constraint(equalToConstant: 50)
            ]
            
            
        
        let tableViewConstraints = [
            self.tableView.topAnchor.constraint(equalTo: self.header.bottomAnchor,constant: 50),
            self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,constant: 0),
            self.tableView.widthAnchor.constraint(equalToConstant: self.fullScreenSize.width),
            self.tableView.heightAnchor.constraint(equalToConstant: self.fullScreenSize.height)
            ]
        
        
        
        NSLayoutConstraint.activate(headerConstraints)
        NSLayoutConstraint.activate(tableViewConstraints)
    }
    
    

    
}

extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.NewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
        tableView.dequeueReusableCell(
            withIdentifier: "SavedTableViewCell", for: indexPath) as! SavedTableViewCell
        
        cell.config(new: self.viewModel.NewsList[indexPath.row])
      
        
              return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
   
           
           
    }
    
}


