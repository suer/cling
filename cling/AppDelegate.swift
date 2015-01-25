import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let groupName = "group.org.codefirst.ClingExtension"
    private let keyURLs = "urls"

    var window: UIWindow?

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        MagicalRecord.setupCoreDataStackWithStoreNamed("cling.sqlite3")
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        let navigationController = UINavigationController(rootViewController: ViewControllers.sharedInstance.mainViewController)
        window!.addSubview(navigationController.view)
        window!.rootViewController = navigationController
        return true
    }

    func applicationWillResignActive(application: UIApplication!) {
    }

    func applicationDidEnterBackground(application: UIApplication!) {
    }

    func applicationWillEnterForeground(application: UIApplication!) {
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        let userDefaults = NSUserDefaults(suiteName: groupName)
        var urls = userDefaults?.arrayForKey(keyURLs)
        if urls == nil || urls!.isEmpty {
            return
        }

        for url in urls! {
            let urlString = url as String
            if !urlString.isEmpty {
                PageWrapper.createRecord(url as String)
            }
        }
        userDefaults?.setObject(NSMutableArray(), forKey: keyURLs)
        ViewControllers.sharedInstance.mainViewController.bufferedWebView?.loadUrls()
        ViewControllers.sharedInstance.mainViewController.restartTimer()
    }

    func applicationWillTerminate(application: UIApplication!) {
        MagicalRecord.cleanUp()
    }
}

