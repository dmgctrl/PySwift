
import Foundation

extension Utils {
    
    
    static func copyStyleFileFromBundle() {
        
        if let relativePath = NSBundle.mainBundle().infoDictionary?[Style.styleSheetLocation] as? String,
        let srcDir = NSBundle.mainBundle().URLForResource("Style", withExtension: "json"),
            let destDir = Utils.documentDirectory?.URLByAppendingPathComponent(relativePath) {
            Utils.copyStyleFile(from: srcDir, to: destDir)
        }
    }
    
    static func copyStyleFile(from srcURL: NSURL, to destURL: NSURL) {
        let fileManager = NSFileManager.defaultManager()
        
        if fileManager.fileExistsAtPath(destURL.path!) {
            do {
                try fileManager.removeItemAtURL(destURL)
            } catch let error {
                print(error)
            }
        }
        
        do {
            if let path = destURL.path where !path.hasSuffix(".json") {
                try fileManager.createDirectoryAtURL(destURL, withIntermediateDirectories: false, attributes: nil)
                try fileManager.copyItemAtURL(srcURL, toURL: destURL.URLByAppendingPathComponent("Style.json")!)
            } else {
                try fileManager.copyItemAtURL(srcURL, toURL: destURL)
            }
        } catch let error {
            print(error)
        }
    }
    
    static func downloadStyleFile() {
        if let string = NSBundle.mainBundle().infoDictionary?[Style.styleSheetLocation] as? String {
            if let url = NSURL(string:"https://dl.dropboxusercontent.com/u/26582460/Style.json") {
                NSURLSession.sharedSession().downloadTaskWithURL(url, completionHandler: { tempFileDirectory, response, error in
                    if error == nil {
                        if let srcDirectory = tempFileDirectory, destDirectory = Utils.documentDirectory?.URLByAppendingPathComponent(string) {
                            Utils.copyStyleFile(from: srcDirectory, to: destDirectory)
                            dispatch_async(dispatch_get_main_queue(), {
                                Style.sharedInstance.refresh()
                            })
                        }
                    } else {
                        print("\(error)")
                    }
                }).resume()
            }
        }
    }
    
}
