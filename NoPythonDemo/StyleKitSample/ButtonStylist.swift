
import Foundation
import UIKit

class ButtonStyle : Stylist {
    
    typealias Element = UIButton
    
    var fontStyle: FontStyle?
    var borderWidth: Int?
    var borderColor: UIColor?
    var backgroundColor: UIColor?
    var cornerRadius: Int?
    var normalColors: ColorStyle?
    var highlightedColors: ColorStyle?
    var selectedColors: ColorStyle?
    var disabledColors: ColorStyle?
    
    enum Properties: String {
        case FontStyle = "fontStyle"
        case BorderWidth = "borderWidth"
        case BorderColor = "borderColor"
        case CornerRadius = "cornerRadius"
        case Normal = "normalState"
        case Highlighted = "highlightedState"
        case Selected = "selectedState"
        case Disabled = "disabledState"
        case BackgroundColor = "backgroundColor"
    }
    
    static let allValues:[Properties] = [.FontStyle, .BorderWidth, .BackgroundColor, .BorderColor, .CornerRadius, .Normal, .Highlighted, .Selected, .Disabled]
    
    static func serialize(spec: [String:AnyObject], resources:CommonResources) throws -> ButtonStyle {
        let style = ButtonStyle()
        for (key,value) in spec {
            guard let property = ButtonStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: StyleKit does not support \(key) on \(Element.self). Ignored.")
                continue
            }
            switch property {
            case .FontStyle:
                if let fontSpec = value as? [String:AnyObject] {
                    style.fontStyle = Style.serializeFontSpec(fontSpec, resources: resources)
                }
            case .BorderColor:
                if let colorKey = value as? String,
                    let color = resources.colors[colorKey] {
                    style.borderColor = color
                }
            case .BackgroundColor:
                if let colorKey = value as? String,
                    let color = resources.colors[colorKey] {
                    style.backgroundColor = color
                }
            case .BorderWidth:
                if let width = value as? Int {
                    style.borderWidth = width
                }
            case .CornerRadius:
                if let radius = value as? Int {
                    style.cornerRadius = radius
                }
            case .Normal:
                if let normalColorEntries = value as? [String: String] {
                    style.normalColors = Style.serializeColorsSpec(normalColorEntries, resources:resources)
                }
            case .Selected:
                if let selectedColorEntries = value as? [String: String] {
                    style.selectedColors = Style.serializeColorsSpec(selectedColorEntries, resources:resources)
                }
            case .Highlighted:
                if let highlightedColorEntries = value as? [String: String] {
                    style.highlightedColors = Style.serializeColorsSpec(highlightedColorEntries, resources:resources)
                }
            case .Disabled:
                if let disabledColorEntries = value as? [String: String] {
                    style.disabledColors = Style.serializeColorsSpec(disabledColorEntries, resources:resources)
                }
            }
        }
        return style
    }
}

extension UIButton {
    
    func applyStyle(style:ButtonStyle, resources:CommonResources) {
        for property in ButtonStyle.allValues {
            switch property {
            case .FontStyle:
                if let fontStyle = style.fontStyle {
                    self.titleLabel?.font = UIFont(name: fontStyle.fontName, size: CGFloat(fontStyle.size))
                }
            case .BorderWidth:
                if let borderWidth = style.borderWidth {
                    self.layer.borderWidth = CGFloat(borderWidth)
                }
            case .BorderColor:
                if let borderColor = style.borderColor {
                    self.layer.borderColor = borderColor.CGColor
                }
            case .BackgroundColor:
                if let color = style.backgroundColor {
                    self.backgroundColor = color
                }
            case .CornerRadius:
                if let cornerRadius = style.cornerRadius {
                    self.layer.cornerRadius = CGFloat(cornerRadius)
                    self.layer.masksToBounds = true
                }
            case .Normal:
                if let value = style.normalColors {
                    assignColors(value, forState: .Normal, resources: resources)
                }
            case .Selected:
                if let value = style.selectedColors {
                    assignColors(value, forState: .Selected, resources: resources)
                }
            case .Highlighted:
                if let value = style.highlightedColors {
                    assignColors(value, forState: .Highlighted, resources: resources)
                }
            case .Disabled:
                if let value = style.disabledColors {
                    assignColors(value, forState: .Disabled, resources: resources)
                }
            }
        }
    }
    
    func assignColors(colors: ColorStyle, forState state: UIControlState, resources:CommonResources) {
        if let colorKey = colors.backgroundColor, let color = resources.colors[colorKey] {
            self.setBackgroundImage(UIImage.imageWithColor(color), forState: state)
        }
        if let colorKey = colors.textColor, let color = resources.colors[colorKey] {
            self.setTitleColor(color, forState: state)
        }
    }
}


