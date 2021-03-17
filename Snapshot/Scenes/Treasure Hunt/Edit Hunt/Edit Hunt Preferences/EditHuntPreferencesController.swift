//
//  EditHuntPreferencesController.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/15/21.
//

import Foundation
import UIKit
import MapKit

private let styleValues = ["Virtual"]
private let sensitivityValues = (1...20).map( { String($0 * 10) + "%" })
private let designValues = ["Classic"]


class EditHuntPreferencesController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Variables
    // Outlets
    @IBOutlet weak var navigationBar: NavigationBarView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: ScrollableStackView!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var stylePicker: UIPickerView!
    @IBOutlet weak var sensitivityLabel: UILabel!
    @IBOutlet weak var sensitivityPicker: UIPickerView!
    @IBOutlet weak var sensitivityPreview: MKMapView!
    @IBOutlet weak var designLabel: UILabel!
    @IBOutlet weak var designPicker: UIPickerView!
    
    // Formatting
    private var layout: EditHuntPreferencesLayout!
    
    // Data
    var hunt: TreasureHunt!
    
    // MARK: Initialization
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    override func viewDidLoad() {
        layout = EditHuntPreferencesLayout(navigationBar: navigationBar, titleLabel: titleLabel, scrollView: scrollView, styleLabel: styleLabel, stylePicker: stylePicker, sensitivityLabel: sensitivityLabel, sensitivityPicker: sensitivityPicker, sensitivityPreview: hunt.clues.first == nil ? nil : sensitivityPreview, designLabel: designLabel, designPicker: designPicker)
        layout.configureConstraints(view: view)
        
        navigationBar.addBackButton(text: "< Back", action: {
            didUpdateActiveUser()
            self.dismiss(animated: true)
        })
        navigationBar.setTitle(text: hunt.name)
        view.bringSubviewToFront(navigationBar)
        
        styleLabel.text = "Hunt style:"
        styleLabel.addInformationButton(title: "Hunt style", content: "This controls how people play your hunt. Real world option coming soon!", controller: self)
        stylePicker.dataSource = self
        stylePicker.delegate = self
        
        sensitivityLabel.text = "Clue sensitivity:"
        sensitivityLabel.addInformationButton(title: "Clue sensitivity", content: "How close does someone need to be to find a clue? The smaller the number, the closer they need to be.", controller: self)
        sensitivityPicker.dataSource = self
        sensitivityPicker.delegate = self
        
        sensitivityPicker.selectRow(sensitivityValues.firstIndex(of: radiusToString(radius: hunt.clueRadius))!, inComponent: 0, animated: false)
        if let first = hunt.clues.first {
            setPreviewRegion(first: first)
            let annotation = MKPointAnnotation()
            annotation.coordinate = first.location
            sensitivityPreview.addAnnotation(annotation)
            
            let target = UIImageView(image: UIImage(named: "TargetIcon"))
            target.alpha = 0.6
            doNotAutoResize(view: target)
            sensitivityPreview.addSubview(target)
            NSLayoutConstraint.activate([
                target.centerXAnchor.constraint(equalTo: sensitivityPreview.centerXAnchor),
                target.centerYAnchor.constraint(equalTo: sensitivityPreview.centerYAnchor),
                target.widthAnchor.constraint(equalTo: sensitivityPreview.widthAnchor),
                target.heightAnchor.constraint(equalTo: sensitivityPreview.heightAnchor),
            ])
        } else {
            sensitivityPreview.isHidden = true
        }
        
        designLabel.text = "Editing mode:"
        designLabel.addInformationButton(title: "Editing mode", content: "What mode you use for creating + editing hunts. More options coming soon!", controller: self)
        designPicker.dataSource = self
        designPicker.delegate = self
        
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
        redrawScene()
    }
    
    // MARK: UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case stylePicker:
            return styleValues.count
        case sensitivityPicker:
            return sensitivityValues.count
        case designPicker:
            return designValues.count
        default:
            fatalError("Unexpected picker provided in preferences")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case stylePicker:
            return styleValues[row]
        case sensitivityPicker:
            return sensitivityValues[row]
        case designPicker:
            return designValues[row]
        default:
            fatalError("Unexpected picker provided in preferences")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case stylePicker:
            break
        case sensitivityPicker:
            hunt.clueRadius = stringToRadius(descr: sensitivityValues[row])
            didUpdateActiveUser()
            if let first = hunt.clues.first {
                setPreviewRegion(first: first)
            }
        case designPicker:
            break
        default:
            fatalError("Unexpected picker provided in preferences")
        }
    }
    
    // MARK: Picker Value Parsing
    private func radiusToString(radius: Int) -> String {
        return String(radius) + "%"
    }
    
    private func stringToRadius(descr: String) -> Int {
        return Int(descr.prefix(descr.count - 1))!
    }
    
    // MARK: Location
    func setPreviewRegion(first: Clue) {
        sensitivityPreview.setRegion(MKCoordinateRegion(center: first.location, span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(hunt.clueRadius) / 11100, longitudeDelta: CLLocationDegrees(hunt.clueRadius) / 11100)), animated: false)
    }
}
