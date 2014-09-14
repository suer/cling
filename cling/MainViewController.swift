import UIKit
import QuartzCore

class MainViewController: UIViewController {
    private let rotationTime = 60.0
    var bufferedWebView : BufferedWebView?
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
        viewModel.loadUrls()
        loadWebView()
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
        bufferedWebView = BufferedWebView(frame: view.frame, urls: viewModel.urls)
        view.addSubview(bufferedWebView!)

        viewModel.rac_valuesForKeyPath("urls", observer: viewModel).subscribeNext({
            urls in
            self.bufferedWebView!.reset(urls as [String])
            return
        })

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
        RACSignal.interval(rotationTime, onScheduler: RACScheduler.mainThreadScheduler()).takeUntil(cancelSubject).subscribeNext({obj in self.bufferedWebView!.flip()})
    }

    private func stopTimer() {
        cancelSubject.sendNext(RACUnit.defaultUnit())
    }

    private func restartTimer() {
        stopTimer()
        startTimer()
    }
}
