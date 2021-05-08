//
//  CollectionRowView.swift
//  Snapshot
//
//  Created by Benjamin Share on 5/7/21.
//

import Foundation
import UIKit

class CollectionRowView: UIView {
    private var layout: CollectionRowLayout
    let indexInCollection: Int
    var indexInList: Int
    
    // MARK: Initialization
    init(snapshot: Snapshot, indexInCollection: Int, indexInList: Int, buttonCallback: @escaping (Int, Int) -> ()) {
        let image = UIImageView()
        let description = UILabel()
        let subrow = UIView()
        let creatorLabel = UILabel()
        let dateLabel = UILabel()
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        let deleteButton = UIButton()
        
        layout = CollectionRowLayout(image: image, description: description, creatorLabel: creatorLabel, dateLabel: dateLabel, blurView: blurView, deleteButton: deleteButton)
        self.indexInCollection = indexInCollection
        self.indexInList = indexInList
        
        super.init(frame: .zero)
        
        addSubview(image)
        addSubview(description)
        addSubview(subrow)
        subrow.addSubview(creatorLabel)
        subrow.addSubview(dateLabel)
        addSubview(blurView)
        addSubview(deleteButton)
        
        image.image = snapshot.image
        description.text = (snapshot.title ?? "").isEmpty ? "No title" : snapshot.title!
        description.numberOfLines = 0
        description.font = UIFont.italicSystemFont(ofSize: 20)
        creatorLabel.text = "Created by: you"
        dateLabel.text = "Added on \(snapshot.time.toString(format: .monthDay))"
        
        if #available(iOS 13.0, *) {
            deleteButton.setImage(UIImage(named: "TrashIcon")?.withTintColor(.white), for: .normal)
        } else {
            deleteButton.setImage(UIImage(named: "TrashIcon"), for: .normal)
        }
        deleteButton.addAction({
            buttonCallback(self.indexInCollection, self.indexInList)
        })
        blurView.alpha = 0.7
        
        deleteButton.isHidden = true
        blurView.isHidden = true
        
        layout.configureConstraints(view: self)
        redrawScene()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func redrawScene() {
        let isPortrait = orientationIsPortrait()
        layout.activateConstraints(isPortrait: isPortrait)
    }
    
    // MARK: Actions
    func showDeleteButtons() {
        layout.showDeleteButtons()
    }
    
    func hideDeleteButtons() {
        layout.hideDeleteButtons()
    }
}
