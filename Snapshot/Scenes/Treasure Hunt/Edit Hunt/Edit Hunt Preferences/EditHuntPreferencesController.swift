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
    
    // Other
    var hunt: TreasureHunt!
    var allowButton: UIButton!
    var hotColdButton: UIButton!
    
    // MARK: Initialization
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    override func viewDidLoad() {
        let hintsView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        layout = EditHuntPreferencesLayout(navigationBar: navigationBar, titleLabel: titleLabel, scrollView: scrollView, styleLabel: styleLabel, stylePicker: stylePicker, hintsView: hintsView, sensitivityLabel: sensitivityLabel, sensitivityPicker: sensitivityPicker, sensitivityPreview: hunt.clues.first == nil ? nil : sensitivityPreview, designLabel: designLabel, designPicker: designPicker)
        layout.configureConstraints(view: view)
        
        // Navigation Bar
        navigationBar.setTitle(text: hunt.name, color: .white)
        navigationBar.backgroundColor = SCENE_COLORS[.hunts]
        navigationBar.addBackButton(text: "Save", action: {
            syncActiveUser(attribute: .preferences)
            self.dismiss(animated: true)
        }, color: .white)
        view.bringSubviewToFront(navigationBar)
        
        // Style section
        styleLabel.text = "Hunt style:"
        styleLabel.addInformationButton(title: "Hunt style", content: "This controls how people play your hunt. Real world option coming soon!", controller: self)
        stylePicker.dataSource = self
        stylePicker.delegate = self
        
        // Hints section
        hintsView.backgroundColor = .white
        
        let allowLabel = UILabel()
        allowButton = UIButton()
        let allowRow = UIView()
        allowRow.addSubview(allowLabel)
        allowRow.addSubview(allowButton)
        NSLayoutConstraint.activate(
            getSizeConstraints(widthAnchor: allowRow.widthAnchor, heightAnchor: allowRow.heightAnchor, sizeMap: [allowLabel: (0.6, 1), allowButton: (0, 0.4)]) +
            getSpacingConstraints(leftAnchor: allowRow.leftAnchor, widthAnchor: allowRow.widthAnchor, topAnchor: allowRow.topAnchor, heightAnchor: allowRow.heightAnchor, spacingMap: [allowLabel: (0.35, 0.5), allowButton: (0.85, 0.5)], parentView: allowRow)
        )
        // TODO: Remove commenting to enable hot/cold option

//        let hotColdLabel = UILabel()
//        hotColdButton = UIButton()
//        let hotColdRow = UIView()
//        hotColdRow.addSubview(hotColdLabel)
//        hotColdRow.addSubview(hotColdButton)
//        NSLayoutConstraint.activate(
//            getSizeConstraints(widthAnchor: hotColdRow.widthAnchor, heightAnchor: hotColdRow.heightAnchor, sizeMap: [hotColdLabel: (0.6, 1), hotColdButton: (0, 0.4)]) +
//            getSpacingConstraints(leftAnchor: hotColdRow.leftAnchor, widthAnchor: hotColdRow.widthAnchor, topAnchor: hotColdRow.topAnchor, heightAnchor: hotColdRow.heightAnchor, spacingMap: [hotColdLabel: (0.35, 0.5), hotColdButton: (0.85, 0.5)], parentView: hotColdRow)
//        )

        hintsView.addSubview(allowRow)
//        hintsView.addSubview(hotColdRow)

        NSLayoutConstraint.activate(
            getSizeConstraints(widthAnchor: hintsView.widthAnchor, heightAnchor: hintsView.heightAnchor, sizeMap: [allowRow: (1, 0.4)/*0.34), hotColdRow: (1, 0.34)*/]) +
                getSpacingConstraints(leftAnchor: hintsView.leftAnchor, widthAnchor: hintsView.widthAnchor, topAnchor: hintsView.topAnchor, heightAnchor: hintsView.heightAnchor, spacingMap: [allowRow: (0.5, 0.5)/*0.3), hotColdRow: (0.5, 0.7)*/], parentView: hintsView)
        )

        doNotAutoResize(views: [hintsView, allowLabel, allowButton, allowRow, /*hotColdLabel, hotColdButton, hotColdRow*/])
        setLabelsToDefaults(labels: [allowLabel/*, hotColdLabel*/])
        setButtonsToDefaults(buttons: [allowButton/*, hotColdButton*/])
        allowLabel.text = "Turn on hints for this hunt?"
        allowButton.setBackgroundImage(UIImage(named: hunt.allowHints ? "checkboxFull" : "checkboxEmpty"), for: .normal)
        allowButton.addAction {
            self.hunt.allowHints = !self.hunt.allowHints
            self.allowButton.setBackgroundImage(UIImage(named: self.hunt.allowHints ? "checkboxFull" : "checkboxEmpty"), for: .normal)
//            if self.hunt.allowHints {
//                self.hotColdButton.isEnabled = true
//                hotColdRow.tintColor = .none
//                hotColdRow.alpha = 1
//            } else {
//                self.hotColdButton.isEnabled = false
//                hotColdRow.tintColor = .gray
//                hotColdRow.alpha = 0.6
//            }
        }
        
//        hotColdLabel.text = "Show hotter / colder hints?"
//        hotColdButton.setBackgroundImage(UIImage(named: hunt.allowHotterColder ? "checkboxFull" : "checkboxEmpty"), for: .normal)
//        hotColdButton.addAction {
//            self.hunt.allowHotterColder = !self.hunt.allowHotterColder
//            self.hotColdButton.setBackgroundImage(UIImage(named: self.hunt.allowHotterColder ? "checkboxFull" : "checkboxEmpty"), for: .normal)
//        }
//        if !hunt.allowHints {
//            hotColdButton.isEnabled = false
//            hotColdRow.tintColor = .gray
//            hotColdRow.alpha = 0.6
//        }
        
        // Clue sensitivity section
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
            sensitivityPreview.isUserInteractionEnabled = false
        } else {
            sensitivityPreview.isHidden = true
        }
        
        // Design section
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
        scrollView.setAxis(axis: isPortrait ? .vertical : .horizontal)
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
