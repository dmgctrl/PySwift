
import Foundation
import UIKit

class TextFieldStyle : Stylist {
    
    typealias Element = UITextField
    
    var fontStyle: FontStyle?
    var textColor: UIColor?
    var borderColor: UIColor?
    var borderWidth: Int?
    var cornerRadius: Int?
    var textAlignment: NSTextAlignment?
    var borderStyle: UITextBorderStyle?
    var backgroundColor: UIColor?
    
    enum Properties: String {
        case FontStyle = "fontStyle"
        case BorderWidth = "borderWidth"
        case BorderColor = "borderColor"
        case CornerRadius = "cornerRadius"
        case TextAlignment = "textAlignment"
        case BorderStyle = "borderStyle"
        case TextColor = "textColor"
        case BackgroundColor = "backgroundColor"
    }
    
    static let allValues:[Properties] = [.BackgroundColor, .FontStyle, .BorderWidth, .BorderColor, .CornerRadius, .TextAlignment, .BorderStyle, .TextColor]
    
    static func serialize(spec: [String:AnyObject], resources:CommonResources) throws -> TextFieldStyle {
        let result = TextFieldStyle()
        for (key,value) in spec {
            guard let property = TextFieldStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: StyleKit does not support \(key) on \(Element.self). Ignored.")
                continue
            }
            
            switch property {
                
            case TextFieldStyle.Properties.FontStyle:
                if let fontSpec = value as? [String:AnyObject] {
                    result.fontStyle = Style.serializeFontSpec(fontSpec, resources: resources)
                }
            case TextFieldStyle.Properties.BorderWidth:
                if let borderWidth = value as? Int {
                    result.borderWidth = borderWidth
                }
            case TextFieldStyle.Properties.TextColor:
                if let colorKey = value as? String, color = resources.colors[colorKey]  {
                    result.textColor = color
                }
            case TextFieldStyle.Properties.BorderColor:
                if let colorKey = value as? String, color = resources.colors[colorKey]  {
                    result.borderColor = color
                }
            case TextFieldStyle.Properties.TextAlignment:
                if let styleStr = value as? String, let alignment = mapTextAlignmentType(styleStr) {
                    result.textAlignment = alignment
                }
            case TextFieldStyle.Properties.BorderStyle:
                if let styleStr = value as? String, let border = mapBorderStyle(styleStr) {
                    result.borderStyle = border
                }
            case TextFieldStyle.Properties.CornerRadius:
                if let cornerRadius = value as? Int {
                    result.cornerRadius = cornerRadius
                }
            case TextFieldStyle.Properties.BackgroundColor:
                if let colorKey = value as? String, color = resources.colors[colorKey] {
                    result.backgroundColor = color
                }
            }
        }
        
        return result
    }
    
    static func mapTextAlignmentType(styleStr:String) -> NSTextAlignment?  {
        let allowedValues = ["Left","Center","Right","Justified","Natural"]
        if let index = allowedValues.indexOf(styleStr) {
            return NSTextAlignment(rawValue: index)
        }
        return nil
    }
    
    static func mapBorderStyle(styleStr:String) -> UITextBorderStyle?  {
        let allowedValues = ["None","Line","Bezel","RoundedRect"]
        if let index = allowedValues.indexOf(styleStr) {
            return UITextBorderStyle(rawValue: index)
        }
        return nil
    }
}

extension UITextField {
    
    func applyStyle(style:TextFieldStyle, resources:CommonResources) {
        for property in TextFieldStyle.allValues {
            switch property {
            case .FontStyle:
                if let fontStyle = style.fontStyle {
                    self.font = UIFont(name: fontStyle.fontName, size: CGFloat(fontStyle.size))
                }
            case .BorderWidth:
                if let borderWidth = style.borderWidth {
                    self.layer.borderWidth = CGFloat(borderWidth)
                }
            case .BorderColor:
                if let borderColor = style.borderColor {
                    self.layer.borderColor = borderColor.CGColor
                }
            case .TextAlignment:
                if let aValue = style.textAlignment {
                    self.textAlignment = aValue
                }
            case .BorderStyle:
                if let aValue = style.borderStyle {
                    self.borderStyle = aValue
                }
            case .CornerRadius:
                if let cornerRadius = style.cornerRadius {
                    self.layer.cornerRadius = CGFloat(cornerRadius)
                }
            case .TextColor:
                if let color = style.textColor {
                    self.textColor = color
                }
            case .BackgroundColor:
                if let color = style.backgroundColor {
                    self.backgroundColor = color
                }
            }
        }
    }
    
}

