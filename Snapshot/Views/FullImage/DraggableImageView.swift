//
//  DraggableImageView.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/25/21.
//

import Foundation
import UIKit

class FullImageView: UIView {
    let imageView = UIImageView()
    let editButton = UIButton()
    var parentCenter = CGPoint()
    
    init() {
        super.init(frame: CGRect())
    }
    
    func configureView(image: UIImage, parentView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalTo: parentView.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: parentView.heightAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
        self.backgroundColor = .black
        
        let imageView = UIImageView()
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        let editButton = UIButton()
        self.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        editButton.centerXAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        editButton.centerYAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        editButton.setImage(UIImage(named: "EditIcon"), for: .normal)
        editButton.contentMode = .scaleAspectFit
        editButton.backgroundColor = .lightGray
        editButton.alpha = 0.7
        makeViewCircular(view: editButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
