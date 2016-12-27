//
//  ViewController.swift
//  SpaceViewExample
//
//  Created by user on 25.12.16.
//  Copyright © 2016 horoko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var timeStepper: UIStepper!
    @IBOutlet weak var autohideTimeLabel: UILabel!
    
    private var timeToAutoHide = 3.0
    private var shouldAutoHide = true
    private var leftSwipeAccepted = true
    private var topSwipeAccepted = true
    private var rightSwipeAccepted = true
    private var spaceStyle: SpaceStyles? = nil
    private var spaceTitle = "Title"
    private var spaceDescr = "Description"
    private var image: UIImage? = nil
    private var withImage = false
    
    var possibleDirectionsToHide: [HideDirection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        autohideTimeLabel.text = String(timeStepper.value)
        timeToAutoHide = timeStepper.value

    }
    
    @IBAction func styleChanged(_ sender: Any) {
        if let sc = sender as? UISegmentedControl {
            switch sc.selectedSegmentIndex {
            case 0:
                spaceStyle = .success
            case 1:
                spaceStyle = .error
            case 2:
                spaceStyle = .warning
            default:
                break
            }
        }
    }
    
    @IBAction func showSpace(_ sender: Any) {
        possibleDirectionsToHide.removeAll()
        
        if spaceStyle != nil {
            switch spaceStyle! {
                case .success:
                    if withImage {
                        image = UIImage(named: "ic_success")
                    }
                    spaceTitle = "Success"
                    spaceDescr = "Operation complete"
                case .error:
                    if withImage {
                        image = UIImage(named: "ic_error")
                    }
                    spaceTitle = "Error"
                    spaceDescr = "Operation failed"
                case .warning:
                    if withImage {
                        image = UIImage(named: "ic_warning")
                    }
                    spaceTitle = "Warning!"
                    spaceDescr = "Look at this!"
            }
        }
        
        if leftSwipeAccepted {
            possibleDirectionsToHide.append(.left)
        }
        if rightSwipeAccepted {
            possibleDirectionsToHide.append(.right)
        }
        if topSwipeAccepted {
            possibleDirectionsToHide.append(.top)
        }
        
        self.showSpace(title: spaceTitle, description: spaceDescr, spaceOptions: [
            .spaceHideTimer(timer: timeToAutoHide),
            .possibleDirectionToHide(possibleDirectionsToHide),
            .shouldAutoHide(should: shouldAutoHide),
            .spaceStyle(style: spaceStyle),
            .image(img: image)
            ])
    }
    
    @IBAction func withImageSwitch(_ sender: Any) {
        if let switcher = sender as? UISwitch {
            withImage = switcher.isOn
        }
    }
    
    @IBAction func stepperAutohide(_ sender: Any) {
        if let stepper = sender as? UIStepper {
            timeToAutoHide = stepper.value
            autohideTimeLabel.text = String(stepper.value)
        }
    }
    
    @IBAction func TopSwipeDirectionSwitch(_ sender: Any) {
        if let switcher = sender as? UISwitch {
            topSwipeAccepted = switcher.isOn
        }
    }
    
    @IBAction func RightSwipeDirectionSwitch(_ sender: Any) {
        if let switcher = sender as? UISwitch {
            rightSwipeAccepted = switcher.isOn
        }
    }
    
    @IBAction func LeftSwipeDirectionSwitch(_ sender: Any) {
        if let switcher = sender as? UISwitch {
            leftSwipeAccepted = switcher.isOn
        }
    }
    
    @IBAction func shouldAutohideSwitch(_ sender: Any) {
        if let switcher = sender as? UISwitch {
            shouldAutoHide = switcher.isOn
        }
    }
}

