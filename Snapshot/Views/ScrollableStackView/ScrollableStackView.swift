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
    private let contentView: UIStackView
    
    private var portraitConstraints: [NSLayoutConstraint]!
    private var landscapeConstraints: [NSLayoutConstraint]!
    
    // MARK: Initialization
    required init?(coder: NSCoder) {
        contentView = UIStackView()
        super.init(coder: coder)
        
        self.addSubview(contentView)
        doNotAutoResize(view: contentView)
        
        portraitConstraints = [
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: self.widthAnchor),
        ]
        landscapeConstraints = [
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.leftAnchor.constraint(equalTo: self.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: self.rightAnchor),
            contentView.heightAnchor.constraint(equalTo: self.heightAnchor),
        ]
        setAxis(axis: .vertical)
        contentView.alignment = .fill
        contentView.distribution = .equalSpacing
        contentView.spacing = 0
    }
    
    init() {
        contentView = UIStackView()
        super.init(frame: CGRect.zero)
        
        self.addSubview(contentView)
        doNotAutoResize(view: contentView)
        portraitConstraints = [
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: self.widthAnchor),
        ]
        landscapeConstraints = [
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.leftAnchor.constraint(equalTo: self.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: self.rightAnchor),
            contentView.heightAnchor.constraint(equalTo: self.heightAnchor),
        ]
        
        setAxis(axis: .vertical)
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
    
    func arrangedViews() -> [UIView] {
        return contentView.arrangedSubviews
    }
    
    // Set
    func addToStack(view: UIView) {
        contentView.addArrangedSubview(view)
    }
    
    func insertInStack(view: UIView, index: Int) {
        contentView.insertArrangedSubview(view, at: index)
    }
    
    func removeFromStack(index: Int, temporary: Bool = false) {
        let row = contentView.arrangedSubviews[index]
        contentView.removeArrangedSubview(row)
        if !temporary {
            row.removeFromSuperview()
        }
    }
    
    func removeFromStack(view: UIView) {
        contentView.removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    // MARK: Stack Formatting
    func addBorders(width: Int = 2, color: UIColor = .gray) {
        contentView.spacing = CGFloat(width)
        contentView.backgroundColor = color
    }
    
    func setAxis(axis: NSLayoutConstraint.Axis) {
        contentView.axis = axis
        if axis == .vertical {
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
        } else {
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
        }
    }
    
    func distribution() -> UIStackView.Distribution {
        return contentView.distribution
    }
    
    func setDistribution(dist: UIStackView.Distribution) {
        contentView.distribution = dist
    }
    
    // MARK: Event Handling
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for view in contentView.arrangedSubviews {
            let p = view.convert(point, from: contentView)
            if view.hitTest(p, with: event) != nil {
                return view.hitTest(p, with: event)
            }
        }
        return nil
    }
}
