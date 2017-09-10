//
//  TopPageBar.swift
//  RxBasicInterface
//
//  Created by 陈恩湖 on 2017/9/10.
//  Copyright © 2017年 Judson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// 顶部分栏控件主题样式的 配置器 （所有的样式可于此配置好 再传给 TopPageBar）
struct TopPageThemeStyle {
    var columnTitle: [String]
    var themeColor: UIColor = UIColor.white
    var hasSlider: Bool = false
    var sliderColorStyle: UIColor = UIColor(red: 27/255.0, green: 170/255.0, blue: 34/255.0, alpha: 1.0)
    var horizontalInsets: CGFloat = 30
    
    init(columnTitle: [String] = []) {
        self.columnTitle = columnTitle
    }
}

class TopPageBar: UIView {
    
    var themeStyle: TopPageThemeStyle = TopPageThemeStyle() {
        didSet {
            updateThemeStyle()
        }
    }
    // item 从左到右进行排布 tag 从0开始依次递增
    var clickedIndexes: [Driver<Int>] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect? = nil, themeStyle: TopPageThemeStyle) {
        let barFrame = frame ?? CGRect(x: 0, y: 0, width: screenWidth, height: navigationBarHeight)
        self.init(frame: barFrame)
        self.themeStyle = themeStyle
        updateThemeStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func updateThemeStyle() {
        
        self.backgroundColor = themeStyle.themeColor
        let columnCount = themeStyle.columnTitle.count
        
        guard columnCount > 0 else {
            return
        }
        
        let subViewWidth = self.width/CGFloat(columnCount)
        
        for (index, title) in themeStyle.columnTitle.enumerated() {
            let button = UIButton(frame: CGRect(x: CGFloat(index) * subViewWidth, y: statusBarHeight, width: subViewWidth, height: navigationBarHeight - statusBarHeight))
            button.tag = index
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor.gray, for: .normal)
            button.setTitleColor(UIColor(red: 27/255.0, green: 170/255.0, blue: 34/255.0, alpha: 1.0), for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.titleLabel?.sizeToFit()
            self.addSubview(button)
            let titleWidth = button.titleLabel?.width ?? 0
            let horizontalOffset = subViewWidth * 0.5 - themeStyle.horizontalInsets - titleWidth * 0.5
            
            if index == 0 && columnCount >= 3 {
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -horizontalOffset, bottom: 0, right: 0)
            } else if index == (columnCount - 1) && columnCount >= 3 {
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -horizontalOffset)
            }
            
            let clickedIndex = button.rx.controlEvent(.touchDown).throttle(0.5, scheduler: MainScheduler.instance).flatMapLatest { (_) -> Driver<Int> in
                return Driver<Int>.just(button.tag)
                }.asDriver(onErrorJustReturn: 0)
            clickedIndexes.append(clickedIndex)
            
            if index == 0 {
                button.isSelected = true
            }
        }
    }
    
}
