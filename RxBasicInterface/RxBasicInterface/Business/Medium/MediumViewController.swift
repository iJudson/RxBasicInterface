//
//  MediumViewController.swift
//  RxBasicInterface
//
//  Created by 陈恩湖 on 2017/9/9.
//  Copyright © 2017年 Judson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MediumViewController: UIViewController {
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTopBarControls()
    }
    
    fileprivate func initializeTopBarControls() {
        let navigationBarStyle = NavigationBarStyle()
        let themeStyle = TopPageThemeStyle(columnTitle: ["电影", "电视", "读书"])
        let topPageBar = TopPageBar(themeStyle: themeStyle)
        let navigationBar = NavigationBar(themeStyle: navigationBarStyle)
        navigationBar.addSubview(topPageBar)
        self.view.addSubview(navigationBar)
        
        for tapIndex in topPageBar.clickedIndexes {
            tapIndex.drive(onNext: { (index) in
                // 在这个地方绑定点击的具体事件
                
            }).disposed(by: disposeBag)
        }
    }
    
}
  
