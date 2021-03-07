//
//  ScrollableStackView.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/1/21.
//

import Foundation
import UIKit

class ScrollableStackView: UIScrollView {
    // MARK: Variables
    let contentView: UIStackView
    
    // MARK: Initialization
    required init?(coder: NSCoder) {
        contentView = UIStackView()
        super.init(coder: coder)
        
        self.addSubview(contentView)
        doNotAutoResize(view: contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
        
        contentView.axis = .vertical
        contentView.alignment = .fill
        contentView.distribution = .equalSpacing
        contentView.spacing = 0
        
    }
    
    // MARK: Stack Operations
    // Get
    func count() -> Int {
        return contentView.arrangedSubviews.count
    }
    
    func elementAtIndex(index: Int) -> UIView {
        return contentView.arrangedSubviews[index]
    }
    
    // Set
    func addToStack(view: UIView) {
        contentView.addArrangedSubview(view)
    }
    
    func insertInStack(view: UIView, index: Int) {
        contentView.insertArrangedSubview(view, at: index)
    }
    
    func removeFromStack(view: UIView) {
        contentView.removeArrangedSubview(view)
    }
    
    // MARK: Stack Formatting
    func addBorders(width: Int = 2, color: UIColor = .gray) {
        contentView.spacing = CGFloat(width)
        contentView.backgroundColor = color
    }
    
    // MARK: Event Handling
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("Main hittest")
        for view in contentView.arrangedSubviews {
            if view.hitTest(point, with: event) != nil {
                return view
            }
        }
        print("Couldn't find")
        return nil
    }
}
