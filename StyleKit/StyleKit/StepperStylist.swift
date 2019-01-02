
import Foundation
import UIKit

class StepperStyle : Stylist {
    
    typealias Element = UIStepper
    
    var tintColor: UIColor?
    var backgroundImage: [AllowedStates:UIImage]?
    var incrementImage: [AllowedStates:UIImage]?
    var decrementImage: [AllowedStates:UIImage]?
    
    enum Properties: String {
        case TintColor = "tintColor"
        case IncrementImage = "incrementImage"
        case DecrementImage = "decrementImage"
        case BackgroundImage = "backgroundImage"
    }
    
    enum AllowedStates: String {
        case Normal = "normalState"
        case Highlighted = "highlightedState"
        case Disabled = "disabledState"
    }
    
    static func controlStateForAllowedState(_ state:AllowedStates) -> UIControl.State {
        switch state {
        case .Disabled:
            return UIControl.State.disabled
        case .Highlighted:
            return UIControl.State.highlighted
        case .Normal:
            return .normal
        }
    }
    
    static let allValues:[Properties] = [.TintColor, .IncrementImage, .DecrementImage, .BackgroundImage]
    
    static func serialize(_ spec: [String:AnyObject], resources:CommonResources) throws -> StepperStyle {
        let style = StepperStyle()
        for (key,value) in spec {
            guard let property = StepperStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: StyleKit does not support \(key) on \(Element.self). Ignored.")
                continue
            }
            switch property {
            case .TintColor:
                if let colorKey = value as? String, let color = resources.colors[colorKey] {
                    style.tintColor = color
                }
            case .IncrementImage:
                if let states = value as? [String: String] {
                    var values:[StepperStyle.AllowedStates:UIImage] = [:]
                    for (key, value) in states {
                        if let state = StepperStyle.AllowedStates(rawValue: key),
                            let imageKey = resources.imageNames[value],
                            let image = UIImage(named: imageKey) {
                            values[state] = image
                        }
                    }
                    style.incrementImage = values
                }
            case .DecrementImage:
                if let states = value as? [String: String] {
                    var values:[StepperStyle.AllowedStates:UIImage] = [:]
                    for (key, value) in states {
                        if let state = StepperStyle.AllowedStates(rawValue: key),
                            let imageKey = resources.imageNames[value],
                            let image = UIImage(named: imageKey) {
                            values[state] = image
                        }
                    }
                    style.decrementImage = values
                }
            case .BackgroundImage:
                if let states = value as? [String: String] {
                    var values:[StepperStyle.AllowedStates:UIImage] = [:]
                    for (key, value) in states {
                        if let state = StepperStyle.AllowedStates(rawValue: key),
                            let imageKey = resources.imageNames[value],
                            let image = UIImage(named: imageKey) {
                            values[state] = image
                        }
                    }
                    style.backgroundImage = values
                }
            }
        }
        return style
    }
}

extension UIStepper {
    
    func applyStyle(_ style:StepperStyle, resources:CommonResources) {
        for property in StepperStyle.allValues {
            switch property {
            case .TintColor:
                if let color = style.tintColor {
                    self.tintColor = color
                }
            case .IncrementImage:
                if let states = style.incrementImage {
                    for (key, value) in states {
                        let controlState = StepperStyle.controlStateForAllowedState(key)
                        self.setIncrementImage(value, for: controlState)
                    }
                }
            case .DecrementImage:
                if let states = style.decrementImage {
                    for (key, value) in states {
                        let controlState = StepperStyle.controlStateForAllowedState(key)
                        self.setDecrementImage(value, for: controlState)
                    }
                }
            case .BackgroundImage:
                if let states = style.backgroundImage {
                    for (key, value) in states {
                        let controlState = StepperStyle.controlStateForAllowedState(key)
                        self.setBackgroundImage(value, for: controlState)
                    }
                }
            }
        }
    }
}


