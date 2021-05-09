//
//  SegmentedTextField.swift
//  Snapshot
//
//  Created by Benjamin Share on 5/8/21.
//

import Foundation
import UIKit

class SegmentedTextField: UIView, UITextFieldDelegate {
    // MARK: Variables
    let controllerField = UITextField()
    private var segmentedFields = [UITextField]()
    private let length: Int
    
    // Formatting
    var layout: SegmentedTextLayout!
    let spacingRatio = 0.3
    
    // MARK: Initialization
    init(length: Int) {
        self.length = length
        super.init(frame: .zero)
        addSubview(controllerField)
        
        fillSegmentedFields(totalWidth: (1 + spacingRatio) * Double(length))
        
        layout = SegmentedTextLayout(controllerField: controllerField, segmentedFields: segmentedFields, spacingRatio: spacingRatio)
        layout.configure(view: self)
        
        controllerField.isOpaque = false
        controllerField.delegate = self
        controllerField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        controllerField.backgroundColor = .clear
        controllerField.textColor = .clear
        controllerField.tintColor = .clear
    }
    
    // '_' is a text box
    // Anything else is a string literal to place in between
    init(segmentPattern: String) {
        var widthsAtIndices: [Double] = [0]
        var l = 0
        var totalWidth: Double = 0
        for char in segmentPattern {
            if char == "_" {
                l += 1
                totalWidth += 1 + spacingRatio
            } else {
                totalWidth += spacingRatio * 2
            }
            widthsAtIndices.append(totalWidth)
        }
        widthsAtIndices[widthsAtIndices.count - 1] = widthsAtIndices.last! - spacingRatio
        
        self.length = l
        super.init(frame: .zero)
        addSubview(controllerField)
        
        fillSegmentedFields(totalWidth: totalWidth)
        
        layout = SegmentedTextLayout(controllerField: controllerField, segmentedFields: segmentedFields, segmentPattern: segmentPattern, widthsAtIndices: widthsAtIndices, parentView: self, spacingRatio: spacingRatio)
        layout.configure(view: self)
        
        controllerField.isOpaque = false
        controllerField.delegate = self
        controllerField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        controllerField.backgroundColor = .clear
        controllerField.textColor = .clear
        controllerField.tintColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fillSegmentedFields(totalWidth: Double) {
        for _ in 0...length - 1 {
            let field = UITextField()
            segmentedFields.append(field)
            addSubview(field)
            field.alpha = 0.5
            field.isUserInteractionEnabled = false
            field.borderStyle = .bezel
            field.adjustsFontSizeToFitWidth = true
            field.layer.cornerRadius = 5
            field.textAlignment = .center
            field.font = UIFont.systemFont(ofSize: CGFloat(130 / totalWidth))
        }
    }
    
    // MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        setCursorToEnd(textField: textField)
        let char = string.cString(using: String.Encoding.utf8)
        if strcmp(char, "\\b") == -92 {
            segmentedFields[textField.text!.count - 1].text = ""
            return true
        }
        return textField.text!.count < length
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.count > 0 {
            for i in 0...textField.text!.count - 1 {
                segmentedFields[i].text = String(controllerField.text![i])
            }
        }
    }
    
    @objc func setCursorToEnd(textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument)
    }
}
