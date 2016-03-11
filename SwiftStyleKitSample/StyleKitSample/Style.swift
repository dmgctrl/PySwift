import UIKit

class Style: NSObject {
    
    static let sharedInstance = Style()
    
    var fonts = [String: String]()
    var colors = [String: UIColor]()
    var imageNames: [String: String]? = nil
    var labelStyles = [String: [String:AnyObject]]()
    var buttonStyles = [String: [String:AnyObject]]()
    var textFieldStyles = [String: [String:AnyObject]]()
    
    override init() {
        super.init()
        serialize()
    }
    
    
    @IBOutlet var StyleLabel: [SKLabel]! {
        didSet {
            styleLabel(StyleLabel)
        }
    }
    
    @IBOutlet var StyleButton: [SKButton]! {
        didSet {
            styleButton(StyleButton)
        }
    }
    
    @IBOutlet var StyleTextField: [SKTextField]! {
        didSet {
            styleTextField(StyleTextField)
        }
    }
    
    //Mark: Serialize
    
    func configurationStyleURL() -> NSURL? {
        let documentsDirPath = urlForFileInDocumentsDirectory("Style.json")
        if NSFileManager.defaultManager().fileExistsAtPath(documentsDirPath.path!)   {
            return documentsDirPath
        }

        let bundlePath = NSBundle.mainBundle().pathForResource("Style", ofType: "json")
        return NSURL(fileURLWithPath: bundlePath!)
    }
    
    func urlForFileInDocumentsDirectory(fileName: String) -> NSURL {
        let docsDir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return docsDir.URLByAppendingPathComponent(fileName)
    }
    
    func serialize() {
        
        let stylePath = configurationStyleURL()!
        
        do {
            
            let data = try NSData(contentsOfURL: stylePath, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            if let items = json["Fonts"] as? [String: String] {
                fonts = items
            }
            
            if let colorDict = json["Colors"] as? [String: [String: Int]] {
                for (colorKey, components) in colorDict {
                    if let red = components["red"],
                        let green = components["green"],
                        let blue = components["blue"],
                        let alpha = components["alpha"] {
                            colors[colorKey] = UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha))
                    }
                }
            }
            
            imageNames = json["Images"] as? [String: String]
            
            if let labelDict = json["Labels"] as? [String: [String:AnyObject]] {
                for (labelKey, specification) in labelDict {
                    labelStyles[labelKey] = serializeLabelSpec(specification)
                }
            }
            
            if let buttonDict = json["Buttons"] as? [String: [String:AnyObject]] {
                for (labelKey, specification) in buttonDict {
                    buttonStyles[labelKey] = serializeButtonSpec(specification)
                }
            }
            
            if let itemDict = json["TextFields"] as? [String: [String:AnyObject]] {
                for (labelKey, specification) in itemDict {
                    textFieldStyles[labelKey] = serializeTextFieldSpec(specification)
                }
            }
            
        } catch {
            assert(false,"error serializing JSON: \(error)")
        }
    }
    
    class FontStyle {
        var fontName: String
        var size: Int
        init(fontName:String, size:Int)  {
            self.size = size
            self.fontName = fontName
        }
    }
    
    func serializeButtonSpec(spec: [String:AnyObject]) -> [String:AnyObject] {
        var result = [String:AnyObject]()
        for (key,value) in spec {
            switch key {
            case "fontStyle":
                if let nameKey = value["font"] as? String,
                    font = fonts[nameKey],
                    size = value["size"] as? Int {
                        result[key] = FontStyle(fontName: font, size: size)
                } else {
                    assert(false)
                }
            case "borderWidth":
                result[key] = spec[key]
            case "borderColor":
                if let colorKey = value as? String, color = colors[colorKey]  {
                    result[key] = color
                } else {
                    assert(false)
                }
            case "cornerRadius":
                result[key] = spec[key]
            case "normal":
                if let colorKey = value["titleColor"] as? String, color = colors[colorKey]  {
                    result[key] = color
                } else {
                    assert(false)
                }
            default:
                assert(false, "\(key) not Supported")
            }
        }
        return result
    }
    
    func serializeTextFieldSpec(spec: [String:AnyObject]) -> [String:AnyObject] {
        var result = [String:AnyObject]()
        for (key,value) in spec {
            switch key {
            case "fontStyle":
                if let nameKey = value["font"] as? String,
                    font = fonts[nameKey],
                    size = value["size"] as? Int {
                        result[key] = FontStyle(fontName: font, size: size)
                } else {
                    assert(false, "invalid option for key: \(key)")
                }
            case "borderWidth":
                result[key] = spec[key]
            case "textColor":
                if let colorKey = value as? String, color = colors[colorKey]  {
                    result[key] = color
                } else {
                    assert(false, "invalid option for key: \(key)")
                }
            case "borderColor":
                if let colorKey = value as? String, color = colors[colorKey]  {
                    result[key] = color
                } else {
                    assert(false, "invalid option for key: \(key)")
                }
            case "textAlignment":
                let allowedValues = ["Left","Center","Right","Justified","Natural"]
                if allowedValues.contains(value as! String) {
                    result[key] = allowedValues.indexOf(value as! String)
                } else {
                    assert(false, "invalid option for key: \(key)")
                }
            case "borderStyle":
                let allowedValues = ["None","Line","Bezel","RoundedRect"]
                if allowedValues.contains(value as! String) {
                    result[key] = allowedValues.indexOf(value as! String)
                } else {
                    assert(false, "invalid option for key: \(key)")
                }
            case "cornerRadius":
                result[key] = spec[key]
            default:
                assert(false, "\(key) not Supported")
            }
        }
        return result
    }
    
    func serializeLabelSpec(spec: [String:AnyObject]) -> [String:AnyObject] {
        var result = [String:AnyObject]()
        for (key,value) in spec {
            switch key {
            case "fontStyle":
                if let nameKey = value["font"] as? String,
                    font = fonts[nameKey],
                    size = value["size"] as? Int {
                        result[key] = FontStyle(fontName: font, size: size)
                } else {
                    assert(false)
                }
            default:
                assert(false, "\(key) not Supported")
            }
        }
        return result
    }
    
    //MARK: Apply Styles
    
    func styleLabel(objects: [SKLabel]) {
        
            for object in objects {
                if let styleTag = object.styleTag, styles = labelStyles[styleTag] {
                    for (key, value) in styles {
                        switch key {
                        case "fontStyle":
                            let name = (value as! FontStyle).fontName
                            let size = (value as! FontStyle).size
                            object.font = UIFont (name: name, size: CGFloat(size))
                        default:
                            assert(false, "\"\(key)\": Unknown Key")
                        }
                    }
                }
            }
        
    }
    

    func styleButton(objects: [SKButton]) {
        
        for object in objects {
            if let styleTag = object.styleTag, styles = buttonStyles[styleTag] {
                for (key, value) in styles {
                    switch key {
                    case "fontStyle":
                        let name = (value as! FontStyle).fontName
                        let size = (value as! FontStyle).size
                        object.titleLabel?.font = UIFont (name: name, size: CGFloat(size))
                    case "borderWidth":
                        object.layer.borderWidth = value as! CGFloat
                    case "borderColor":
                        object.layer.borderColor = (value as! UIColor).CGColor
                    case "cornerRadius":
                        object.layer.cornerRadius = value as! CGFloat
                    case "normal":
                        let color = value as! UIColor
                        object.setTitleColor(color, forState: .Normal)
                    default:
                        assert(false,"Unkown Key: \(key)")
                    }
                }
            }
        }
        
    }
    
    func styleTextField(objects: [SKTextField]) {
        for object in objects {
            if let styleTag = object.styleTag, styles = textFieldStyles[styleTag] {
                for (key, value) in styles {
                    switch key {
                    case "fontStyle":
                        let name = (value as! FontStyle).fontName
                        let size = (value as! FontStyle).size
                        object.font = UIFont (name: name, size: CGFloat(size))
                    case "borderWidth":
                        object.layer.borderWidth = value as! CGFloat
                    case "borderColor":
                        object.layer.borderColor = (value as! UIColor).CGColor
                    case "textAlignment":
                        let rawValue = value as! Int
                        object.textAlignment = NSTextAlignment(rawValue: rawValue)!
                    case "borderStyle":
                        let rawValue = value as! Int
                        object.borderStyle = UITextBorderStyle(rawValue: rawValue)!
                    case "cornerRadius":
                        object.layer.cornerRadius = value as! CGFloat
                    case "textColor":
                        object.textColor = value as? UIColor
                    default:
                        assert(false,"Unkown Key: \(key)")
                    }
                }
            }
        }
    }
}
