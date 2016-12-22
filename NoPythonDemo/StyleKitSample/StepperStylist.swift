
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
    
    static func controlStateForAllowedState(state:AllowedStates) -> UIControlState {
        switch state {
        case .Disabled:
            return UIControlState.Disabled
        case .Highlighted:
            return UIControlState.Highlighted
        case .Normal:
            return UIControlState.Normal
        }
    }
    
    static let allValues:[Properties] = [.TintColor, .IncrementImage, .DecrementImage, .BackgroundImage]
    
    static func serialize(spec: [String:AnyObject], resources:CommonResources) throws -> StepperStyle {
        let style = StepperStyle()
        for (key,value) in spec {
            guard let property = StepperStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: StyleKit does not support \(key) on \(Element.self). Ignored.")
                continue
            }
            switch property {
            case .TintColor:
                if let colorKey = value as? String, color = resources.colors[colorKey] {
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
    
    func applyStyle(style:StepperStyle, resources:CommonResources) {
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
                        self.setIncrementImage(value, forState: controlState)
                    }
                }
            case .DecrementImage:
                if let states = style.decrementImage {
                    for (key, value) in states {
                        let controlState = StepperStyle.controlStateForAllowedState(key)
                        self.setDecrementImage(value, forState: controlState)
                    }
                }
            case .BackgroundImage:
                if let states = style.backgroundImage {
                    for (key, value) in states {
                        let controlState = StepperStyle.controlStateForAllowedState(key)
                        self.setBackgroundImage(value, forState: controlState)
                    }
                }
            }
        }
    }
}


