import UIKit

class MainViewController: UIViewController {
    var webView : UIWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTabBar()
        loadWebView()
    }

    func loadTabBar() {
        let preferenceButton = UIBarButtonItem(title: "Preference", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("preferenceButtonTapped:"))
        navigationItem.rightBarButtonItem = preferenceButton
    }

    func loadWebView() {
        webView = UIWebView(frame: view.bounds)
        view.addSubview(webView)
        let url = NSURL(string: "http://google.com")
        let request = NSURLRequest(URL: url)
        webView?.loadRequest(request)
    }

    func preferenceButtonTapped(sender: AnyObject) {
        navigationController.pushViewController(ViewControllers().preferenceViewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

