import UIKit
import QuartzCore

class MainViewController: UIViewController {
    private var rotationInterval = 60.0
    private let intervalPreferenceViewModel = IntervalPreferenceViewModel()
    var bufferedWebView : BufferedWebView?
    let cancelSubject = RACSubject()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cling"
        edgesForExtendedLayout = UIRectEdge.None
        automaticallyAdjustsScrollViewInsets = false
        loadTabBar()
        loadWebView()

#if arch(i386) || arch(x86_64)
        FLEXManager.sharedManager().showExplorer()
#endif
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.toolbarHidden = true
        bufferedWebView!.loadUrls()
        intervalPreferenceViewModel.rac_valuesForKeyPath("rotationInterval", observer: intervalPreferenceViewModel).subscribeNext({
            interval in
            self.rotationInterval = Double(interval as Int)
            return
        })
        intervalPreferenceViewModel.loadRotationInterval()
        restartTimer()
    }

    func loadTabBar() {
        let preferenceButton = UIBarButtonItem(title: "Preference", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("preferenceButtonTapped:"))
        navigationItem.rightBarButtonItem = preferenceButton
        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("nextButtonTapped:"))
        navigationItem.leftBarButtonItem = nextButton
    }
    
    func loadWebView() {
        if (bufferedWebView != nil) {
            return
        }
        bufferedWebView = BufferedWebView(frame: view.bounds)
        bufferedWebView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
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

    private func restartTimer() {
        stopTimer()
        startTimer()
    }
}
