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
    @IBOutlet weak var navigationBar: NavigationBarView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    
    // Formatting
    private var layout: TreasureHuntCollectionViewViewLayout!
    
    // MARK: Initialization
    override func viewDidLoad() {
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        navigationBar.addBackButton(text: "< Back", action: { self.dismiss(animated: true) })
        navigationBar.setTitle(text: "Treasure Hunts")
        
        layout = TreasureHuntCollectionViewViewLayout(navigationBar: navigationBar, titleLabel: titleLabel, collection: collection)
        layout.configureConstraints(view: view)

        redrawScene()
    }
    
    // MARK: UI
    private func redrawScene() {
        let isPortrait = orientationIsPortrait()
        layout.activateConstraints(isPortrait: isPortrait)
        navigationBar.redrawScene()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collection.collectionViewLayout.invalidateLayout()
        layout.updateCircleSizes()
        redrawScene()
    }
    
    func reloadCell(index: Int) {
        collection.reloadItems(at: [collection.indexPathsForSelectedItems!.first!])
//        layout.updateCircleSizes()
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(getActiveHunts().hunts.count + 1, 2)
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        if getActiveHunts().hunts.isEmpty && indexPath.item == 1 {
            return cell
        }
        switch indexPath.item {
        case 0:
            layout.configureNewHuntCell(cell: cell)
            break
        case 1...getActiveHunts().hunts.count:
            layout.configureTreasureHuntCell(cell: cell, hunt: getActiveHunts().hunts[indexPath.item - 1])
            break
        default:
            fatalError("Dequeued cell with too high index")
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "newHuntSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: "editHuntSegue", sender: self)
        }
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
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "newHuntSegue":
            let newHunt = TreasureHunt()
            getActiveHunts().hunts.append(newHunt)
            didUpdateActiveUser()
            
            let recipient = segue.destination as! EditHuntViewController
            recipient.index = getActiveHunts().hunts.count
            recipient.hunt = newHunt
            recipient.parentController = self
        case "editHuntSegue":
            let recipient = segue.destination as! EditHuntViewController
            let selected = collection.indexPathsForSelectedItems!.first!.item
            recipient.index = selected
            recipient.hunt = getActiveHunts().hunts[selected - 1]
            recipient.parentController = self
        default:
            break
        }
    }
}
