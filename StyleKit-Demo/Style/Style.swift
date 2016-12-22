import UIKit

class Style: NSObject {

    static let sharedInstance = Style()    
    
    let primaryFontMedium: String = "BrandonGrotesque-Medium"    
    let primaryFontBlack: String = "BrandonGrotesque-Black"    
    let primaryFontLight: String = "BrandonGrotesque-Light"    
    let primaryFontLightItalic: String = "BrandonGrotesque-LightItalic"    
    let primaryFontBold: String = "BrandonGrotesque-Bold"    
    
    let purpleColor = UIColor(red: 162.0/255.0, green: 57.0/255.0, blue: 181.0/255.0, alpha: 1.0)    
    let blueColor = UIColor(red: 0.0/255.0, green: 84.0/255.0, blue: 136.0/255.0, alpha: 1.0)    
    let blackColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)    
    let clearColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.1)    
    let greenColor = UIColor(red: 73.0/255.0, green: 185.0/255.0, blue: 58.0/255.0, alpha: 1.0)    
    let lightGrayColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)    
    let whiteColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)    
    let lightBlueColor = UIColor(red: 139.0/255.0, green: 192.0/255.0, blue: 224.0/255.0, alpha: 0.8)    
    
    let thumbImageDefault = UIImage(named: "greenThumbImage")    
    let buttonImage1 = UIImage(named: "black_button_image")    
    
    @IBOutlet var H2Label: [UILabel]! {        
        didSet {            
            styleH2Label(H2Label)            
        }        
    }    
    
    @IBOutlet var H1Label: [UILabel]! {        
        didSet {            
            styleH1Label(H1Label)            
        }        
    }    
    
    @IBOutlet var specialView: [UIView]! {        
        didSet {            
            stylespecialView(specialView)            
        }        
    }    
    
    @IBOutlet var B1Button: [UIButton]! {        
        didSet {            
            styleB1Button(B1Button)            
        }        
    }    
    
    @IBOutlet var B2Button: [UIButton]! {        
        didSet {            
            styleB2Button(B2Button)            
        }        
    }    
    
    @IBOutlet var T1TextField: [UITextField]! {        
        didSet {            
            styleT1TextField(T1TextField)            
        }        
    }    
    
    @IBOutlet var defaultSegmentedControl: [UISegmentedControl]! {        
        didSet {            
            styledefaultSegmentedControl(defaultSegmentedControl)            
        }        
    }    
    
    @IBOutlet var S1Slider: [UISlider]! {        
        didSet {            
            styleS1Slider(S1Slider)            
        }        
    }    
    
    func attributesForH2Label() ->  Dictionary<String, AnyObject> {         
        let style = NSMutableParagraphStyle()        
        style.alignment = NSTextAlignment.Center        
        style.lineSpacing = 5        
        let attributes = [             
            NSFontAttributeName: UIFont(name: primaryFontLight, size: 18)!,            
            NSKernAttributeName: 1.08,            
            NSParagraphStyleAttributeName: style,            
         ]        
        return attributes        
    }    
    
    func styleH2Label(objects: [UILabel]) {        
        for object in objects {        
            object.textColor = greenColor            
            if let text = object.text {            
                object.attributedText = NSAttributedString(string: text, attributes:attributesForH2Label())                
            }            
        }        
    }    
    
    func attributesForH1Label() ->  Dictionary<String, AnyObject> {         
        let style = NSMutableParagraphStyle()        
        style.alignment = NSTextAlignment.Center        
        style.lineSpacing = 5        
        let attributes = [             
            NSFontAttributeName: UIFont(name: primaryFontMedium, size: 22)!,            
            NSKernAttributeName: 2.2,            
            NSParagraphStyleAttributeName: style,            
         ]        
        return attributes        
    }    
    
    func styleH1Label(objects: [UILabel]) {        
        for object in objects {        
            object.textColor = blueColor            
            if let text = object.text {            
                object.attributedText = NSAttributedString(string: text, attributes:attributesForH1Label())                
            }            
        }        
    }    
    
    func styleS1Slider(objects: [UISlider]) {        
        for object in objects {        
            object.minimumTrackTintColor = purpleColor            
            object.maximumTrackTintColor = greenColor            
            object.setThumbImage(thumbImageDefault, forState: UIControlState.Normal)            
        }        
    }    
    
    func stylespecialView(objects: [UIView]) {        
        for object in objects {        
            object.backgroundColor = lightGrayColor            
            object.layer.cornerRadius = 10            
            object.layer.borderColor = blueColor.CGColor            
            object.layer.borderWidth = 2            
        }        
    }    
    
    func styleB1Button(objects: [UIButton]) {        
        for object in objects {        
            object.layer.cornerRadius = 10            
            object.layer.borderColor = blueColor.CGColor            
            object.layer.borderWidth = 3            
            object.layer.masksToBounds = true            
            object.titleLabel?.font = UIFont(name: primaryFontMedium, size: 22)            
            object.layer.cornerRadius = 10            
            object.layer.borderColor = blueColor.CGColor            
            object.layer.borderWidth = 3            
            object.setTitleColor(whiteColor, forState: .Normal)            
            object.setBackgroundImage(UIImage.imageWithColor(blueColor), forState: .Normal)            
            object.setTitleColor(blueColor, forState: .Highlighted)            
            object.setBackgroundImage(UIImage.imageWithColor(greenColor), forState: .Highlighted)            
            object.setTitleColor(purpleColor, forState: .Selected)            
            object.setBackgroundImage(UIImage.imageWithColor(blackColor), forState: .Selected)            
        }        
    }    
    
    func styleB2Button(objects: [UIButton]) {        
        for object in objects {        
            object.layer.cornerRadius = 5            
            object.layer.borderColor = purpleColor.CGColor            
            object.layer.masksToBounds = true            
            object.titleLabel?.font = UIFont(name: primaryFontBold, size: 16)            
            object.layer.cornerRadius = 5            
            object.layer.borderColor = purpleColor.CGColor            
            object.setTitleColor(blackColor, forState: .Normal)            
            object.setBackgroundImage(UIImage.imageWithColor(blueColor), forState: .Normal)            
            object.setTitleColor(whiteColor, forState: .Highlighted)            
            object.setBackgroundImage(UIImage.imageWithColor(purpleColor), forState: .Highlighted)            
            object.setTitleColor(purpleColor, forState: .Selected)            
            object.setBackgroundImage(UIImage.imageWithColor(blackColor), forState: .Selected)            
        }        
    }    
    
    func styleT1TextField(objects: [UITextField]) {        
        for object in objects {        
            object.backgroundColor = lightBlueColor            
            object.layer.cornerRadius = 10            
            object.layer.borderColor = greenColor.CGColor            
            object.layer.borderWidth = 3            
            object.textColor = whiteColor            
            object.backgroundColor = lightBlueColor            
            object.font = UIFont(name: primaryFontMedium, size: 17)            
            object.textAlignment = NSTextAlignment.Center            
            object.borderStyle = UITextBorderStyle.None            
            object.layer.cornerRadius = 10            
            object.layer.borderColor = greenColor.CGColor            
            object.layer.borderWidth = 3            
        }        
    }    
    
    func styledefaultSegmentedControl(objects: [UISegmentedControl]) {        
        for object in objects {        
            object.setDividerImage(UIImage.imageWithColor(clearColor), forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: .Default)            
            object.setBackgroundImage(UIImage.imageWithColor(greenColor), forState: .Normal, barMetrics: .Default)            
            object.setTitleTextAttributes([NSFontAttributeName: UIFont(name: primaryFontBold, size: 15)!, NSForegroundColorAttributeName: whiteColor], forState: .Normal)            
            object.setBackgroundImage(UIImage.imageWithColor(blackColor), forState: .Highlighted, barMetrics: .Default)            
            object.setTitleTextAttributes([NSFontAttributeName: UIFont(name: primaryFontBold, size: 15)!, NSForegroundColorAttributeName: whiteColor], forState: .Highlighted)            
            object.setBackgroundImage(UIImage.imageWithColor(blueColor), forState: .Selected, barMetrics: .Default)            
            object.setTitleTextAttributes([NSFontAttributeName: UIFont(name: primaryFontBold, size: 15)!, NSForegroundColorAttributeName: whiteColor], forState: .Selected)            
        }        
    }    
    
}