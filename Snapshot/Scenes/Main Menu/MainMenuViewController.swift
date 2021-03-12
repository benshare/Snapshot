//
//  MainMenuViewController.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/28/21.
//

import Foundation
import UIKit

class MainMenuViewController: UIViewController {
    // MARK: Variables
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    // Formatting
    private var layout: MainMenuViewViewLayout!
    
    // MARK: Initialization
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        layout = MainMenuViewViewLayout(titleLabel: titleLabel, stackView: stackView)
        layout.configureConstraints(view: view)
        configureStackView()
        redrawScene()
    }
    
    private func configureStackView() {
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        stackView.isUserInteractionEnabled = true

        for scene in SCENES {
            let icon = SCENE_ICONS[scene]!
            let segue = SCENE_SEGUES[scene]!
            
            let rowView = UIView()
            stackView.addArrangedSubview(rowView)
            rowView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
            rowView.backgroundColor = .white
            
            addIconToView(view: rowView, name: icon)
            rowView.addPermanentTapEvent {
                self.performSegue(withIdentifier: segue, sender: self)
            }
        }
        
    }
    
    // MARK: UI
    func redrawScene() {
        layout.activateConstraints(isPortrait: orientationIsPortrait())
    }
}
