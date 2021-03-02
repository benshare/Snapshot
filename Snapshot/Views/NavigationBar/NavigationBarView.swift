//
//  NavigationBarView.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/1/21.
//

import Foundation
import UIKit

class NavigationBarView: UIView {
    // MARK: Variables
    // Elements
    private var leftItem = UIButton()
    private var title = UILabel()
    private var rightItem = UIButton()
    
    // Layout
    private var layout: NavigationBarViewViewLayout!
    
    // MARK: Initialization
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRect())
        
        self.leftItem.isHidden = true
        self.leftItem.setTitleColor(.blue, for: .normal)
        self.addSubview(leftItem)
        
        self.title.isHidden = true
        self.title.font = UIFont.boldSystemFont(ofSize: self.title.font.pointSize)
        self.addSubview(title)
        
        self.rightItem.isHidden = true
        self.addSubview(rightItem)
        
        layout = NavigationBarViewViewLayout(leftItem: leftItem, title: title, rightItem: rightItem)
        layout.configureConstraints(view: self)
        redrawScene()
        
        self.alpha = 0.8
        self.backgroundColor = .lightGray
    }
    
    // MARK: UI
    func redrawScene() {
        let isPortrait = orientationIsPortrait()
        layout.activateConstraints(isPortrait: isPortrait)
    }
    
    // MARK: Customize
    func addBackButton(text: String, action: @escaping () -> Void) {
        leftItem.setTitle(text, for: .normal)
        leftItem.addAction(action)
        leftItem.isHidden = false
    }
    
    func setTitle(text: String) {
        title.text = text
        title.isHidden = false
    }
}
