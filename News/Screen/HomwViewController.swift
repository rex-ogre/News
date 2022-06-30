//
//  HomwViewController.swift
//  News
//
//  Created by 陳冠雄 on 2022/2/27.
//

import UIKit
import Foundation
import Combine
import SwiftUI
class HomwViewController: UIViewController {
    
    
    private var fullScreenSize: CGRect?
    
    private let header : UILabel = {
        let header = UILabel()
        header.text = "新聞"
        header.font = UIFont(name: "Thonburi-Bold", size: 35)
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    let HorizionalScrollView: UIScrollView = {
        let HorizionalScrollView = UIScrollView()
        HorizionalScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        HorizionalScrollView.showsVerticalScrollIndicator = false
        HorizionalScrollView.showsHorizontalScrollIndicator = false
        HorizionalScrollView.isScrollEnabled = true
        HorizionalScrollView.isPagingEnabled = true
        return HorizionalScrollView
    }()
    let ErrorLabel = UILabel()
    let PageControl: UIPageControl = {
        let PageControl = UIPageControl()
        PageControl.currentPage = 0
        
        PageControl.numberOfPages = 5
        PageControl.translatesAutoresizingMaskIntoConstraints = false
        
        
        PageControl.currentPageIndicatorTintColor = .black
        PageControl.pageIndicatorTintColor = .gray
        PageControl.backgroundStyle = .minimal
        return PageControl
    }()
    let NewsTabbar : UIScrollView = {
        let NewsTabbar = UIScrollView()
        NewsTabbar.isScrollEnabled = true
        NewsTabbar.isPagingEnabled = false
        NewsTabbar.showsHorizontalScrollIndicator = false
        NewsTabbar.translatesAutoresizingMaskIntoConstraints = false
        return NewsTabbar
    }()
    
    
    var NewsTabbarButton: Dictionary<String,UIButton> = [String:UIButton]()
    let TableViewHeader: UILabel = {
        let TableViewHeader = UILabel()
        TableViewHeader.text = "最新新聞"
        TableViewHeader.font = UIFont(name: "Thonburi-Bold", size: 30)
        TableViewHeader.translatesAutoresizingMaskIntoConstraints = false
        return TableViewHeader
    }()
    let ScrollView : UIScrollView = {
        let ScrollView = UIScrollView()
//        ScrollView.contentInset =  UIEdgeInsets(top: -22, left: 0, bottom: 150, right: 0)
        ScrollView.isDirectionalLockEnabled = true
        ScrollView.isUserInteractionEnabled = true
        ScrollView.bounces = true
        ScrollView.translatesAutoresizingMaskIntoConstraints = false
        return ScrollView
    }()
    
    var VerCellList : [HomeTableViewCell] = []
    var HorCellList : [HorizionalCell] = []
    
    var loadingView: LoadingView = LoadingView()
    
    private var  viewModel: NewsViewModel
    let Newsitems = ["熱門": "TOP","商業":"BUSINESS","政治":"NATION",  "科技":"TECHNOLOGY","體育":"SPORTS","健康":"HEALTH"]
    var tempTopic = "TOP"
    
    
    
    //MARK: Tabbar Button function
    @objc func singleTap(sender:UIButton) {
        
        //MARK: Start loading View
        configLoadingView()
        loadingView.activityIndicator.startAnimating()
        NewsTabbarButton[sender.title(for: .normal)!]?.isSelected = true
        tempTopic = Newsitems[(NewsTabbarButton[sender.title(for: .normal)!]?.titleLabel?.text)!]!
        
        tempTopic != "TOP" ? self.viewModel.loadTopicData(topic: tempTopic, completion: configscreen): self.viewModel.loadTopData(completion: configscreen)
        for i in NewsTabbarButton.keys{
            if (i != sender.title(for: .normal)!){
                NewsTabbarButton[i]?.isSelected = false}}
        
        
    }
    
    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        fullScreenSize = CGRect(origin: .zero, size: view.bounds.size)
        view.backgroundColor = .systemBackground
        NewsTabbar.delegate = self
        self.view.addSubview(NewsTabbar)

        self.view.addSubview(header)
        HorizionalScrollView.delegate = self
        self.ScrollView.addSubview(HorizionalScrollView)
        self.ScrollView.addSubview(PageControl)
        self.ScrollView.addSubview(TableViewHeader)
        configLoadingView()
        loadingView.activityIndicator.startAnimating()
        
        ScrollView.delegate = self
        self.view.addSubview(ScrollView)
        
        applyConstrant()
    }
    
    @objc func pageChanged(sender: UIPageControl) {
        // 依照目前圓點在的頁數算出位置
        var frame = HorizionalScrollView.frame
        frame.origin.x =
        frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        
        // 再將 UIScrollView 滑動到該點
        HorizionalScrollView.scrollRectToVisible(frame, animated:true)
    }
    
    
    //MARK: apply constrant
    func applyConstrant(){
        //MARK News tabbar
        let Newsitems = ["熱門","商業","政治",  "科技","體育","健康"]
        for i in Newsitems {
            let spaceBetweenTag = fullScreenSize!.width / 6
            let catgory = UIButton()
            NewsTabbar.addSubview(catgory)
            catgory.translatesAutoresizingMaskIntoConstraints = false
            catgory.leadingAnchor.constraint(equalTo: self.NewsTabbar.leadingAnchor, constant: CGFloat(20+(Int(spaceBetweenTag)*Newsitems.firstIndex(of: i)!))).isActive = true
            NewsTabbarButton[i] = catgory
            catgory.addTarget(self, action: #selector(singleTap), for: .touchDown)
            
            catgory.setTitle(i, for: .normal)
            catgory.isSelected = false
            catgory.setAttributedTitle(NSAttributedString(string: i,attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21, weight: .bold),NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue,
                                                                                 NSAttributedString.Key.underlineColor:UIColor.orange
                                                                                ]), for: .selected)
            catgory.setAttributedTitle(NSAttributedString(string: i,attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21 ),]), for: .normal)
            catgory.isUserInteractionEnabled = true
            if (Newsitems.firstIndex(of: i)! == 0 ){
                catgory.isSelected = true
            }
            
        }
        let leading = NSLayoutConstraint(item: header,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .leading,
                                         multiplier: 1.0,
                                         constant: 25)
        let top = NSLayoutConstraint(item: header,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: self.view,
                                     attribute: .top,
                                     multiplier: 1.0,
                                     constant: 0)
        let height = NSLayoutConstraint(item: header,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0,
                                        constant: 125.0)
        
        NSLayoutConstraint.activate([leading,top,height])
        
        let NewsTabbarTop = NewsTabbar.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 90)
        let NewsTabbarLeading = NewsTabbar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
        let NewsTabbarTraling = NewsTabbar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        let NesTabbarWidth = NewsTabbar.widthAnchor.constraint(equalToConstant: fullScreenSize!.width*2)
        let NesTabbarheight = NewsTabbar.heightAnchor.constraint( equalToConstant: 70)
        
        
        
        NSLayoutConstraint.activate([NewsTabbarTop,NesTabbarheight,
                                     NewsTabbarLeading,
                                     NewsTabbarTraling,
                                    ])
        
        
        
        let HorizionalScrollViewHeight = NSLayoutConstraint(item: HorizionalScrollView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 250)
        
        
        let HorizionalScrollViewTop = NSLayoutConstraint(item: HorizionalScrollView, attribute: .top, relatedBy: .equal, toItem: self.ScrollView, attribute: .top, multiplier: 1.0, constant: 50)
        let HorizionalScrollViewToTableView = NSLayoutConstraint(item: HorizionalScrollView, attribute: .bottom, relatedBy: .equal, toItem: PageControl, attribute: .top, multiplier: 1.0, constant: 0)
        let HorizionalScrollViewCenter = NSLayoutConstraint(item: HorizionalScrollView, attribute: .centerX, relatedBy: .equal, toItem: self.ScrollView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let HorizionalScrollViewLeading = NSLayoutConstraint(item: HorizionalScrollView, attribute: .leading, relatedBy: .equal, toItem: self.ScrollView, attribute: .leading, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([
            HorizionalScrollViewLeading,
            HorizionalScrollViewHeight,
            HorizionalScrollViewTop,HorizionalScrollViewCenter])
        
        let PageControlTop = NSLayoutConstraint(item: PageControl, attribute: .top, relatedBy: .equal, toItem: self.HorizionalScrollView, attribute: .bottom, multiplier: 1.0, constant: 20)
        
        let PageControlCenter = NSLayoutConstraint(item: PageControl, attribute: .centerX, relatedBy: .equal, toItem: self.ScrollView, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        PageControl.addTarget(self, action: #selector(self.pageChanged), for: .valueChanged)
        NSLayoutConstraint.activate([PageControlTop,PageControlCenter])
        
        TableViewHeader.topAnchor.constraint(equalTo: PageControl.bottomAnchor, constant: 10).isActive = true
        TableViewHeader.leadingAnchor.constraint(equalTo: self.ScrollView.leadingAnchor, constant: 10).isActive = true
        
        
        //MARK: ScrollView
        switch UIDevice.current.name {
        case "iPhone SE (3rd generation)":
            ScrollView.contentSize = CGSize(
                width: fullScreenSize!.width * 1,
                height: fullScreenSize!.height * 5.5)
        case "iPhone 8":
            ScrollView.contentSize = CGSize(
                width: fullScreenSize!.width * 1,
                height: fullScreenSize!.height * 6.5)
        case "iPhone 8 Plus":
            ScrollView.contentSize = CGSize(
                width: fullScreenSize!.width * 1,
                height: fullScreenSize!.height * 6.5)
        default:
            ScrollView.contentSize = CGSize(
                width: fullScreenSize!.width * 1,
                height: fullScreenSize!.height * 5.5)
        }
        NewsTabbar.contentSize = CGSize(width: fullScreenSize!.width*1.5, height: 50)
        HorizionalScrollView.contentSize = CGSize(width: fullScreenSize!.width*5, height: 250)
        ScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: 0).isActive = true
        ScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 0).isActive = true
        ScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        ScrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 130).isActive = true
        
        self.viewModel.loadTopData(completion: configScreenInit)
    }
    
    
    
    //MARK: Config Screen
    func configscreen(){
        
        guard self.viewModel.NewsList.count > 20 else{
            
            self.ScrollView.removeFromSuperview()
            
            self.configError()
            
            self.loadingView.activityIndicator.stopAnimating()
            self.loadingView.removeFromSuperview()
            return
        }
        
        
        if self.ErrorLabel.isDescendant(of: self.view) {
            self.ErrorLabel.removeFromSuperview()
        }
        if self.ScrollView.isDescendant(of: self.view) == false{
            self.view.addSubview(ScrollView)
        }
        for i in self.HorCellList{i.new = self.viewModel.NewsList[self.HorCellList.firstIndex(of: i)!]}
        for i in self.VerCellList{
            i.new = self.viewModel.NewsList[self.VerCellList.firstIndex(of: i)!+6]
            
        }
        self.loadingView.activityIndicator.stopAnimating()
        self.loadingView.removeFromSuperview()
        
        
    }
    
    
    
    
    //MARK: First init Screen
    func configScreenInit(){
        
        DispatchQueue.main.async {
            
            let total = self.viewModel.NewsList.count
            if (total>25){
                print(total)
                
                // Horizional Cell
                for i in  0...4{
                    
                    let HorCell =  HorizionalCell(frame: .null,new: self.viewModel.NewsList[i])
                    let CellCenter = NSLayoutConstraint(item: HorCell, attribute: .centerX, relatedBy: .equal, toItem: self.HorizionalScrollView, attribute: .centerX, multiplier: 1.0, constant: self.fullScreenSize!.width*CGFloat(i) )
                    
                    let CellBottom = NSLayoutConstraint(item: HorCell, attribute: .bottom, relatedBy: .equal, toItem: self.PageControl, attribute: .bottom, multiplier: 1.0, constant: -10 )
                    
                    self.HorizionalScrollView.addSubview(HorCell)
                    
                    NSLayoutConstraint.activate([CellCenter,CellBottom])
                    
                    self.HorCellList.append(HorCell)
                    
                }
                
                
                let d2 = DispatchQueue(label: "verticalCell",qos: DispatchQoS.unspecified)
                
                let workItem = DispatchWorkItem(block: {
                    
                    for i in (0...16){
                        DispatchQueue.main.async {
                            
                            let VerCell = HomeTableViewCell(new: self.viewModel.NewsList[6+i],frame: .null )
                            self.ScrollView.addSubview(VerCell)
                            
                            VerCell.config()
                            VerCell.translatesAutoresizingMaskIntoConstraints = false
                            
                            VerCell.isUserInteractionEnabled = true
                            VerCell.topAnchor.constraint(equalTo: self.TableViewHeader.bottomAnchor, constant: CGFloat(((i)*200)+50)).isActive = true
                            
                            VerCell.centerXAnchor.constraint(equalTo: self.ScrollView.centerXAnchor,constant: 0).isActive = true
                            self.VerCellList.append(VerCell)
                            
                        }
                    }
                })
                
                
                d2.async(execute: workItem)
                
            } else{
                print(total)
                
            }
            
            //MARK: load完 remove loadingview
            self.loadingView.activityIndicator.stopAnimating()
            self.loadingView.removeFromSuperview()
            
            
        }
    }
    
    
    
    //MARK: Error Screen
    private func configError(){
        
        ErrorLabel.text =  "聯絡不上新聞源，請稍候再試"
        self.view.addSubview(ErrorLabel)
        ErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        ErrorLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        ErrorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
    }
    //MARK: LoadingView
    private func configLoadingView(){
        self.view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        loadingView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
     
        if UIDevice.current.orientation.isLandscape {
     
            fullScreenSize = CGRect(x: 0, y: 0, width: size.width,height: size.height)
            ScrollView.contentSize = CGSize(width: size.width, height: size.height*8)
            configOriention()
            HorizionalScrollView.contentSize = CGSize(width: fullScreenSize!.width*5, height: 250)
           
            HorizionalScrollView.contentOffset = CGPoint(x: Int(size.width) * PageControl.currentPage, y: 0)
            
        
        } else {
      
            fullScreenSize = CGRect(x: 0, y: 0, width: size.width,height: size.height)
            ScrollView.contentSize = CGSize(width: size.width, height: size.height*5.5)
            configOriention()
            
            HorizionalScrollView.contentSize = CGSize(width: fullScreenSize!.width*5, height: 250)
    
            HorizionalScrollView.contentOffset = CGPoint(x: (Int(size.width) * PageControl.currentPage) - (Int((size.width - 350))), y: 0)
        }
        
    }
    
    
        
    
    func configOriention(){
        
        guard self.viewModel.NewsList.count > 4 else {return}
        NewsTabbar.contentOffset  = CGPoint(x: -40, y: 0)
        
        for i in HorCellList{
            i.removeFromSuperview()
        }
        NewsTabbarButton.forEach{
            v,k in
            k.removeFromSuperview()
        }
        HorizionalScrollView.contentSize = CGSize(width: fullScreenSize!.width*5, height: 250)
        for i in  0...4{
            let HorCell =  HorizionalCell(frame: .null,new: self.viewModel.NewsList[i])
            let CellCenter = NSLayoutConstraint(item: HorCell, attribute: .centerX, relatedBy: .equal, toItem: self.HorizionalScrollView, attribute: .centerX, multiplier: 1.0, constant: self.fullScreenSize!.width*CGFloat(i) )
            let CellBottom = NSLayoutConstraint(item: HorCell, attribute: .bottom, relatedBy: .equal, toItem: self.PageControl, attribute: .bottom, multiplier: 1.0, constant: -10 )
            self.HorizionalScrollView.addSubview(HorCell)
            NSLayoutConstraint.activate([CellCenter,CellBottom])
            self.HorCellList.append(HorCell)
        }
        
        let Newsitems = ["熱門","商業","政治",  "科技","體育","健康"]
        for i in Newsitems {
            let spaceBetweenTag = fullScreenSize!.width / 6
            let catgory = UIButton()
            NewsTabbar.addSubview(catgory)
            catgory.translatesAutoresizingMaskIntoConstraints = false
            catgory.leadingAnchor.constraint(equalTo: self.NewsTabbar.leadingAnchor, constant: CGFloat(20+(Int(spaceBetweenTag)*Newsitems.firstIndex(of: i)!))).isActive = true
            NewsTabbarButton[i] = catgory
            catgory.addTarget(self, action: #selector(singleTap), for: .touchDown)
            
            catgory.setTitle(i, for: .normal)
            catgory.isSelected = false
            catgory.setAttributedTitle(NSAttributedString(string: i,attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21, weight: .bold),NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue,
                                                                                 NSAttributedString.Key.underlineColor:UIColor.orange
                                                                                ]), for: .selected)
            catgory.setAttributedTitle(NSAttributedString(string: i,attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21 ),]), for: .normal)
            catgory.isUserInteractionEnabled = true
            if (self.Newsitems[i] == tempTopic ){
    
                catgory.isSelected = true
            }
            
        }
    }
    
}



extension HomwViewController:UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 左右滑動到新頁時 更新 UIPageControl 顯示的頁數
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        PageControl.currentPage = page
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    
}


