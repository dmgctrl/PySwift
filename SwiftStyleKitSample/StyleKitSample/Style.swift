import UIKit

class Style: NSObject {
    
    static let sharedInstance = Style()
    
    private var fonts = [String: String]()
    private var colors = [String: UIColor]()
    private var imageNames: [String: String]?
    private var labelStyles = [String: [String:AnyObject]]()
    private var buttonStyles = [String: [String:AnyObject]]()
    private var textFieldStyles = [String: [String:AnyObject]]()
    private var segmentedControlStyles = [String: [String: AnyObject]]()
    private var sliderStyles = [String: [String: AnyObject]]()
    private var stepperStyles: [String: [String: AnyObject]]?
    private var progressViewStyles: [String: [String: AnyObject]]?
    private var textViewStyles: [String: [String: AnyObject]]?
    
    override init() {
        super.init()
        deserialize()
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
    
    func deserialize() {
        
        let stylePath = configurationStyleURL()!
        
        do {
            
            let data = try NSData(contentsOfURL: stylePath, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            if let items = json[CommonObjects.Fonts.rawValue] as? [String: String] {
                fonts = items
            }
            
            if let colorDict = json[CommonObjects.Colors.rawValue] as? [String: [String: Int]] {
                for (colorKey, components) in colorDict {
                    if let red = components[ColorProperties.Red.rawValue],
                        let green = components[ColorProperties.Green.rawValue],
                        let blue = components[ColorProperties.Blue.rawValue],
                        let alpha = components[ColorProperties.Alpha.rawValue] {
                            colors[colorKey] = UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha))
                    }
                }
            }
            
            imageNames = json[CommonObjects.Images.rawValue] as? [String: String]
            
            if let labelDict = json[UIElements.Labels.rawValue] as? [String: [String:AnyObject]] {
                for (labelKey, specification) in labelDict {
                    labelStyles[labelKey] = serializeLabelSpec(specification)
                }
            }
            
            if let buttonDict = json[UIElements.Buttons.rawValue] as? [String: [String:AnyObject]] {
                for (buttonKey, specification) in buttonDict {
                    buttonStyles[buttonKey] = specification
                }
            }
            
            if let textFieldDict = json[UIElements.TextFields.rawValue] as? [String: [String:AnyObject]] {
                for (textFieldKey, specification) in textFieldDict {
                    if let spec = serializeTextFieldSpec(specification) {
                        textFieldStyles[textFieldKey] = spec
                    }
                }
            }
            
            if let segmentedControlDict = json[UIElements.SegmentedControls.rawValue] as? [String: [String: AnyObject]] {
                for (segmentedControlKey, specification) in segmentedControlDict {
                    segmentedControlStyles[segmentedControlKey] = specification
                }
            }
            
            if let sliderDict = json[UIElements.Sliders.rawValue] as? [String: [String: AnyObject]] {
                for (sliderKey, specification) in sliderDict {
                    sliderStyles[sliderKey] = specification
                }
            }
            
            if let stepperDict = json[UIElements.Steppers.rawValue] as? [String: [String: AnyObject]] {
                var theStepperStyles = [String: [String: AnyObject]]()
                
                for (stepperKey, specification) in stepperDict {
                    theStepperStyles[stepperKey] = specification
                }
                
                stepperStyles = theStepperStyles
            }
            
            if let progressViewDict = json[UIElements.ProgressViews.rawValue] as? [String: [String: AnyObject]] {
                var theProgressViewStyles = [String: [String: AnyObject]]()
                
                for (progressViewKey, specification) in progressViewDict {
                    theProgressViewStyles[progressViewKey] = specification
                }
                
                progressViewStyles = theProgressViewStyles
            }
            
            if let textViewDict = json[UIElements.TextViews.rawValue] as? [String: [String: AnyObject]] {
                var theTextViewStyles = [String: [String: AnyObject]]()
                
                for (textViewKey, specification) in textViewDict {
                    theTextViewStyles[textViewKey] = specification
                }
                
                textViewStyles = theTextViewStyles
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
    
    func serializeTextFieldSpec(spec: [String:AnyObject]) -> [String:AnyObject]? {
        var result = [String:AnyObject]()
        for (key,value) in spec {
            guard let theKey = TextFieldProperties(rawValue: key) else {
                return nil
            }
            
            switch theKey {
                case TextFieldProperties.FontStyle:
                    if let nameKey = value[FontProperties.Name.rawValue] as? String,
                        font = fonts[nameKey],
                        size = value[FontProperties.Size.rawValue] as? Int {
                            result[key] = FontStyle(fontName: font, size: size)
                    } else {
                        assert(false, "invalid option for key: \(key)")
                    }
                case TextFieldProperties.BorderWidth:
                    result[key] = spec[key]
                case TextFieldProperties.TextColor:
                    if let colorKey = value as? String, color = colors[colorKey]  {
                        result[key] = color
                    } else {
                        assert(false, "invalid option for key: \(key)")
                    }
                case TextFieldProperties.BorderColor:
                    if let colorKey = value as? String, color = colors[colorKey]  {
                        result[key] = color
                    } else {
                        assert(false, "invalid option for key: \(key)")
                    }
                case TextFieldProperties.TextAlignment:
                    let allowedValues = ["Left","Center","Right","Justified","Natural"]
                    if allowedValues.contains(value as! String) {
                        result[key] = allowedValues.indexOf(value as! String)
                    } else {
                        assert(false, "invalid option for key: \(key)")
                    }
                case TextFieldProperties.BorderStyle:
                    let allowedValues = ["None","Line","Bezel","RoundedRect"]
                    if allowedValues.contains(value as! String) {
                        result[key] = allowedValues.indexOf(value as! String)
                    } else {
                        assert(false, "invalid option for key: \(key)")
                    }
                case TextFieldProperties.CornerRadius:
                    result[key] = spec[key]
            }
        }
        
        return result
    }
    
    func serializeLabelSpec(spec: [String:AnyObject]) -> [String:AnyObject] {
        var result = [String:AnyObject]()
        for (key,value) in spec {
            switch key {
            case LabelProperties.FontStyle.rawValue:
                if let nameKey = value[FontProperties.Name.rawValue] as? String,
                    font = fonts[nameKey],
                    size = value[FontProperties.Size.rawValue] as? Int {
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
    
    //MARK: Apply values to properties related to states
    
    private func assignTitleColor(toButton button: UIButton, withColorsAndStates info: [String: String]) {
        for (stateKey, colorKey) in info {
            guard let state = ButtonAllowedStates(rawValue: stateKey), color = colors[colorKey] else {
                continue
            }
            
            switch state {
            case .Normal:
                button.setTitleColor(color, forState: .Normal)
            case .Highlighted:
                button.setTitleColor(color, forState: .Highlighted)
            case .Disabled:
                button.setTitleColor(color, forState: .Disabled)
            case .Selected:
                button.setTitleColor(color, forState: .Selected)
            }
        }
    }
    
    private func assignIncrementImage(toStepper stepper: UIStepper, withImagesAndStates info: [String: String]) {
        for (stateKey, imageKey) in info {
            guard let state = StepperAllowedStates(rawValue: stateKey), theImageNames = imageNames, imageName = theImageNames[imageKey] else {
                continue
            }
            
            switch state {
            case .Normal:
                stepper.setIncrementImage(UIImage(named: imageName), forState: .Normal)
            case .Highlighted:
                stepper.setIncrementImage(UIImage(named: imageName), forState: .Highlighted)
            case .Disabled:
                stepper.setIncrementImage(UIImage(named: imageName), forState: .Disabled)
            }
        }
    }
    
    private func assignDecrementImage(toStepper stepper: UIStepper, withImagesAndStates info: [String: String]) {
        for (stateKey, imageKey) in info {
            guard let state = StepperAllowedStates(rawValue: stateKey), theImageNames = imageNames, imageName = theImageNames[imageKey] else {
                continue
            }
            
            switch state {
            case .Normal:
                stepper.setDecrementImage(UIImage(named: imageName), forState: .Normal)
            case .Highlighted:
                stepper.setDecrementImage(UIImage(named: imageName), forState: .Highlighted)
            case .Disabled:
                stepper.setDecrementImage(UIImage(named: imageName), forState: .Disabled)
            }
        }
    }
    
    private func assignBackgroundImage(toStepper stepper: UIStepper, withImagesAndStates info: [String: String]) {
        for (stateKey, imageKey) in info {
            guard let state = StepperAllowedStates(rawValue: stateKey), theImageNames = imageNames, imageName = theImageNames[imageKey] else {
                continue
            }
            
            switch state {
            case .Normal:
                stepper.setBackgroundImage(UIImage(named: imageName), forState: .Normal)
            case .Highlighted:
                stepper.setBackgroundImage(UIImage(named: imageName), forState: .Highlighted)
            case .Disabled:
                stepper.setBackgroundImage(UIImage(named: imageName), forState: .Disabled)
            }
        }
    }
    
    //MARK: Apply Styles
    
    func style(withLabelsAndStyles labelInfo: [String: UILabel]?) {
        guard let info = labelInfo else {
            return
        }
        
        for (styleKey, element) in info {
            guard let styles = labelStyles[styleKey] else {
                continue
            }
            
            for (property, value) in styles {
                guard let theProperty = LabelProperties(rawValue: property) else {
                    continue
                }
                
                switch theProperty {
                    case LabelProperties.FontStyle:
                        if let fontStyle = value as? FontStyle {
                            element.font = UIFont(name: fontStyle.fontName, size: CGFloat(fontStyle.size))
                        }
                }
            }
        }
    }
    
    func style(withButtonsAndStyles buttonInfo: [String: UIButton]?) {
        guard let info = buttonInfo else {
            return
        }
        
        for (styleKey, element) in info {
            guard let styles = buttonStyles[styleKey] else {
                continue
            }
            
            for (property, value) in styles {
                guard let theProperty = ButtonProperties(rawValue: property) else {
                    continue
                }
                
                switch theProperty {
                    case .FontStyle:
                        if let info = value as? [String: AnyObject] {
                            guard let nameKey = info[FontProperties.Name.rawValue] as? String, name = fonts[nameKey],
                                size = info[FontProperties.Size.rawValue] as? Int else {
                                continue
                            }
                            element.titleLabel?.font = UIFont(name: name, size: CGFloat(size))
                        }
                    case .BorderWidth:
                        if let borderWidth = value as? Int {
                            element.layer.borderWidth = CGFloat(borderWidth)
                        }
                    case .BorderColor:
                        if let borderColor = value as? UIColor {
                            element.layer.borderColor = borderColor.CGColor
                        }
                    case .CornerRadius:
                        if let cornerRadius = value as? Int {
                            element.layer.cornerRadius = CGFloat(cornerRadius)
                        }
                    case .TitleColor:
                        if let colorInfo = value as? [String: String] {
                            self.assignTitleColor(toButton: element, withColorsAndStates: colorInfo)
                        }
                }
            }
        }
    }
    
    func style(withTextFieldsAndStyles textFieldInfo: [String: UITextField]?) {
        guard let info = textFieldInfo else {
            return
        }
        
        for (styleKey, element) in info {
            guard let styles = textFieldStyles[styleKey] else {
                continue
            }
            
            for (property, value) in styles {
                guard let theProperty = TextFieldProperties(rawValue: property) else {
                    continue
                }
                
                switch theProperty {
                    case TextFieldProperties.FontStyle:
                        if let fontStyle = value as? FontStyle {
                            element.font = UIFont(name: fontStyle.fontName, size: CGFloat(fontStyle.size))
                        }
                    case TextFieldProperties.BorderWidth:
                        if let borderWidth = value as? Int {
                            element.layer.borderWidth = CGFloat(borderWidth)
                        }
                    case TextFieldProperties.BorderColor:
                        if let borderColor = value as? UIColor {
                            element.layer.borderColor = borderColor.CGColor
                        }
                    case TextFieldProperties.TextAlignment:
                        if let aValue = value as? Int {
                            guard let textAlignment = NSTextAlignment(rawValue: aValue) else {
                                continue
                            }
                            element.textAlignment = textAlignment
                        }
                    case TextFieldProperties.BorderStyle:
                        if let aValue = value as? Int {
                            guard let textBorderStyle = UITextBorderStyle(rawValue: aValue) else {
                                continue
                            }
                            element.borderStyle = textBorderStyle
                        }
                    case TextFieldProperties.CornerRadius:
                        if let cornerRadius = value as? Int {
                            element.layer.cornerRadius = CGFloat(cornerRadius)
                        }
                    case TextFieldProperties.TextColor:
                        element.textColor = value as? UIColor
                }
            }
        }
    }
    
    func style(withSegmentedControlsAndStyles segmentedControlInfo: [String: UISegmentedControl]?) {
        guard let info = segmentedControlInfo else {
            return
        }
        
        for (styleKey, element) in info {
            guard let styles = segmentedControlStyles[styleKey] else {
                continue
            }
            
            var normalAttributes = [String: AnyObject]()
            var selectedAttributes = [String: AnyObject]()
            
            for (property, value) in styles {
                guard let theProperty = SegmentedControlProperties(rawValue: property) else {
                    continue
                }
                
                switch theProperty {
                    case .FontStyle:
                        guard let fontInfo = value as? [String: AnyObject], fontKey = fontInfo[FontProperties.Name.rawValue] as? String,
                            fontSize = fontInfo[FontProperties.Size.rawValue] as? Int else {
                            continue
                        }
                        guard let fontName = fonts[fontKey], font = UIFont(name: fontName, size: CGFloat(fontSize)) else {
                            continue
                        }
                        normalAttributes[NSFontAttributeName] = font
                        selectedAttributes[NSFontAttributeName] = font
                        
                    case .TextColor:
                        if let colorInfo = value as? [String: String] {
                            for (stateKey, colorKey) in colorInfo {
                                guard let state = SegmentedControlAllowedStates(rawValue: stateKey), color = colors[colorKey] else {
                                    continue
                                }
                                
                                switch state {
                                case .Normal:
                                    normalAttributes[NSForegroundColorAttributeName] = color
                                case .Selected:
                                    selectedAttributes[NSForegroundColorAttributeName] = color
                                }
                            }
                        }
                    
                    case .TintColor:
                        if let tintColorKey = value as? String, tintColor = colors[tintColorKey] {
                            element.tintColor = tintColor
                        }
                }
                
                element.setTitleTextAttributes(normalAttributes, forState: .Normal)
                element.setTitleTextAttributes(selectedAttributes, forState: .Selected)
            }
        }
    }
    
    func style(withSlidersAndStyles sliderInfo: [String: UISlider]?) {
        guard let info = sliderInfo else {
            return
        }
        
        for (styleKey, element) in info {
            guard let styles = sliderStyles[styleKey] else {
                return
            }
            
            guard let theImageNames = imageNames else {
                return
            }
            
            for (property, value) in styles {
                guard let theProperty = SliderProperties(rawValue: property) else {
                    return
                }
                
                switch theProperty {
                    case .MaximumTrackTintColor:
                        if let colorKey = value as? String, color = colors[colorKey] {
                            element.maximumTrackTintColor = color
                        }
                    case .MinimumTrackTintColor:
                        if let colorKey = value as? String, color = colors[colorKey] {
                            element.minimumTrackTintColor = color
                        }
                    case .ThumbImage:
                        if let imageKey = value as? String, theImageNames = imageNames, imageName = theImageNames[imageKey] {
                            element.setThumbImage(UIImage(named: imageName), forState: .Normal)
                        }
                    case .MinimumTrackImage:
                        if let imageKey = value as? String, imageName = theImageNames[imageKey] {
                            element.setMinimumTrackImage(UIImage(named: imageName), forState: .Normal)
                        }
                    case .MaximumTrackImage:
                        if let imageKey = value as? String, imageName = theImageNames[imageKey] {
                            element.setMaximumTrackImage(UIImage(named: imageName), forState: .Normal)
                        }
                }
            }
        }
        
    }
    
    func style(withSteppersAndStyles stepperInfo: [String: UIStepper]?) {
        guard let info = stepperInfo, theStepperStyles = stepperStyles else {
            return
        }
        
        for (styleKey, element) in info {
            guard let styles = theStepperStyles[styleKey] else {
                continue
            }
            
            for (property, value) in styles {
                guard let theProperty = StepperProperties(rawValue: property) else {
                    continue
                }
                
                switch theProperty {
                    case .TintColor:
                        if let colorKey = value as? String, color = colors[colorKey] {
                            element.tintColor = color
                        }
                    case .IncrementImage:
                        if let imageInfo = value as? [String: String] {
                            self.assignIncrementImage(toStepper: element, withImagesAndStates: imageInfo)
                        }
                    case .DecrementImage:
                        if let imageInfo = value as? [String: String] {
                            self.assignDecrementImage(toStepper: element, withImagesAndStates: imageInfo)
                        }
                    case .BackgroundImage:
                        if let imageInfo = value as? [String: String] {
                            self.assignBackgroundImage(toStepper: element, withImagesAndStates: imageInfo)
                        }
                }
            }
        }
    }
    
    func style(withProgressViewsAndStyles progressViewInfo: [String: UIProgressView]?) {
        guard let info = progressViewInfo, theProgressViewStyles = progressViewStyles else {
            return
        }
        
        for (styleKey, element) in info {
            guard let styles = theProgressViewStyles[styleKey] else {
                continue
            }
            
            for (property, value) in styles {
                guard let theProperty = ProgressViewProperties(rawValue: property) else {
                    continue
                }
                
                switch theProperty {
                    case .Style:
                        if let theValue = value as? Int, progressViewStyle = UIProgressViewStyle(rawValue: theValue) {
                            element.progressViewStyle = progressViewStyle
                        }
                    case .ProgressTintColor:
                        if let colorKey = value as? String, color = colors[colorKey] {
                            element.progressTintColor = color
                        }
                    case .TrackTintColor:
                        if let colorKey = value as? String, color = colors[colorKey] {
                            element.trackTintColor = color
                        }
                    case .ProgressImage:
                        if let imageKey = value as? String, imageName = imageNames?[imageKey] {
                            element.progressImage = UIImage(named: imageName)
                        }
                    case .TrackImage:
                        if let imageKey = value as? String, imageName = imageNames?[imageKey] {
                            element.trackImage = UIImage(named: imageName)
                        }
                }
            }
        }
    }
    
    func style(withTextViewsAndStyles textViewInfo: [String: UITextView]?) {
        guard let info = textViewInfo, theTextViewStyles = textViewStyles else {
            return
        }
        
        for (styleKey, element) in info {
            guard let styles = theTextViewStyles[styleKey] else {
                continue
            }
            
            for (property, value) in styles {
                guard let theProperty = TextViewProperties(rawValue: property) else {
                    continue
                }
                
                switch theProperty {
                case .TextColor:
                    if let colorKey = value as? String, color = colors[colorKey] {
                        element.textColor = color
                    }
                case .TextAlignment:
                    if let theValue = value as? Int, textAlignment = NSTextAlignment(rawValue: theValue) {
                        element.textAlignment = textAlignment
                    }
                case .FontStyle:
                    guard let fontInfo = value as? [String: AnyObject], fontKey = fontInfo[FontProperties.Name.rawValue] as? String,
                        fontSize = fontInfo[FontProperties.Size.rawValue] as? Int else {
                            continue
                    }
                    guard let fontName = fonts[fontKey], font = UIFont(name: fontName, size: CGFloat(fontSize)) else {
                        continue
                    }
                    element.font = font
                }
            }
        }
    }
    
}
