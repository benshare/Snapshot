//
//  FullClueLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/9/21.
//

import Foundation
import UIKit

class FullClueLayout {
    // MARK: Properties
    
    // UI elements
    private let portraitContentView: UIView
    private let landscapeContentView: UIView
    private let portraitTitle: UILabel
    private let landscapeTitle: UILabel
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    // Other
    let parentController: UIViewController
    var portraitButtons = [UIButton]()
    var landscapeButtons = [UIButton]()
    
    // MARK: Initialization
    init(parentController: UIViewController, clueText: String, clueImage: UIImage?, hints: [String]) {
        self.parentController = parentController
        portraitContentView = UIView()
        landscapeContentView = UIView()
        self.portraitTitle = UILabel()
        self.landscapeTitle = UILabel()
        
        // Add elements to content view
        // Portrait
        let portraitStackView = UIStackView()
        portraitStackView.distribution = .equalSpacing
        portraitStackView.axis = .vertical
        portraitContentView.addSubview(portraitStackView)
        
        let portraitClue = UILabel()
        portraitClue.text = clueText
        portraitClue.numberOfLines = 0
        
        let portraitImage = clueImage == nil ? nil : UIImageView(image: clueImage)
        portraitImage?.contentMode = .scaleAspectFit
        
        let portraitHint = hints.isEmpty ? nil : UIStackView()
        if portraitHint != nil {
            portraitHint!.axis = .horizontal
            for view in getButtonsForHints(hints: hints) {
                portraitHint!.addArrangedSubview(view)
                portraitButtons.append(view.subviews[0] as! UIButton)
            }
        }
        
        // Landscape
        let landscapeStackView = UIStackView()
        landscapeStackView.distribution = .equalSpacing
        landscapeStackView.axis = .horizontal
        landscapeContentView.addSubview(landscapeTitle)
        landscapeContentView.addSubview(landscapeStackView)
        
        let landscapeClue = UILabel()
        landscapeClue.text = clueText
        landscapeClue.numberOfLines = 0
//        landscapeClue.font = UIFont.systemFont(ofSize: 10)
        
        let landscapeImage = clueImage == nil ? nil : UIImageView(image: clueImage)
        landscapeImage?.contentMode = .scaleAspectFit
        
        let landscapeHint = hints.isEmpty ? nil : UIStackView()
        if landscapeHint != nil {
            landscapeHint!.axis = .vertical
            for view in getButtonsForHints(hints: hints) {
                landscapeHint!.addArrangedSubview(view)
                landscapeButtons.append(view.subviews[0] as! UIButton)
            }
        }
        
        // Set UI defaults
        doNotAutoResize(views: [portraitContentView, landscapeContentView, portraitStackView, landscapeStackView, portraitTitle, landscapeTitle, portraitClue, landscapeClue])
        if clueImage != nil {
            doNotAutoResize(views: [portraitImage!, landscapeImage!])
        }
        if !hints.isEmpty {
            doNotAutoResize(views: [portraitHint!, landscapeHint!])
        }
        setLabelsToDefaults(labels: [portraitTitle, landscapeTitle, portraitClue, landscapeClue])
        
        // Determine spacing
        // Portrait
        let totalContentHeight: CGFloat = 0.8
        let titleUnits = 2
        var textUnits = 6
        var imageUnits = 6
        var hintUnits = 3
        
        var heightUnits = 0
        
        portraitStackView.addArrangedSubview(getRowForCenteredView(view: portraitTitle))
        heightUnits += titleUnits
        portraitStackView.addArrangedSubview(getRowForCenteredView(view: portraitClue))
        heightUnits += textUnits
        if portraitImage != nil {
            portraitStackView.addArrangedSubview(getRowForCenteredView(view: portraitImage!))
            heightUnits += imageUnits
        }
        if portraitHint != nil {
            portraitStackView.addArrangedSubview(getRowForCenteredView(view: portraitHint!))
            heightUnits += hintUnits
        }
        
        let titleHeight = CGFloat(titleUnits) * totalContentHeight / CGFloat(heightUnits)
        let clueHeight = CGFloat(textUnits) * totalContentHeight / CGFloat(heightUnits)
        let imageHeight = CGFloat(imageUnits) * totalContentHeight / CGFloat(heightUnits)
        let hintHeight = CGFloat(hintUnits) * totalContentHeight / CGFloat(heightUnits)
        
        portraitSizeMap = [
            portraitStackView: (1, 0.9),
            portraitTitle: (CGFloat(0.6), titleHeight),
            portraitClue: (CGFloat(0.8), clueHeight),
        ]
        
        portraitSpacingMap = [
            portraitStackView: (0.5, 0.5),
        ]
        
        if clueImage != nil {
            portraitSizeMap[portraitImage!] = (0.6, imageHeight)
        }
        
        if !hints.isEmpty {
            let numRows = portraitHint!.arrangedSubviews.count
            for wrapper in portraitHint!.arrangedSubviews {
                let button = wrapper.subviews[0] as! UIButton
                doNotAutoResize(views: [wrapper, button])
                setButtonsToDefaults(buttons: [button], withInsets: 5)
                NSLayoutConstraint.activate([
                    button.widthAnchor.constraint(equalTo: wrapper.widthAnchor, multiplier: 0.8),
                    button.heightAnchor.constraint(equalTo: wrapper.heightAnchor, multiplier: 0.8),
                    button.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor),
                    button.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor),
                ])
                portraitSizeMap[wrapper] = (0.2, hintHeight / CGFloat(numRows))
            }
        }
        
        // Landscape
        let totalContentWidth: CGFloat = 0.7
        textUnits = 3
        imageUnits = 3
        hintUnits = 1
        
        var widthUnits = 0
        
        landscapeStackView.addArrangedSubview(getColumnForCenteredView(view: landscapeClue, withBuffer: 5))
        widthUnits += textUnits
        if clueImage != nil {
            landscapeStackView.addArrangedSubview(getColumnForCenteredView(view: landscapeImage!))
            widthUnits += imageUnits
        }
        if !hints.isEmpty {
            landscapeStackView.addArrangedSubview(getColumnForCenteredView(view: landscapeHint!))
            widthUnits += hintUnits
        }

        let imageWidth = CGFloat(imageUnits) * totalContentWidth / CGFloat(widthUnits)
        
        landscapeSizeMap = [
            landscapeTitle: (0.6, 0.3),
            landscapeStackView: (0.85, 0.5),
        ]
        landscapeConstraints.append(landscapeClue.heightAnchor.constraint(equalTo: landscapeStackView.heightAnchor, multiplier: 0.6))
        
        landscapeSpacingMap = [
            landscapeTitle: (0.5, 0.15),
            landscapeStackView: (0.5, 0.65),
        ]
        
        if clueImage != nil {
            landscapeSizeMap[landscapeImage!] = (imageWidth, 0.7)
        }
        
        if !hints.isEmpty {
            for wrapper in landscapeHint!.arrangedSubviews {
                let button = wrapper.subviews[0] as! UIButton
                doNotAutoResize(views: [wrapper, button])
                setButtonsToDefaults(buttons: [button], withInsets: 5)
                NSLayoutConstraint.activate([
                    button.widthAnchor.constraint(equalTo: wrapper.widthAnchor, multiplier: 0.8),
                    button.heightAnchor.constraint(equalTo: wrapper.heightAnchor, multiplier: 0.8),
                    button.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor),
                    button.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor),
                ])
                landscapeSizeMap[wrapper] = (0.12, 0.1)
            }
        }
    }
    
    // MARK: Constraints
    func configureConstraints(view: UIView)  {
        view.backgroundColor = .white
        view.addSubview(portraitContentView)
        view.addSubview(landscapeContentView)
        
        NSLayoutConstraint.activate([
            portraitContentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            portraitContentView.heightAnchor.constraint(equalTo: view.heightAnchor),
            portraitContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            portraitContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            landscapeContentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            landscapeContentView.heightAnchor.constraint(equalTo: view.heightAnchor),
            landscapeContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            landscapeContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        portraitConstraints += getSizeConstraints(widthAnchor: portraitContentView.widthAnchor, heightAnchor: portraitContentView.heightAnchor, sizeMap: portraitSizeMap)
        portraitConstraints += getSpacingConstraints(leftAnchor: portraitContentView.leftAnchor, widthAnchor: portraitContentView.widthAnchor, topAnchor: portraitContentView.topAnchor, heightAnchor: portraitContentView.heightAnchor, spacingMap: portraitSpacingMap, parentView: portraitContentView)
        
        landscapeConstraints += getSizeConstraints(widthAnchor: landscapeContentView.widthAnchor, heightAnchor: landscapeContentView.heightAnchor, sizeMap: landscapeSizeMap)
        landscapeConstraints += getSpacingConstraints(leftAnchor: landscapeContentView.leftAnchor, widthAnchor: landscapeContentView.widthAnchor, topAnchor: landscapeContentView.topAnchor, heightAnchor: landscapeContentView.heightAnchor, spacingMap: landscapeSpacingMap, parentView: landscapeContentView)
        
        NSLayoutConstraint.activate(portraitConstraints)
        NSLayoutConstraint.activate(landscapeConstraints)
    }
    
    func setOrientation(isPortrait: Bool) {
        if isPortrait {
            landscapeContentView.isHidden = true
            NSLayoutConstraint.deactivate(landscapeConstraints)
            portraitContentView.isHidden = false
            NSLayoutConstraint.activate(portraitConstraints)
        } else {
            portraitContentView.isHidden = true
            NSLayoutConstraint.deactivate(portraitConstraints)
            landscapeContentView.isHidden = false
            NSLayoutConstraint.activate(landscapeConstraints)
        }
    }
    
    // MARK: Hints
    private func getButtonsForHints(hints: [String]) -> [UIView] {
        var hintViews = [UIView]()
        let lastHint = hints.count - 1
        for i in 0...lastHint {
            let hintButton = UIButton()
            hintButton.setTitle("Hint \(i + 1)", for: .normal)
            hintButton.setTitleColor(.black, for: .normal)
            hintButton.backgroundColor = .lightGray
            hintButton.layer.cornerRadius = 5
            if i > 0 {
                hintButton.isEnabled = false
                hintButton.alpha = 0.3
            }
            
            let buttonWrapper = UIView()
            buttonWrapper.backgroundColor = .white
            buttonWrapper.addSubview(hintButton)
            hintViews.append(buttonWrapper)
        }
        for i in 0...lastHint {
            let currentButton = hintViews[i].subviews[0] as! UIButton
            currentButton.addAction { [self] in
                let alert = UIAlertController(title: "Hint \(i + 1)", message: hints[i], preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: {_ in
                    alert.dismiss(animated: true, completion: {})
                }))
                parentController.present(alert, animated: true, completion: {})
                if i < lastHint {
                    portraitButtons[i + 1].isEnabled = true
                    portraitButtons[i + 1].alpha = 1
                    landscapeButtons[i + 1].isEnabled = true
                    landscapeButtons[i + 1].alpha = 1
                }
            }
        }
        return hintViews
    }
    
    // MARK: Other UI
    func setTitleLabel(text: String) {
        portraitTitle.text = text
        landscapeTitle.text = text
    }
    
    func setTitleLines(lines: Int) {
        portraitTitle.numberOfLines = lines
        landscapeTitle.numberOfLines = lines
    }
}
