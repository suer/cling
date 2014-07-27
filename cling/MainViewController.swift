import UIKit
import QuartzCore

class MainViewController: UIViewController {
    private let rotationTime = 20.0
    var webView : UIWebView?
    var urls: [String] = []
    var timer: NSTimer?
    var selectedURLIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTabBar()
#if arch(i386) || arch(x86_64)
        FLEXManager.sharedManager().showExplorer()
#endif
    }

    override func viewWillAppear(animated: Bool) {
        loadUrls()
        loadWebView()
        setTimer()
    }
    
    func loadUrls() {
        urls = (Page.MR_findAll() as [Page]).map{(page: Page) -> String in
            page.url
        }.filter{(url: String) -> Bool in
            !url.isEmpty
        }
    }

    func loadTabBar() {
        let preferenceButton = UIBarButtonItem(title: "Preference", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("preferenceButtonTapped:"))
        navigationItem.rightBarButtonItem = preferenceButton
        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("nextButtonTapped:"))
        navigationItem.leftBarButtonItem = nextButton
    }
    
    private func setTimer() {
        if (timer == nil) {
            stopTimer()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(rotationTime, target: self, selector: Selector("flip"), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        if (timer != nil) {
            timer!.invalidate()
            timer = nil
        }
    }

    func loadWebView() {
        selectedURLIndex = 0
        var url = ""
        if (!urls.isEmpty) {
            url = urls[selectedURLIndex]
        }
        
        let navigationBarHeight = navigationController.navigationBar.frame.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        webView = UIWebView(frame: CGRectMake(
            0,
            0,
            view.bounds.width,
            view.bounds.height))
        view.addSubview(webView)
        if (!url.isEmpty) {
            webView?.loadRequest(NSURLRequest(URL: NSURL(string: url)))
        }
    }

    func preferenceButtonTapped(sender: AnyObject) {
        navigationController.pushViewController(ViewControllers().preferenceViewController, animated: true)
    }

    func nextButtonTapped(sender: AnyObject) {
        flip()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func flip() {
        if (urls.isEmpty) {
            return
        }

        selectedURLIndex++
        if (selectedURLIndex >= urls.count) {
            selectedURLIndex = 0
        }
        NSLog("URL: %@", urls[selectedURLIndex])
        webView?.loadRequest(NSURLRequest(URL: NSURL(string: urls[selectedURLIndex])))

        UIView.beginAnimations("flip", context: nil)
        UIView.setAnimationDuration(1.0)
        UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: webView!, cache: false)
        UIView.commitAnimations()
    }
}
