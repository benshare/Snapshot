//
//  FullClueView.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/8/21.
//

import Foundation
import UIKit

class FullClueView: UIView {
    // MARK: Variables
    // UI elements
    let titleLabel: UILabel
    let clueText: UILabel
    let clueImage: UIImageView?
    let hintView: UIStackView?
    
    // Formatting
    var layout: FullClueLayout!
    
    // Other
    let clue: Clue
    var nonEmptyHints = [String]()
    let parentController: UIViewController
    var isNew: Bool = false
    var clueNum: Int?
    
    // MARK: Initialization
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(clue: Clue, parentController: UIViewController) {
        self.clue = clue
        self.parentController = parentController
        titleLabel = UILabel()
        clueText = UILabel()
        clueImage = clue.image == nil ? nil : UIImageView(image: clue.image)
        for hint in clue.hints {
            if !hint.isEmpty {
                nonEmptyHints.append(hint)
            }
        }
        hintView = nonEmptyHints.isEmpty ? nil : UIStackView()
        super.init(frame: CGRect.zero)
    }
    
    func configureView(isNew: Bool = false, clueNum: Int? = nil) {
        addSubview(titleLabel)
        addSubview(clueText)
        if clueImage != nil {
            let wrapper = UIView()
            doNotAutoResize(view: wrapper)
            wrapper.addSubview(clueImage!)
            addSubview(wrapper)
            NSLayoutConstraint.activate([
                clueImage!.widthAnchor.constraint(equalTo: wrapper.widthAnchor),
                clueImage!.heightAnchor.constraint(equalTo: wrapper.heightAnchor),
                clueImage!.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor),
                clueImage!.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor),
            ])
        } else {
            clueImage?.isHidden = true
        }
        if hintView != nil {
            addSubview(hintView!)
        } else {
            hintView?.isHidden = true
        }
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 10
        
        self.isNew = isNew
        self.clueNum = clueNum
        titleLabel.font = UIFont.systemFont(ofSize: 30)

        clueText.text = clue.text
        clueText.numberOfLines = 0
        
        clueImage?.contentMode = .scaleAspectFit
        
        if hintView != nil {
            let lastHint = nonEmptyHints.count - 1
            for i in 0...lastHint {
                let hint = nonEmptyHints[i]
                let hintButton = UIButton()
                hintButton.setTitle("Hint \(i + 1)", for: .normal)
                hintButton.setTitleColor(.black, for: .normal)
                hintButton.backgroundColor = .lightGray
                hintButton.layer.cornerRadius = 5
                
                hintButton.addAction { [self] in
                    let alert = UIAlertController(title: "Hint \(i + 1)", message: hint, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: {_ in
                        alert.dismiss(animated: true, completion: {})
                    }))
                    parentController.present(alert, animated: true, completion: {})
                    if i < lastHint {
                        let nextHint = hintView?.arrangedSubviews[i + 1].subviews[0] as! UIButton
                        nextHint.isEnabled = true
                        nextHint.alpha = 1
                    }
                }
                if i > 0 {
                    hintButton.isEnabled = false
                    hintButton.alpha = 0.3
                }
                
                let buttonWrapper = UIView()
                buttonWrapper.backgroundColor = .white
                buttonWrapper.addSubview(hintButton)
                hintView!.addArrangedSubview(buttonWrapper)
            }
            
            hintView!.axis = .vertical
        }
        
        layout = FullClueLayout(titleLabel: titleLabel, clueText: clueText, clueImage: clueImage, hintView: hintView)
        layout.configureConstraints(view: self)
        
        redrawScene()
    }
    
    // MARK: UI
    func redrawScene() {
        let isPortrait = orientationIsPortrait()
//        center = parentController.view.center
//        frame.size = CGSize(width:  parentController.view.frame.width * 0.8, height:  parentController.view.frame.height * 0.8)
        
        if isPortrait {
            titleLabel.text = isNew ? "You unlocked\na new clue!" : "Clue #\(clueNum!)"
            titleLabel.numberOfLines = isNew ? 2 : 1
        } else {
            titleLabel.text = isNew ? "You unlocked a new clue!" : "Clue #\(clueNum!)"
            titleLabel.numberOfLines = 1
        }
        layout!.activateConstraints(isPortrait: isPortrait)
    }
}
