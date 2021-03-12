//
//  ControlUtil.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/28/21.
//

import Foundation
import UIKit

@objc class ClosureSleeve: NSObject {
    let closure: ()->()

    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }

    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIView {
    private func addTapEvent(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->(), oneTime: Bool) {
        let button = UIButton()
        button.accessibilityIdentifier = "tapEventTrigger"
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: self.widthAnchor),
            button.heightAnchor.constraint(equalTo: self.heightAnchor),
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        button.addAction(closure)
        if oneTime {
            button.addAction {
                button.removeFromSuperview()
            }
        }
    }
    
    func addPermanentTapEvent(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->()) {
        self.addTapEvent(for: controlEvents, closure, oneTime: false)
    }
    
    func addOneTimeTapEvent(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->()) {
        self.addTapEvent(for: controlEvents, closure, oneTime: true)
    }
    
    func removeTapEvent() {
        for subview in subviews {
            if subview.accessibilityIdentifier == "tapEventTrigger" {
                subview.removeFromSuperview()
                break
            }
        }
    }
}
