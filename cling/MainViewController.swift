import UIKit

class MainViewController: UIViewController {
    var webView : UIWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = UIWebView(frame: view.bounds)
        view.addSubview(webView)
        let url = NSURL(string: "http://google.com")
        let request = NSURLRequest(URL: url)
        webView?.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

