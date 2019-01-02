
import Foundation
import UIKit

internal struct Utils {
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alph: Float) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alph))
    }
    
    convenience init(withHex:Int, alpha:Float) {
        self.init(red:(withHex >> 16) & 0xff,
                  green:(withHex >> 8) & 0xff,
                  blue:withHex & 0xff,
                  alph: alpha)
    }
}

extension String {
    /// Converts hex format `#123ABC` or `123ABC` to Int value
    func hexColorToInt() -> Int? {
        guard dropPoundPrefix.count == 6 else { return nil }
        return dropPoundPrefix.hexaToDecimal
    }
}

extension String {
    var dropPoundPrefix:       String { return hasPrefix("#") ? String(self.dropFirst(1)) : self }
    var drop0xPrefix:          String { return hasPrefix("0x") ? String(self.dropFirst(2)) : self }
    var drop0bPrefix:          String { return hasPrefix("0b") ? String(self.dropFirst(2)) : self }
    var hexaToDecimal:            Int { return Int(drop0xPrefix, radix: 16) ?? 0 }
    var hexaToBinaryString:    String { return String(hexaToDecimal, radix: 2) }
    var decimalToHexaString:   String { return String(Int(self) ?? 0, radix: 16) }
    var decimalToBinaryString: String { return String(Int(self) ?? 0, radix: 2) }
    var binaryToDecimal:          Int { return Int(drop0bPrefix, radix: 2) ?? 0 }
    var binaryToHexaString:    String { return String(binaryToDecimal, radix: 16) }
}

extension Int {
    var toBinaryString: String { return String(self, radix: 2) }
    var toHexaString:   String { return String(self, radix: 16) }
}

extension UIImage {
    
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
