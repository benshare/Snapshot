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
    
    // Other
    private var isFirst = true
    
    // MARK: Initialization
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        layout = MainMenuViewViewLayout(titleLabel: titleLabel, stackView: stackView)
        layout.configureConstraints(view: view)
        configureStackView()
        
        titleLabel.text = "Snapshot"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.backgroundColor = SCENE_COLORS[.main]
    }
    
    private func configureStackView() {
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        stackView.backgroundColor = .darkGray
        stackView.isUserInteractionEnabled = true

        for scene in SCENE_CODES {
            let icon = SCENE_ICONS[scene]!
            let segue = SCENE_SEGUES[scene]!
            
            let row = layout.getRow(icon: icon)
            row.addPermanentTapEvent {
                self.performSegue(withIdentifier: segue, sender: self)
            }
            row.backgroundColor = SCENE_COLORS[scene]
        }
    }
    
    // MARK: UI
    private func redrawScene() {
        let isPortrait = orientationIsPortrait()
        stackView.axis = isPortrait ? .vertical : .horizontal
        layout.activateConstraints(isPortrait: isPortrait)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // No idea why this is necessary lol
        if isFirst && orientationIsPortrait() {
            isFirst = false
        } else {
            isFirst = false
            stackView.removeConstraints(stackView.constraints)
        }
        
        redrawScene()
    }
}
