//
//  TabBarView.swift
//  RxBasicInterface
//
//  Created by 陈恩湖 on 2017/9/10.
//  Copyright © 2017年 Judson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias TabBarItemElement = (normalImage: UIImage?, selectedImage: UIImage?, title: String?)
let screenWidth = ceil(UIScreen.main.bounds.size.width)
let tabBarHeight: CGFloat = 49
let screenHeight = ceil(UIScreen.main.bounds.size.height)

struct TabBarStyle {
    
    var itemElements: [TabBarItemElement]
    var themeColor: UIColor = UIColor.white
    var hasTopLine: Bool = true
    
    init(elements: [TabBarItemElement] = []) {
        self.itemElements = elements
    }
}

class TabBarView: UIView {
    
    // 主题样式
    var themeStyle: TabBarStyle = TabBarStyle() {
        didSet {
            update(ThemeStyle: themeStyle)
        }
    }
    
    //当前选中的 index
    var selectedIndexes: [Driver<Int>] = []
    
    // 当前选中的 Item
    fileprivate var selectedItems: [CommonItemView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect? = nil, themeStyle: TabBarStyle) {
        let barFrame = frame ?? CGRect(x: 0, y: screenHeight - tabBarHeight, width: screenWidth, height: tabBarHeight)
        self.init(frame: barFrame)
        self.backgroundColor = themeStyle.themeColor
        update(ThemeStyle: themeStyle)
        add(TopLine: themeStyle.hasTopLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func update(ThemeStyle style: TabBarStyle) {
        
        let itemCount = style.itemElements.count
        let itemWidth = screenWidth/CGFloat(itemCount)
        var commonItemFrame = CGRect(x: 0, y: 0, width: itemWidth, height: tabBarHeight)
        
        for (index, element) in style.itemElements.enumerated() {
            commonItemFrame.origin.x = CGFloat(index) * itemWidth
            let commonTabBarIem = CommonItemView(frame: commonItemFrame, image: element.normalImage, title: element.title)
            commonTabBarIem.setImage(element.selectedImage, for: .selected)
            commonTabBarIem.alignmentStyle = .upImageDownText(space: 1)
            commonTabBarIem.tag = index
            commonTabBarIem.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            commonTabBarIem.setTitleColor(UIColor.gray, for: .normal)
            commonTabBarIem.setTitleColor(UIColor.black, for: .selected)
            
            self.selectedItems.append(commonTabBarIem)
            self.addSubview(commonTabBarIem)
            let selectedIndex = commonTabBarIem.rx.controlEvent(.touchDown).throttle(0.5, scheduler: MainScheduler.instance).flatMapLatest { (_) -> Driver<Int> in
                self.handleClickItemEvent(index: commonTabBarIem.tag)
                return Driver<Int>.just(commonTabBarIem.tag)
                }.asDriver(onErrorJustReturn: 0)
            selectedIndexes.append(selectedIndex)
            
            // 默认选中第一个 tabBarItem
            commonTabBarIem.isSelected = (index == 0 ? true : false)
        }
    }
    
    fileprivate func add(TopLine isExisting: Bool) {
        guard isExisting else {
            return
        }
        
        let lineHeight: CGFloat = 0.5
        let topLine = UIView(frame: CGRect(x: 0, y: -lineHeight, width: screenWidth, height: lineHeight))
        topLine.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.addSubview(topLine)
    }
    
    // 处理 item 的点击事件，改变 Item 的样式
    fileprivate func handleClickItemEvent(index: Int) {
        for item in selectedItems {
            item.isSelected = (item.tag == index ? true : false)
        }
    }
}

