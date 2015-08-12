import UIKit
import QuartzCore

class MainViewController: UIViewController {
    private var rotationInterval = 60.0
    var bufferedWebView : BufferedWebView?
    let cancelSubject = RACSubject()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Cling", comment: "")
        edgesForExtendedLayout = UIRectEdge.None
        automaticallyAdjustsScrollViewInsets = false
        loadTabBar()
        loadWebView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.toolbarHidden = true
        bufferedWebView!.loadUrls()
        let viewModel = ViewControllers.sharedInstance.intervalPreferenceViewController.viewModel
        viewModel.rac_valuesForKeyPath("rotationInterval", observer: viewModel).subscribeNext({
            interval in
            self.rotationInterval = Double(interval as! Int)
            return
        })
        viewModel.loadRotationInterval()
        restartTimer()
    }

    func loadTabBar() {
        let preferenceButton = UIBarButtonItem(image: UIImage(named: "preference"), style: .Plain, target: self, action: Selector("preferenceButtonTapped:"))
        navigationItem.rightBarButtonItem = preferenceButton

        let nextButton = UIBarButtonItem(image: UIImage(named: "right-arrow"), style: .Plain, target: self, action: Selector("nextButtonTapped:"))
        navigationItem.leftBarButtonItem = nextButton
    }
    
    func loadWebView() {
        if (bufferedWebView != nil) {
            return
        }
        bufferedWebView = BufferedWebView(frame: view.bounds)
        bufferedWebView!.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        view.addSubview(bufferedWebView!)
    }

    func preferenceButtonTapped(sender: AnyObject) {
        navigationController!.pushViewController(ViewControllers.sharedInstance.preferenceViewController, animated: true)
    }

    func nextButtonTapped(sender: AnyObject) {
        bufferedWebView!.flip()
        restartTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func startTimer() {
        RACSignal.interval(rotationInterval, onScheduler: RACScheduler.mainThreadScheduler()).takeUntil(cancelSubject).subscribeNext({obj in self.bufferedWebView!.flip()})
    }

    private func stopTimer() {
        cancelSubject.sendNext(RACUnit.defaultUnit())
    }

    func restartTimer() {
        stopTimer()
        startTimer()
    }
}
