
import Foundation
import UIKit

class ViewStyle : Stylist {
    
    typealias Element = UIView
    
    var borderWidth: Int?
    var borderColor: UIColor?
    var cornerRadius: Int?
    var backgroundColor: UIColor?
    
    enum Properties: String {
        case BorderWidth = "borderWidth"
        case BorderColor = "borderColor"
        case CornerRadius = "cornerRadius"
        case BackgroundColor = "backgroundColor"
    }
    
    static let allValues:[Properties] = [.BorderWidth, .BorderColor, .CornerRadius, .BackgroundColor]
    
    static func serialize(spec: [String:AnyObject], resources:CommonResources) throws -> ViewStyle {
        let style = ViewStyle()
        for (key,value) in spec {
            guard let property = ViewStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: StyleKit does not support \(key) on \(Element.self). Ignored.")
                continue
            }
            switch property {
            case .BorderColor:
                if let colorKey = value as? String,
                    let color = resources.colors[colorKey] {
                    style.borderColor = color
                }
            case .BorderWidth:
                if let width = value as? Int {
                    style.borderWidth = width
                }
            case .CornerRadius:
                if let radius = value as? Int {
                    style.cornerRadius = radius
                }
            case .BackgroundColor:
                if let colorKey = value as? String,
                    let color = resources.colors[colorKey] {
                    style.backgroundColor = color
                }
            }
        }
        return style
    }

}

extension UIView {
    
    private func applyStyle(style:ViewStyle, resources:CommonResources) {
        for property in ViewStyle.allValues {
            switch property {
            case .BorderWidth:
                if let borderWidth = style.borderWidth {
                    self.layer.borderWidth = CGFloat(borderWidth)
                }
            case .BorderColor:
                if let borderColor = style.borderColor {
                    self.layer.borderColor = borderColor.CGColor
                }
            case .CornerRadius:
                if let cornerRadius = style.cornerRadius {
                    self.layer.cornerRadius = CGFloat(cornerRadius)
                }
            case .BackgroundColor:
                if let color = style.backgroundColor {
                    self.backgroundColor = color
                }
            }
        }
    }
    
    /**
        Apply the styles of the active stylesheet to the view.
    */
    func style() {
        guard let styleTag = self.styleTag else {
            print("StyleKit: Warning: Instance of \(self.dynamicType) with no styleTag")
            return
        }
        switch self {
        case is UISegmentedControl:
            if let elementStyles = Style.sharedInstance.styleMap[.segmentedControl],
                let styles = elementStyles[styleTag],
                let styleObject = styles as? SegmentedControlStyle {
                (self as! UISegmentedControl).applyStyle(styleObject, resources: Style.sharedInstance.resources)
            } else {
                print("StyleKit: Warning: styleTag \(styleTag) on \(self.dynamicType) was not found in Style.json")
            }
        case is UITextField:
            if let elementStyles = Style.sharedInstance.styleMap[.textField],
                let styles = elementStyles[styleTag],
                let styleObject = styles as? TextFieldStyle {
                (self as! UITextField).applyStyle(styleObject, resources: Style.sharedInstance.resources)
            } else {
                print("StyleKit: Warning: styleTag \(styleTag) on \(self.dynamicType) was not found in Style.json")
            }
        case is UIButton:
            if let elementStyles = Style.sharedInstance.styleMap[.button],
                let styles = elementStyles[styleTag],
                let styleObject = styles as? ButtonStyle {
                (self as! UIButton).applyStyle(styleObject, resources: Style.sharedInstance.resources)
            } else {
                print("StyleKit: Warning: styleTag \(styleTag) on \(self.dynamicType) was not found in Style.json")
            }
        case is UILabel:
            if let elementStyles = Style.sharedInstance.styleMap[.label],
                let styles = elementStyles[styleTag],
                let styleObject = styles as? LabelStyle {
                (self as! UILabel).applyStyle(styleObject, resources: Style.sharedInstance.resources)
            } else {
                print("StyleKit: Warning: styleTag \(styleTag) on \(self.dynamicType) was not found in Style.json")
            }
        case is UISlider:
            if let elementStyles = Style.sharedInstance.styleMap[.slider],
                let styles = elementStyles[styleTag],
                let styleObject = styles as? SliderStyle {
                (self as! UISlider).applyStyle(styleObject, resources: Style.sharedInstance.resources)
            } else {
                print("StyleKit: Warning: styleTag \(styleTag) on \(self.dynamicType) was not found in Style.json")
            }
        case is UIStepper:
            if let elementStyles = Style.sharedInstance.styleMap[.stepper],
                let styles = elementStyles[styleTag],
                let styleObject = styles as? StepperStyle {
                (self as! UIStepper).applyStyle(styleObject, resources: Style.sharedInstance.resources)
            } else {
                print("StyleKit: Warning: styleTag \(styleTag) on \(self.dynamicType) was not found in Style.json")
            }
        case is UIProgressView:
            if let elementStyles = Style.sharedInstance.styleMap[.progressView],
                let styles = elementStyles[styleTag],
                let styleObject = styles as? ProgressViewStyle {
                (self as! UIProgressView).applyStyle(styleObject, resources: Style.sharedInstance.resources)
            } else {
                print("StyleKit: Warning: styleTag \(styleTag) on \(self.dynamicType) was not found in Style.json")
            }
        case is UITextView:
            if let elementStyles = Style.sharedInstance.styleMap[.textView],
                let styles = elementStyles[styleTag],
                let styleObject = styles as? TextViewStyle {
                (self as! UITextView).applyStyle(styleObject, resources: Style.sharedInstance.resources)
            } else {
                print("StyleKit: Warning: styleTag \(styleTag) on \(self.dynamicType) was not found in Style.json")
            }
        default:
            if let elementStyles = Style.sharedInstance.styleMap[.view],
                let styles = elementStyles[styleTag],
                let styleObject = styles as? ViewStyle {
                self.applyStyle(styleObject, resources: Style.sharedInstance.resources)
            } else {
                print("StyleKit: Warning: styleTag \(styleTag) on \(self.dynamicType) was not found in Style.json")
            }
        }
    }
}
