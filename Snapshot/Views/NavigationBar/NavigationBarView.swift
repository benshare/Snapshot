//
//  NavigationBarView.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/1/21.
//

import Foundation
import UIKit

class NavigationBarView: UIView, UITextFieldDelegate {
    // MARK: Variables
    // Elements
    var leftItem = UIButton()
    private var title = UILabel()
    var rightItem = UIButton()
    private var editableTitle = UITextField()
    
    // Layout
    private var layout: NavigationBarViewViewLayout!

    // Data
    var hunt: TreasureHunt!
    
    // MARK: Initialization
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.leftItem.isHidden = true
        self.leftItem.setTitleColor(.blue, for: .normal)
        self.addSubview(leftItem)
        
        self.title.isHidden = true
        self.title.font = UIFont.boldSystemFont(ofSize: self.title.font.pointSize)
        self.addSubview(title)
        
        self.editableTitle.isHidden = true
        self.addSubview(editableTitle)
        
        self.rightItem.isHidden = true
        self.addSubview(rightItem)
        
        layout = NavigationBarViewViewLayout(leftItem: leftItem, title: title, editableTitle: editableTitle, rightItem: rightItem)
        layout.configureConstraints(view: self)
        redrawScene()
        
        self.backgroundColor = .lightGray
    }
    
    // MARK: UI
    func redrawScene() {
        let isPortrait = orientationIsPortrait()
        layout.activateConstraints(isPortrait: isPortrait)
    }
    
    // MARK: Customize
    func addBackButton(text: String, action: @escaping () -> Void, color: UIColor = .systemBlue) {
        leftItem.setTitle(text, for: .normal)
        leftItem.setTitleColor(color, for: .normal)
        leftItem.addAction(action)
        leftItem.isHidden = false
        bringSubviewToFront(leftItem)
    }
    
    func setTitle(text: String, color: UIColor = .black) {
        title.isHidden = false
        editableTitle.isHidden = true
        title.text = text
        title.textColor = color
    }
    
    func setEditableTitle(background: UIView, text: String, placeholder: String, color: UIColor = .black) {
        background.addPermanentTapEvent {
            self.endEditing(true)
        }
        
        title.isHidden = true
        editableTitle.isHidden = false
        editableTitle.isUserInteractionEnabled = true
        editableTitle.delegate = self
        editableTitle.text = text
        editableTitle.textColor = color
        editableTitle.placeholder = placeholder
    }
    
    func setLeftItem(text: String? = nil, image: UIImage? = nil, action: @escaping () -> Void) {
        leftItem.setTitle(text, for: .normal)
        leftItem.setBackgroundImage(image, for: .normal)
        leftItem.addAction(action)
        leftItem.isHidden = false
    }
    
    func setRightItem(text: String? = nil, image: String? = nil, tint: UIColor = .clear, action: @escaping () -> Void) {
        rightItem.setTitle(text, for: .normal)
        if image != nil {
            rightItem.setBackgroundImage(UIImage(named: image!)?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        rightItem.tintColor = tint
        rightItem.addAction(action)
        rightItem.isHidden = false
    }
    
    func getTitle() -> String? {
        return title.isHidden ? editableTitle.text : title.text
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        hunt.name = textField.text!
    }
}
