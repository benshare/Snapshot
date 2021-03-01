//
//  TreasureHuntCollectionViewController.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/28/21.
//

import Foundation
import UIKit

private let reuseIdentifier = "HuntCell"

class TreasureHuntCollectionViewController: UIViewController, UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout {
    
//    var description: String
    
    // MARK: Variables
    // Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    
    // Formatting
    private var layout: TreasureHuntCollectionViewViewLayout!
    
    // MARK: Initialization
    override func viewDidLoad() {
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        layout = TreasureHuntCollectionViewViewLayout(backButton: backButton, titleLabel: titleLabel, collection: collection)
        layout.configureConstraints(view: view)
        configureCollectionView()
        redrawScene()
        
        backButton.addAction {
            self.dismiss(animated: true)
        }
    }
    
    private func configureCollectionView() {
        collection.backgroundColor = .lightGray
    }
    
    // MARK: UI
    private func redrawScene() {
        let isPortrait = orientationIsPortrait()
        layout.activateConstraints(isPortrait: isPortrait)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collection.collectionViewLayout.invalidateLayout()
        layout.updateCircleSizes()
        redrawScene()
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
        return getActiveHunts().hunts.count + 1
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .red
        layout.configureTreasureHuntCell(cell: cell)
//        switch indexPath.item {
//        case 0:
//            layout.configureNewHuntCell(cell: cell)
//        case 1...getActiveHunts().hunts.count:
//            break
//        default:
//            fatalError("Dequeued cell with too high index")
//        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("User tapped on item \(indexPath.row)")
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let s = min(view.frame.width, view.frame.height)
        return CGSize(width: 0.45 * s, height: 0.45 * s)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let s = 0.45 * min(view.frame.width, view.frame.height)
        let numItems = Int(collection.frame.width / s)
        let spacing = CGFloat(collection.frame.width - s * CGFloat(numItems)) / CGFloat(numItems - 1)
        return spacing
    }
}
