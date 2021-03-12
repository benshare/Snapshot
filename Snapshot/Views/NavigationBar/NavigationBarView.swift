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
    private var leftItem = UIButton()
    private var title = UILabel()
    private var rightItem = UIButton()
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
        title.isHidden = false
        editableTitle.isHidden = true
        title.text = text
    }
    
    func setEditableTitle(background: UIView, text: String, placeholder: String) {
        background.addPermanentTapEvent {
            self.endEditing(true)
        }
        
        title.isHidden = true
        editableTitle.isHidden = false
        editableTitle.isUserInteractionEnabled = true
        editableTitle.delegate = self
        editableTitle.text = text
        editableTitle.placeholder = placeholder
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        hunt.name = textField.text!
        didUpdateActiveUser()
    }
}
