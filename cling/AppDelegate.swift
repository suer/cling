import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        let mainViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
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
    }

    func applicationWillTerminate(application: UIApplication!) {
    }
}

