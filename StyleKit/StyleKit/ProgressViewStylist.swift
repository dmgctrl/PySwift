
import Foundation
import UIKit

class ProgressViewStyle : Stylist {
    
    typealias Element = UIProgressView
    
    var style: UIProgressView.Style?
    var progressTintColor: UIColor?
    var trackTintColor: UIColor?
    var progressImage: UIImage?
    var trackImage: UIImage?
    
    enum Properties: String {
        case Style = "style"
        case ProgressTintColor = "progressTintColor"
        case TrackTintColor = "trackTintColor"
        case ProgressImage = "progressImage"
        case TrackImage = "trackImage"
    }
    
    static let allValues:[Properties] = [.Style, .ProgressTintColor, .TrackTintColor, .ProgressImage, .TrackImage]
    
    static func serialize(_ spec: [String:AnyObject], resources:CommonResources) throws -> ProgressViewStyle {
        let style = ProgressViewStyle()
        for (key,value) in spec {
            guard let property = ProgressViewStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: StyleKit does not support \(key) on \(Element.self). Ignored.")
                continue
            }
            switch property {
            case .Style:
                if let theValue = value as? Int, let viewStyle = UIProgressView.Style(rawValue: theValue) {
                    style.style = viewStyle
                }
            case .ProgressTintColor:
                if let colorKey = value as? String, let color = resources.colors[colorKey] {
                    style.progressTintColor = color
                }
            case .TrackTintColor:
                if let colorKey = value as? String, let color = resources.colors[colorKey] {
                    style.trackTintColor = color
                }
            case .ProgressImage:
                if let imageKey = value as? String, let imageName = resources.imageNames[imageKey] {
                    style.progressImage = UIImage(named: imageName)
                }
            case .TrackImage:
                if let imageKey = value as? String, let imageName = resources.imageNames[imageKey] {
                    style.trackImage = UIImage(named: imageName)
                }
            }
        }
        return style
    }
}

extension UIProgressView {    
    func applyStyle(_ style:ProgressViewStyle, resources:CommonResources) {
        for property in ProgressViewStyle.allValues {
            switch property {
            case .Style:
                if let theValue = style.style {
                    self.progressViewStyle = theValue
                }
            case .ProgressTintColor:
                if let color = style.progressTintColor {
                    self.progressTintColor = color
                }
            case .TrackTintColor:
                if let color = style.trackTintColor {
                    self.trackTintColor = color
                }
            case .ProgressImage:
                if let image = style.progressImage {
                    self.progressImage = image
                }
            case .TrackImage:
                if let trackImage = style.trackImage {
                    self.trackImage = trackImage
                }
            }
        }
    }
}

