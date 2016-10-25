import UIKit
import Foundation

struct FontStyle {
    let fontName: String
    let size: Int
}

class ColorStyle {
    var backgroundColor: String?
    var textColor: String?
    enum Properties: String {
        case Background = "backgroundColor"
        case Text = "textColor"
        static let allValues:[Properties] = [.Background, .Text]
    }
}

class CommonResources {
    var fontLabels = [String: String]()
    var colors = [String: UIColor]()
    var imageNames = [String: String]()
}

protocol Stylist {
    associatedtype Element
}

enum FontProperty: String {
    case name = "font"
    case size = "size"
}

enum UIElement: String {
    case segmentedControl = "SegmentedControls"
    case textField = "TextFields"
    case button = "Buttons"
    case label = "Labels"
    case slider = "Sliders"
    case stepper = "Steppers"
    case progressView = "ProgressViews"
    case view = "Views"
    static let allValues:[UIElement] = [.view, .segmentedControl, .textField, .button, .label, .slider, .stepper, .progressView]
}

enum CommonObjects: String {
    case Fonts = "Fonts"
    case Colors = "Colors"
    case Images = "Images"
}

enum ColorProperties: String {
    case Red = "red"
    case Green = "green"
    case Blue = "blue"
    case Alpha = "alpha"
    case Hex = "hex"
}


class Style: NSObject {
    
    enum StyleKitError: ErrorType {
        case StyleFileNotFound
        case InvalidFontStyle
        case InvalidTextFieldProperty
        case InvalidLabelStyle
    }
    
    static let sharedInstance = Style()
    
    var fileName = "Style.json"
    
    var resources = CommonResources()
    
    typealias StyleMap = [String: AnyObject]
    
    var styleMap = [UIElement:StyleMap]()
    
    private override init() {
        super.init()
        serialize(fileName)
    }

    private func checkIfImageExist(name:String) -> Bool {
        return UIImage(named: name) == nil ? false : true
    }
    
    private func getStylePath() throws -> NSURL {
        if let string = NSBundle.mainBundle().infoDictionary?["StyleKit-DesignatedFolder"] as? String,
            documentDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last {
            if let pathURL = documentDirectory.URLByAppendingPathComponent(string + "/Style.json"), path = pathURL.path {
                if NSFileManager.defaultManager().fileExistsAtPath(path) {
                    return pathURL
                } else {
                    throw StyleKitError.StyleFileNotFound
                }
            } else {
                throw StyleKitError.StyleFileNotFound
            }
        } else {
            if let path = NSBundle.mainBundle().URLForResource("Style", withExtension: "json") {
                return path
            } else {
                throw StyleKitError.StyleFileNotFound
            }
        }
    }
    
    private func serialize(styleFile: String) {
        do {
            let stylePath = try self.getStylePath()
            let data = try NSData(contentsOfURL: stylePath, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            if let items = json[CommonObjects.Fonts.rawValue] as? [String: String] {
                resources.fontLabels = items
            }
            
            if let colorDict = json[CommonObjects.Colors.rawValue] as? [String: [String: AnyObject]] {
                for (colorKey, components) in colorDict {
                    if let red = components[ColorProperties.Red.rawValue] as? Int,
                        let green = components[ColorProperties.Green.rawValue] as? Int,
                        let blue = components[ColorProperties.Blue.rawValue] as? Int,
                        let alpha = components[ColorProperties.Alpha.rawValue] as? Int {
                        resources.colors[colorKey] = UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha))
                    } else if let hex = components[ColorProperties.Hex.rawValue] as? String,
                        let alpha = components[ColorProperties.Alpha.rawValue] as? Float {
                        if let hexInt = hex.hexColorToInt() {
                            resources.colors[colorKey] = UIColor(withHex: hexInt, alpha: alpha)
                        }
                    }
                }
            }
            
            if let items = json[CommonObjects.Images.rawValue] as? [String: String] {
                resources.imageNames = items
                for (alias, fileName) in items {
                    if checkIfImageExist(fileName) == false {
                        print("StyleKit: Warning: Image file '\(fileName)' referenced by '\(alias)' does not exist in bundle")
                    }
                }
            }
            
            for element in UIElement.allValues {
                guard let elementDict = json[element.rawValue] as? [String: [String:AnyObject]] else { continue }
                
                var styles = StyleMap()
                for (labelKey, specification) in elementDict {
                    switch element {
                    case .button:
                        styles[labelKey] = try ButtonStyle.serialize(specification, resources: resources) as AnyObject
                    case .label:
                        styles[labelKey] = try LabelStyle.serialize(specification, resources: resources) as AnyObject
                    case .progressView:
                        styles[labelKey] = try ProgressViewStyle.serialize(specification, resources: resources) as AnyObject
                    case .segmentedControl:
                        styles[labelKey] = try SegmentedControlStyle.serialize(specification, resources: resources) as AnyObject
                    case .slider:
                        styles[labelKey] = try SliderStyle.serialize(specification, resources: resources) as AnyObject
                    case .stepper:
                        styles[labelKey] = try StepperStyle.serialize(specification, resources: resources) as AnyObject
                    case .view:
                        styles[labelKey] = try ViewStyle.serialize(specification, resources: resources) as AnyObject
                    case .textField:
                        styles[labelKey] = try TextFieldStyle.serialize(specification, resources: resources) as AnyObject
                    }
                }
                styleMap[element] = styles
            }
        } catch {
            assert(false,"error serializing JSON: \(error)")
        }
    }
    
    //---------------------------------------------
    // MARK: - Serialize JSON into Objects (Common)
    //---------------------------------------------
    
    static func serializeColorsSpec(spec: [String:String], resources:CommonResources) throws -> ColorStyle {
        
        let styleSpec = ColorStyle()
        for style in ColorStyle.Properties.allValues {
            switch style {
            case .Background:
                if let value = spec[style.rawValue] {
                    styleSpec.backgroundColor = value
                }
            case .Text:
                if let value = spec[style.rawValue] {
                    styleSpec.textColor = value
                }
            }
        }
        return styleSpec
    }
        
    static func serializeFontSpec(spec: [String:AnyObject], resources:CommonResources) throws -> FontStyle {
        if let nameKey = spec[FontProperty.name.rawValue] as? String,
            let fontName = resources.fontLabels[nameKey],
            let size = spec[FontProperty.size.rawValue] as? Int {
            return FontStyle(fontName: fontName, size: size)
        } else {
            throw StyleKitError.InvalidFontStyle
        }
    }
}


















