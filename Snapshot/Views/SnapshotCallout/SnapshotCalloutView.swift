//
//  SnapshotCalloutView.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/23/21.
//

import Foundation
import UIKit
import MapKit

class SnapshotCalloutView: UIView, UITextFieldDelegate {
    // MARK: Variables
    // UI Elements
    private let snapshotTitle = UITextField()
    private let date = UILabel()
    let image = UIImageView()
    private var expandButton = UIButton()
    private var information = UITextField()
//    private let tags = TagsView()

    // Data
    var snapshot: Snapshot!
    var controller: MapViewController!

    // Formatting
    private var layout: SnapshotCalloutViewLayout!

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureView(snapshot: Snapshot, superview: MKAnnotationView, controller: MapViewController) {
        self.snapshot = snapshot
        
        snapshotTitle.text = snapshot.title ?? ""
        snapshotTitle.placeholder = "Untitled"
        snapshotTitle.delegate = self as UITextFieldDelegate
        snapshotTitle.adjustsFontSizeToFitWidth = true
        snapshotTitle.autocapitalizationType = .words
        snapshotTitle.autocorrectionType = .yes
        self.addSubview(snapshotTitle)

        date.text = DATE_FORMATS.monthDayYear(date: snapshot.time)
        self.addSubview(date)

        image.image = snapshot.image ?? UIImage(named: "ClickToAdd")
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewFullImage)))
        image.isUserInteractionEnabled = true
        self.addSubview(image)

        expandButton.setTitle("Expand", for: .normal)
        self.addSubview(expandButton)

        information.text = snapshot.information
        self.addSubview(information)

        layout = SnapshotCalloutViewLayout(snapshotTitle: snapshotTitle, date: date, image: image, expandButton: expandButton, information: information)
        layout.configureConstraints(view: self)
        layout.activateConstraints(isPortrait: orientationIsPortrait())
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 350).isActive = true
        self.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -100).isActive = true
        addFrame(imageView: self)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing(_:))))
        
        self.controller = controller
    }

    func redrawScene(isPortrait: Bool) {
        layout.activateConstraints(isPortrait: isPortrait)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        snapshot.title = snapshotTitle.text
    }
    
    // MARK: Image
    @objc func viewFullImage() {
        controller.viewFullImage(calloutView: self)
    }
}

