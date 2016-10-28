
import Foundation
import UIKit

class SegmentedControlStyle : Stylist {
    
    typealias Element = UISegmentedControl
    
    var fontStyle: FontStyle?
    var tintColor:UIColor?
    var dividerColor:UIColor?
    var normalColors: ColorStyle?
    var highlightedColors: ColorStyle?
    var selectedColors: ColorStyle?
    var disabledColors: ColorStyle?
    
    enum Properties: String {
        case FontStyle = "fontStyle"
        case TintColor = "tintColor"
        case DividerColor = "dividerColor"
        case Normal = "normalState"
        case Highlighted = "highlightedState"
        case Selected = "selectedState"
        case Disabled = "disabledState"
    }
    
    static let allValues:[Properties] = [.DividerColor, .FontStyle, .TintColor, .Normal, .Highlighted, .Selected, .Disabled]
    
    static func serialize(spec: [String:AnyObject], resources:CommonResources) throws -> SegmentedControlStyle {
        let style = SegmentedControlStyle()
        for (key,value) in spec {
            guard let property = SegmentedControlStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: StyleKit does not support \(key) on \(Element.self). Ignored.")
                continue
            }
            switch property {
            case .FontStyle:
                if let fontSpec = value as? [String:AnyObject] {
                    style.fontStyle = Style.serializeFontSpec(fontSpec, resources: resources)
                }
            case .TintColor:
                if let colorKey = value as? String,
                    let color = resources.colors[colorKey] {
                    style.tintColor = color
                }
            case .DividerColor:
                if let colorKey = value as? String,
                    let color = resources.colors[colorKey] {
                    style.dividerColor = color
                }
            case .Normal:
                if let normalColorEntries = value as? [String: String] {
                    style.normalColors = Style.serializeColorsSpec(normalColorEntries, resources: resources)
                }
            case .Selected:
                if let selectedColorEntries = value as? [String: String] {
                    style.selectedColors = Style.serializeColorsSpec(selectedColorEntries, resources: resources)
                }
            case .Highlighted:
                if let highlightedColorEntries = value as? [String: String] {
                    style.highlightedColors = Style.serializeColorsSpec(highlightedColorEntries, resources: resources)
                }
            case .Disabled:
                if let disabledColorEntries = value as? [String: String] {
                    style.disabledColors = Style.serializeColorsSpec(disabledColorEntries, resources: resources)
                }
                
            }
            
        }
        return style
    }
}

extension UISegmentedControl {
    
    func applyStyle(style:SegmentedControlStyle, resources:CommonResources) {
        for property in SegmentedControlStyle.allValues {
            
            var normalAttributes: [NSObject: AnyObject] = [:]
            var selectedAttributes: [NSObject: AnyObject] = [:]
            
            switch property {
            case .FontStyle:
                if let fontStyle = style.fontStyle {
                    let font = UIFont(name: fontStyle.fontName, size: CGFloat(fontStyle.size))
                    normalAttributes[NSFontAttributeName] = font
                    selectedAttributes[NSFontAttributeName] = font
                }
            case .TintColor:
                if let tintColor = style.tintColor {
                    self.tintColor = tintColor
                }
            case .Normal:
                if let colorStyles = style.normalColors {
                    assignColors(colorStyles, forState: .Normal, resources: resources)
                }
            case .Selected:
                if let colorStyles = style.selectedColors {
                    assignColors(colorStyles, forState: .Selected, resources: resources)
                }
            case .Highlighted:
                if let colorStyles = style.highlightedColors {
                    assignColors(colorStyles, forState: .Highlighted, resources: resources)
                }
            case .Disabled:
                if let colorStyles = style.disabledColors {
                    assignColors(colorStyles, forState: .Disabled, resources: resources)
                }
            case .DividerColor:
                if let divColor = style.dividerColor {
                    self.setDividerImage(UIImage.imageWithColor(divColor), forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: .Default)
                }
            }
        }
    }
    
    func assignColors(colors: ColorStyle, forState state: UIControlState, resources:CommonResources) {
        if let colorKey = colors.backgroundColor, let color = resources.colors[colorKey] {
            self.setBackgroundImage(UIImage.imageWithColor(color), forState: state, barMetrics: .Default)
        }
        if let colorKey = colors.textColor, let color = resources.colors[colorKey] {
            let attributes = [NSForegroundColorAttributeName: color]
            self.setTitleTextAttributes(attributes, forState: state)
        }
    }
}



