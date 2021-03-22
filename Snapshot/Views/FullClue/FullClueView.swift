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
    let hintView: UIStackView?
    
    // Formatting
    var layout: FullClueLayout!
    
    // Other
    let clue: Clue
    var nonEmptyHints = [String]()
    let parentController: UIViewController
    
    // MARK: Initialization
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(clue: Clue, parentController: UIViewController) {
        self.clue = clue
        self.parentController = parentController
        titleLabel = UILabel()
        clueText = UILabel()
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
        if hintView != nil {
            addSubview(hintView!)
        }
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 10
        
        titleLabel.text = isNew ? "You unlocked\na new clue!" : "Clue #\(clueNum!)"
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 25)

        clueText.text = clue.text
        clueText.numberOfLines = 0
        
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
                        let nextHint = hintView?.arrangedSubviews[i + 1] as! UIButton
                        nextHint.isEnabled = true
                        nextHint.alpha = 1
                    }
                }
                if i > 0 {
                    hintButton.isEnabled = false
                    hintButton.alpha = 0.3
                }
                
                hintView!.addArrangedSubview(hintButton)
            }
            
            hintView!.axis = .vertical
            hintView!.spacing = 8
        }
        
        layout = FullClueLayout(titleLabel: titleLabel, clueText: clueText, hintView: hintView)
        layout.configureConstraints(view: self)
        
        redrawScene()
    }
    
    // MARK: UI
    func redrawScene() {
        let isPortrait = orientationIsPortrait()
        layout!.activateConstraints(isPortrait: isPortrait)
    }
}

class CluePlaythrough {
    var nonEmptyHints = [String]()
    let currentHint = 0
    
    init(clue: Clue) {
        for hint in clue.hints {
            if !hint.isEmpty {
                nonEmptyHints.append(hint)
            }
        }
    }
}
