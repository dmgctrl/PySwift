import UIKit

class TextViewsViewController: UIViewController {
    
    @IBOutlet var textViews: [UITextView]! {
        didSet {
            var info = [String: UITextView]()
            for textView in textViews {
                if let styleTag = textView.styleTag {
                    info[styleTag] = textView
                }
            }
            Style.sharedInstance.style(withTextViewsAndStyles: info)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
