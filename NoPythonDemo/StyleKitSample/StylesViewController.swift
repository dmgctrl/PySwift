
import UIKit

class StylesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!

    var sectionHeaders = Array(Style.sharedInstance.styleMap.keys)
    var styleMap = Style.sharedInstance.styleMap
    var resources:[String:AnyObject] = ["Colors":Array(Style.sharedInstance.resources.colors.keys),
                                        "Fonts":Array(Style.sharedInstance.resources.fontLabels.keys),
                                        "Images":Array(Style.sharedInstance.resources.imageNames.keys)]
    
    
    @IBAction func buttonTapped(sender: AnyObject) {
        Utils.downloadStyleFile()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Styles Preview"
        Style.sharedInstance.addSubscriber(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
        
    func updateUI() {
        sectionHeaders = Array(Style.sharedInstance.styleMap.keys)
        styleMap = Style.sharedInstance.styleMap
        resources = ["Colors":Array(Style.sharedInstance.resources.colors.keys),
                                            "Fonts":Array(Style.sharedInstance.resources.fontLabels.keys),
                                            "Images":Array(Style.sharedInstance.resources.imageNames.keys)]
        tableView.reloadData()
    }
}

extension StylesViewController: StyleKitSubscriber {
    func update() {
        self.updateUI()
    }
}

extension StylesViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch sectionHeaders[indexPath.section] {
        case .button, .view, .textField:
            return 70.0
        default:
            return 54.0
        }
    }
}

extension StylesViewController: UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let styles = styleMap[sectionHeaders[section]] {
            return styles.keys.count
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let sectionHeader = sectionHeaders[indexPath.section]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("\(sectionHeader.rawValue)Cell", forIndexPath: indexPath)

        var styleTag = ""
        if let styles = styleMap[sectionHeader] {
            let allTags = Array(styles.keys)
            styleTag = allTags[indexPath.row]
            
            switch sectionHeader {
            case .button:
                (cell as! ButtonTableViewCell).button.styleTag = styleTag
                (cell as! ButtonTableViewCell).button.setTitle(styleTag, forState: .Normal)
            case .segmentedControl:
                (cell as! SegmentedControlsTableViewCell).segmentedControl.styleTag = styleTag
                (cell as! SegmentedControlsTableViewCell).label.text = styleTag
            case .textField:
                (cell as! TextFieldsTableViewCell).textField.styleTag = styleTag
                (cell as! TextFieldsTableViewCell).textField.text = styleTag
            case .label:
                (cell as! LabelsTableViewCell).label.styleTag = styleTag
                (cell as! LabelsTableViewCell).label.text = styleTag
            case .slider:
                (cell as! SlidersTableViewCell).slider.styleTag = styleTag
                (cell as! SlidersTableViewCell).label.text = styleTag
            case .stepper:
                (cell as! SteppersTableViewCell).stepper.styleTag = styleTag
                (cell as! SteppersTableViewCell).label.text = styleTag
            case .progressView:
                (cell as! ProgressViewsTableViewCell).progressView.styleTag = styleTag
                (cell as! ProgressViewsTableViewCell).label.text = styleTag
            case .view:
                (cell as! ViewsTableViewCell).view.styleTag = styleTag
                (cell as! ViewsTableViewCell).label.text = styleTag
            case .textView:
                (cell as! TextViewsTableViewCell).textView.styleTag = styleTag
                (cell as! TextViewsTableViewCell).textView.text = styleTag
            }
        }
                
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section].rawValue
    }
}
