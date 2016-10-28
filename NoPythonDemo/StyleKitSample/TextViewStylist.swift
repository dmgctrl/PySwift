import UIKit

class TextViewStyle {
    typealias Element = UITextView
    
    var textColor: UIColor?
    var textAlignment: NSTextAlignment?
    var attributes: AttributedTextStyle?
    var backgroundColor: UIColor?
    
    enum Properties: String {
        case TextColor = "textColor"
        case TextAlignment = "textAlignment"
        case Attributes = "attributes"
        case BackgroundColor = "backgroundColor"
        static let allValues:[Properties] = [.TextColor, .TextAlignment, .Attributes, .BackgroundColor]
    }
    
    static var textAlignmentKeyMap:[String:NSTextAlignment] = ["Left":.Left,
                                                               "Center":.Center,
                                                               "Right":.Right,
                                                               "Justified":.Justified,
                                                               "Natural":.Natural]
    
    static func attributesForTextView(styles:AttributedTextStyle) ->  Dictionary<String, AnyObject> {
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.Center
        if let lineSpace = styles.lineSpacing {
            style.lineSpacing = lineSpace
        }
        
        var attributes:[String: AnyObject] = [:]
        
        if let fontName = styles.fontStyle?.fontName, let fontSize = styles.fontStyle?.size  {
            attributes[NSFontAttributeName] = UIFont(name: fontName, size: CGFloat(fontSize))
        }
        
        if let tracking = styles.tracking, let fontSize = styles.fontStyle?.size {
            let characterSpacing = fontSize * tracking / 1000
            attributes[NSKernAttributeName] = characterSpacing
        }
        
        attributes[NSParagraphStyleAttributeName] = style
        
        return attributes
    }
    
    static func serialize(spec: [String:AnyObject], resources:CommonResources) throws -> TextViewStyle {
        let textViewStyle = TextViewStyle()
        for (key,value) in spec {
            guard let property = TextViewStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: StyleKit does not support \(key) on \(Element.self). Ignored.")
                continue
            }
            switch property {
                
            case TextViewStyle.Properties.TextAlignment:
                if let textAlignmentKey = value as? String, let alignment = TextViewStyle.textAlignmentKeyMap[textAlignmentKey] {
                    textViewStyle.textAlignment = alignment
                }
            case TextViewStyle.Properties.TextColor:
                if let colorKey = value as? String, let color = resources.colors[colorKey] {
                    textViewStyle.textColor = color
                }
            case TextViewStyle.Properties.Attributes:
                if let attributes = value as? [String:AnyObject]
                {
                    let attr = try TextViewStyle.serializeFormatAttributesSpec(attributes, resources:resources)
                    textViewStyle.attributes = attr
                }
            case TextViewStyle.Properties.BackgroundColor:
                if let colorKey = value as? String, let color = resources.colors[colorKey] {
                    textViewStyle.backgroundColor = color
                }
            }
        }
        return textViewStyle
    }
    
    static func serializeFormatAttributesSpec(spec: [String:AnyObject], resources:CommonResources) throws -> AttributedTextStyle {
        
        let style = AttributedTextStyle()
        for (key,value) in spec {
            guard let property = AttributedTextStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: StyleKit does not support \(key) on \(Element.self). Ignored.")
                continue
            }
            switch property {
            case .FontStyle:
                if let fontSpec = value as? [String:AnyObject]
                {
                    style.fontStyle = Style.serializeFontSpec(fontSpec, resources: resources)
                }
            case .Tracking:
                if let tracking = value as? Int {
                    style.tracking = tracking
                }
            case .LineSpacing:
                if let lineSpacing = value as? CGFloat {
                    style.lineSpacing = lineSpacing
                }
            case .Ligature:
                if let ligature = value as? Int {
                    style.ligature = ligature
                }
            }
        }
        return style
    }
}

extension UITextView {
    func applyStyle(style: TextViewStyle, resources:CommonResources) {
        for property in TextViewStyle.Properties.allValues {
            switch property {
            case .TextColor:
                self.textColor = style.textColor
            case .TextAlignment:
                self.textAlignment = style.textAlignment ?? self.textAlignment
            case .Attributes:
                if let attributes = style.attributes, text = self.text {
                    let asdf = TextViewStyle.attributesForTextView(attributes)
                    self.attributedText = NSAttributedString(string: text, attributes:asdf)
                }
            case .BackgroundColor:
                self.backgroundColor = style.backgroundColor
            }
        }
    }
}
