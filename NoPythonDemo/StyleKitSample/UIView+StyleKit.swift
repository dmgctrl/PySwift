
import UIKit

extension UIView {
    private struct AssociatedKeys {
        static var styleTag = ""
    }
    
    /**
         Setting the styleTag automatically applies styles as defined in the stylesheet
    */
    @IBInspectable var styleTag: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.styleTag) as? String
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self,
                    &AssociatedKeys.styleTag,
                    newValue as NSString?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
                self.style()
            }
        }
    }
}
