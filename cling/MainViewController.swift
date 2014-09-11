import UIKit
import QuartzCore

class MainViewController: UIViewController {
    private let rotationTime = 60.0
    var webView : UIWebView?
    var viewModel = MainViewModel()
    let cancelSubject = RACSubject()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cling"
#if arch(i386) || arch(x86_64)
        FLEXManager.sharedManager().showExplorer()
#endif
    }

    override func viewWillAppear(animated: Bool) {
        loadTabBar()
        loadWebView()
        viewModel.reset()
        restartTimer()
    }

    func loadTabBar() {
        let preferenceButton = UIBarButtonItem(title: "Preference", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("preferenceButtonTapped:"))
        navigationItem.rightBarButtonItem = preferenceButton
        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("nextButtonTapped:"))
        navigationItem.leftBarButtonItem = nextButton
    }
    
    func loadWebView() {
        if (webView != nil) {
            return
        }
        webView = UIWebView(frame: CGRectMake(
            0,
            0,
            view.bounds.width,
            view.bounds.height))
        view.addSubview(webView!)
        viewModel.rac_valuesForKeyPath("url", observer: viewModel).subscribeNext({
            url in
            self.webView?.loadRequest(NSURLRequest(URL: NSURL(string: url as String)))
            return
        })

    }

    func preferenceButtonTapped(sender: AnyObject) {
        navigationController!.pushViewController(ViewControllers().preferenceViewController, animated: true)
    }

    func nextButtonTapped(sender: AnyObject) {
        flip()
        restartTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func flip() {
        viewModel.increment()

        UIView.beginAnimations("flip", context: nil)
        UIView.setAnimationDuration(3.0)
        UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: webView!, cache: false)
        UIView.commitAnimations()
    }

    private func startTimer() {
        RACSignal.interval(rotationTime, onScheduler: RACScheduler.mainThreadScheduler()).takeUntil(cancelSubject).subscribeNext({obj in self.flip()})
    }

    private func stopTimer() {
        cancelSubject.sendNext(RACUnit.defaultUnit())
    }

    private func restartTimer() {
        stopTimer()
        startTimer()
    }
}
