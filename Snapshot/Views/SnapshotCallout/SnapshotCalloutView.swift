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
    private let calloutAspectRatio: Double = 1.618
    
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
    private var previewFrame = UIView()
    private var calloutFrame = UIView()
    var contentView = UIView()

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureView(snapshot: Snapshot, superview: MKAnnotationView, controller: MapViewController) {
        self.snapshot = snapshot
        
        self.frame = superview.frame
        self.controller = controller
        self.isUserInteractionEnabled = true
        
        previewFrame = UIView()
        self.addSubview(previewFrame)
        previewFrame.translatesAutoresizingMaskIntoConstraints = false
        previewFrame.heightAnchor.constraint(equalToConstant: 140).isActive = true
        previewFrame.widthAnchor.constraint(equalToConstant: (140 / 1.6)).isActive = true
        previewFrame.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        previewFrame.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        
        calloutFrame = UIView()
        self.addSubview(calloutFrame)
        calloutFrame.translatesAutoresizingMaskIntoConstraints = false
        calloutFrame.heightAnchor.constraint(equalToConstant: 350).isActive = true
        calloutFrame.widthAnchor.constraint(equalToConstant: (350 / 1.6)).isActive = true
        calloutFrame.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        calloutFrame.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        
        contentView = UIView()
        self.addSubview(contentView)
        NSLayoutConstraint.deactivate(contentView.constraints)
        contentView.alpha = 0
        addFrame(imageView: contentView)
        
        snapshotTitle.text = snapshot.title ?? ""
        snapshotTitle.placeholder = "Untitled"
        snapshotTitle.delegate = self as UITextFieldDelegate
        snapshotTitle.adjustsFontSizeToFitWidth = true
        snapshotTitle.autocapitalizationType = .words
        snapshotTitle.autocorrectionType = .yes
        contentView.addSubview(snapshotTitle)
        date.text = snapshot.time.toString(format: .monthDayYear)
        contentView.addSubview(date)

        image.image = snapshot.image ?? UIImage(named: "ClickToAdd")
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewFullImage)))
        image.isUserInteractionEnabled = true
        contentView.addSubview(image)

        expandButton.setTitle("Expand", for: .normal)
        contentView.addSubview(expandButton)

        information.text = snapshot.information
        contentView.addSubview(information)

        layout = SnapshotCalloutViewLayout(snapshotTitle: snapshotTitle, date: date, image: image, expandButton: expandButton, information: information)
        layout.configureConstraints(view: contentView)
        layout.activateConstraints(isPortrait: orientationIsPortrait())
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
    
    // MARK: Animation
    func displayCallout() {
        self.isHidden = false
        self.contentView.frame = self.previewFrame.frame
        self.contentView.layoutSubviews()
        UIView.animate(withDuration: 0.7, animations: {
            self.contentView.frame = self.calloutFrame.frame
            self.contentView.alpha = 1
            self.contentView.layoutSubviews()
        })
    }
    
    func hideCallout() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.frame = self.previewFrame.frame
            self.contentView.alpha = 0
            self.contentView.layoutSubviews()
        }, completion: { _ in self.isHidden = true })
    }
}

