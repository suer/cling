import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {
    private let groupName = "group.org.codefirst.ClingExtension"
    private let keyURLs = "urls"

    var extensionContext: NSExtensionContext?
    
    func beginRequestWithExtensionContext(context: NSExtensionContext) {
        self.extensionContext = context
        let item = extensionContext?.inputItems.first as? NSExtensionItem
        for attachment in item!.attachments! {
            if let itemProvider = attachment as? NSItemProvider {
                if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                    itemProvider.loadItemForTypeIdentifier("public.url", options: nil, completionHandler: {
                        (urlItem, error) in
                        if let url = urlItem as? NSURL {
                            self.addURL(url.absoluteString ?? "")
                        }
                    })
                    break
                }
            }
        }
    }

    func addURL(url: String) {
        let userDefaults = NSUserDefaults(suiteName: groupName)
        var urls = userDefaults.arrayForKey(keyURLs)
        if urls == nil {
            urls = NSMutableArray()
        }
        let mutableUrls = NSMutableArray(array: urls!)
        mutableUrls.addObject(url)
        userDefaults.setObject(mutableUrls, forKey: keyURLs)
        userDefaults.synchronize()
    }

    func itemLoadCompletedWithPreprocessingResults(javaScriptPreprocessingResults: [NSObject: AnyObject]) {
    }
}
