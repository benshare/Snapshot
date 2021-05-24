//
//  TreasureHuntCollectionViewController.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/28/21.
//

import Foundation
import UIKit

private let reuseIdentifier = "HuntCell"
private let SECTION_LIST = [UserCodingAttributes.privateHunts, .sharedHunts]

class TreasureHuntCollectionViewController: UIViewController, UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout {
    
    // MARK: Variables
    // Outlets
    @IBOutlet weak var navigationBar: NavigationBarView!
    private var headerView = ScrollableStackView()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    
    // Formatting
    private var layout: TreasureHuntCollectionViewViewLayout!
    
    // Other
    private var popup: PopupOptionsView?
    private var popupDismissView: UIView!
    private var currentSection: UserCodingAttributes = .privateHunts
    
    // MARK: Initialization
    override func viewDidLoad() {
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        navigationBar.addPermanentTapEvent {
            self.popup?.removeFromSuperview()
        }
        popupDismissView = UIView(frame: collection.frame)
        popupDismissView.addPermanentTapEvent {
            self.popup?.removeFromSuperview()
        }
        collection.addSubview(popupDismissView)
        
        navigationBar.addBackButton(text: "< Back", action: { self.dismiss(animated: true) }, color: .white)
        navigationBar.setTitle(text: "Treasure Hunts", color: .white)
        navigationBar.backgroundColor = SCENE_COLORS[.hunts]
        
        view.addSubview(headerView)
        headerView.setAxis(axis: .horizontal)
        headerView.setDistribution(dist: .equalSpacing)
        
        layout = TreasureHuntCollectionViewViewLayout(navigationBar: navigationBar, headerView: headerView, titleLabel: titleLabel, collection: collection, sharedIsEmpty: activeUser.sharedHunts.hunts.isEmpty)
        layout.configureConstraints(view: view)
        
        for ind in 0...headerView.arrangedViews().count - 1 {
            let header = headerView.arrangedViews()[ind]
            header.addPermanentTapEvent { [self] in
                selectSection(ind: ind)
            }
        }
        layout.selectSection(section: 0)

        redrawScene()
    }
    
    // MARK: UI
    func redrawScene() {
        let isPortrait = orientationIsPortrait()
        layout.activateConstraints(isPortrait: isPortrait)
        navigationBar.redrawScene()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout.updateCircleSizes()
        redrawScene()
    }
    
    func reloadData() {
        collection.reloadData()
    }
    
    private func currentHunts() -> TreasureHuntCollection {
        return [activeUser.privateHunts, activeUser.sharedHunts][SECTION_LIST.firstIndex(of: currentSection)!]
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(currentHunts().hunts.count, 2)
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let current = currentHunts()
        switch currentSection {
        case .privateHunts:
            if current.hunts.isEmpty && indexPath.item == 1 {
                return cell
            }
            switch indexPath.item {
            case 0:
                layout.configureNewHuntCell(cell: cell)
                break
            case 1...current.hunts.count:
                layout.configureTreasureHuntCell(cell: cell, hunt: current.hunts[indexPath.item - 1])
                break
            default:
                fatalError("Dequeued cell with too high index")
            }
        case .sharedHunts:
            if current.hunts.isEmpty {
                return cell
            }
            layout.configureTreasureHuntCell(cell: cell, hunt: current.hunts[indexPath.item - 1])
        default:
            break
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentSection == .privateHunts && indexPath.row == 0 {
            self.performSegue(withIdentifier: "newHuntSegue", sender: self)
            return
        }
        if currentHunts().hunts.isEmpty {
            return
        }
        displayOptionsForHunt()
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
    
    // MARK: Selection
    private func displayOptionsForHunt() {
        popup?.removeFromSuperview()
        let selected = collection.indexPathsForSelectedItems!.first!
        let current = currentHunts()
        
        popup = PopupOptionsView(color: SCENE_COLORS[.hunts]!)
        view.addSubview(popup!)
        popup!.addButton(name: "Play", callback: {
            self.performSegue(withIdentifier: "playHuntSegue", sender: self)
            self.popup!.removeFromSuperview()
        }, isEnabled: current.hunts[selected.item - 1].clues.count > 2)
        popup!.addButton(name: "Edit", callback: {
            self.performSegue(withIdentifier: "editHuntSegue", sender: self)
            self.popup!.removeFromSuperview()
        })
        popup!.addButton(name: "Delete", callback: {
            self.displayDeleteAlert()
            self.popup!.removeFromSuperview()
        })
        popup!.configureView()
        popup!.anchorToView(anchorView: collection.cellForItem(at: collection.indexPathsForSelectedItems!.first!)!, superview: view)
    }
    
    // MARK: Deletion
    private func displayDeleteAlert() {
        let alert = UIAlertController(title: "Confirm Delete", message: "Permanently delete treasure hunt?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {
                action in
                self.deleteHunt()
                alert.dismiss(animated: true, completion: nil)
            }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in alert.dismiss(animated: true, completion: nil) }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func deleteHunt() {
        let path = self.collection.indexPathsForSelectedItems!.first!
        let current = currentHunts()
        current.hunts.remove(at: path.item - 1)
        syncActiveUser(attribute: currentSection)
        collection.deleteItems(at: [path])
        collection.reloadData()
    }
    
    // MARK: Sections
    private func selectSection(ind: Int) {
        if currentSection == SECTION_LIST[ind] {
            return
        }
        layout.selectSection(section: ind)
        currentSection = SECTION_LIST[ind]
        reloadData()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let current = currentHunts()
        switch segue.identifier {
        case "newHuntSegue":
            let newHunt = TreasureHunt()
            current.hunts.append(newHunt)
            popup?.removeFromSuperview()
            
            let recipient = segue.destination as! EditHuntViewController
            recipient.index = current.hunts.count
            recipient.hunt = newHunt
            recipient.parentController = self
        case "editHuntSegue":
            let recipient = segue.destination as! EditHuntViewController
            let selected = collection.indexPathsForSelectedItems!.first!.item
            recipient.index = selected
            recipient.hunt = current.hunts[selected - 1]
            recipient.parentController = self
        case "playHuntSegue":
            let recipient = segue.destination as! TreasureHuntPlayViewController
            let selected = collection.indexPathsForSelectedItems!.first!.item
            recipient.playthrough = TreasureHuntPlaythrough(hunt: current.hunts[selected - 1])
        default:
            break
        }
    }
}
