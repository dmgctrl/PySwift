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

class AttributedTextStyle {
    var fontStyle: FontStyle?
    var tracking: Int?
    var lineSpacing: CGFloat?
    var ligature: Int?
    
    enum Properties: String {
        case FontStyle = "fontStyle"
        case Tracking = "tracking"
        case LineSpacing = "lineSpacing"
        case Ligature = "ligature"
        static let allValues:[Properties] = [.FontStyle, .Tracking, .LineSpacing, .Ligature]
    }
}

protocol Stylist {
    associatedtype Element
}

protocol StyleKitSubscriber: class {
    func update()
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
    case textView = "TextViews"
    static let allValues:[UIElement] = [.view, .segmentedControl, .textField, .button, .label, .slider, .stepper, .progressView, .textView]
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


class Style {
    
    enum StyleKitError: ErrorType {
        case StyleFileNotFound(String)
        case InvalidTextFieldProperty
        case InvalidLabelStyle
    }
    
    static let sharedInstance = Style()
    
    private let fileName = "Style.json"
    static let styleSheetLocation = "StyleKit-StylesheetLocation" // Make sure to update docs if this changes
    
    var resources = CommonResources()
    
    typealias StyleMap = [String: AnyObject]
    
    var styleMap = [UIElement:StyleMap]()
    
    private let subscribers: NSHashTable
    
    private init() {
        self.subscribers = NSHashTable(options: .WeakMemory)
        serialize()
    }

    private func checkIfImageExist(name:String) -> Bool {
        return UIImage(named: name) == nil ? false : true
    }
    
    private func getStylePath() throws -> NSURL {
        if let string = NSBundle.mainBundle().infoDictionary?[Style.styleSheetLocation] as? String,
            documentDirectory = Utils.documentDirectory {
            let pathURL: NSURL?
            if string.containsString(".json") {
                pathURL = documentDirectory.URLByAppendingPathComponent(string)
            } else {
                pathURL = documentDirectory.URLByAppendingPathComponent(string + "/" + fileName)
            }
            
            if let thePathURL = pathURL, path = thePathURL.path {
                if NSFileManager.defaultManager().fileExistsAtPath(path) {
                    return thePathURL
                } else {
                    throw StyleKitError.StyleFileNotFound("File does not exist at \(thePathURL)")
                }
            } else {
                throw StyleKitError.StyleFileNotFound("Invalid path URL: \(pathURL)")
            }
        } else {
            if let path = NSBundle.mainBundle().URLForResource(fileName, withExtension: nil) {
                return path
            } else {
                throw StyleKitError.StyleFileNotFound("Expected to find Style.json in the bundle")
            }
        }
    }
    
    private func serialize() {
        
        do {
            let stylePath = try self.getStylePath()
            let data = try NSData(contentsOfURL: stylePath, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            if let fontConfigs = json[CommonObjects.Fonts.rawValue] as? [String: String] {
                let allFontNames = UIFont.familyNames().reduce([]) {
                    $0 + UIFont.fontNamesForFamilyName($1)
                }
                for fontName in fontConfigs.values {
                    guard allFontNames.contains(fontName) else {
                        print("StyleKit: Warning: '\(fontName)' Font referenced in Style.json is not a valid font.")
                        continue
                    }
                }
                resources.fontLabels = fontConfigs
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
                    case .textView:
                        styles[labelKey] = try TextViewStyle.serialize(specification, resources: resources) as AnyObject
                    }
                }
                styleMap[element] = styles
            }
        } catch {
            if let error = error as? StyleKitError {
                switch error {
                case .StyleFileNotFound(let str):
                    print("StyleKit:Error: " + str)
                default:
                    break
                }
            }

            assert(false, "error serializing JSON: \(error)")
        }
    }
    
    //---------------------------------------------
    // MARK: - Serialize JSON into Objects (Common)
    //---------------------------------------------
    
    static func serializeColorsSpec(spec: [String:String], resources:CommonResources) -> ColorStyle? {
        
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
        
    static func serializeFontSpec(spec: [String:AnyObject], resources:CommonResources) -> FontStyle? {

        if let nameKey = spec[FontProperty.name.rawValue] as? String {
            if let fontName = resources.fontLabels[nameKey] {
                if let size = spec[FontProperty.size.rawValue] as? Int {
                    return FontStyle(fontName: fontName, size: size)
                } else {
                    print("StyleKit:Warning: fontStyle for '\(nameKey)' must include a font 'size' parameter")
                }
            } else {
                print("StyleKit:Warning: '\(nameKey)' alias must be defined under 'Fonts' ")
            }
        }
        return nil
    }
    
}

extension Style {
    
    /**
         You may register for changes to the stylesheet by implementing the `StyleKitSubscriber` protocol and calling `addSubscriber`.
         
         StyleKit.sharedInstance.addSubscriber(self)
         
         Call 'removeSubscriber(subscriber: StyleKitSubscriber)' to unregister
    */
    func addSubscriber(subscriber: StyleKitSubscriber) {
        if !subscribers.containsObject(subscriber) {
            subscribers.addObject(subscriber)
        }
    }

    /**
        Removes a subscriber from the list of subscribers
     */
    func removeSubscriber(subscriber: StyleKitSubscriber) {
        if subscribers.containsObject(subscriber) {
            subscribers.removeObject(subscriber)
        }
    }

    /**
        Call this if the stylesheet has changed.
     
        StyleKit.sharedInstance.refresh()
     
        Since the bundle is readonly, the stylesheet must be at the location specified in the applications plist file for the key 'StyleKit-StylesheetLocation'. The new stylesheet will **not** automatically get applied to views which have already been tagged/styled. To restyle a view which has already been tagged/styled, call `style()` on the view.
     
        You may register for changes to the stylesheet by implementing the `StyleKitSubscriber` protocol and calling `addSubscriber`.
     
            StyleKit.sharedInstance.addSubscriber(self)
    */
    func refresh() {
        serialize()
        let enumerator = subscribers.objectEnumerator()
        while let subscriber = enumerator.nextObject() as? StyleKitSubscriber {
            subscriber.update()
        }
    }
    
}
