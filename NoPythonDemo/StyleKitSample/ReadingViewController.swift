import UIKit


class ReadingViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reader"
        self.setDayTimeReading()
    }
    
    
    @IBAction func switchChanged(sender: AnyObject) {
        guard let theSwitch = sender as? UISwitch else {
            return
        }

        if theSwitch.on {
            UIView.animateWithDuration(0.25) {
                self.setNightTimeReading()
            }
        } else {
            UIView.animateWithDuration(0.25) {
                self.setDayTimeReading()
            }
        }
    }
    
    func setNightTimeReading() {
        self.textView.styleTag = "NightTimeReading"
        self.view.styleTag = "NightTimeReading"
    }

    func setDayTimeReading() {
        self.textView.styleTag = "DayTimeReading"
        self.view.styleTag = "DayTimeReading"
    }

}
