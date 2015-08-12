class BufferedWebView: UIView, UIWebViewDelegate {
    var webViews = [UIWebView]()
    private var activeWebViewIndex = 0
    private var selectedUrlIndex = 0
    private var viewModel = BufferedWebViewModel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        for var i = 0; i < 2; i++ {
            let webView = UIWebView(frame: frame)
            webView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            webView.delegate = self
            webViews.append(webView)
        }
        viewModel.rac_valuesForKeyPath("urls", observer: viewModel).subscribeNext({
            urls in
            self.resetWebViews(urls as! [String])
            return
        })
        loadUrls()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadUrls() {
        viewModel.loadUrls()
    }

    func resetWebViews(urls: [String]) {
        activeWebViewIndex = 0
        selectedUrlIndex = 0
        if (viewModel.urls.count > 0) {
            if let url = NSURL(string: urls[0]) {
                webViews[0].loadRequest(NSURLRequest(URL: url))
            }
            addSubview(webViews[0])
        }
        if (viewModel.urls.count > 1) {
            if let url = NSURL(string: urls[1]) {
                webViews[1].loadRequest(NSURLRequest(URL: url))
            }
            addSubview(webViews[1])
            bringSubviewToFront(webViews[0])
        }
    }

    func flip() {
        UIView.animateWithDuration(1.0, animations: {
            self.slideActiveWebView()
            }, completion: {
                _ in
                self.hideAndLoadBackgroundWebView()
        })
    }

    private func slideActiveWebView() {
        webViews[activeWebViewIndex].frame = CGRectMake(frame.width, 0, frame.width, frame.height)
    }

    private func hideAndLoadBackgroundWebView() {
        activeWebViewIndex = nextActiveWebViewIndex()
        bringSubviewToFront(webViews[activeWebViewIndex])
        viewModel.incrementSelectedIndex()
        loadBackgroundWebView()
    }

    private func nextActiveWebViewIndex() -> Int {
        return (activeWebViewIndex + 1) % 2
    }

    private func loadBackgroundWebView() {
        let backgroundWebView = webViews[nextActiveWebViewIndex()]
        if let url = NSURL(string: viewModel.nextURL()) {
            backgroundWebView.loadRequest(NSURLRequest(URL: url))
        }
        backgroundWebView.frame = CGRectMake(0, 0, frame.width, frame.height)
    }

    func webViewDidStartLoad(webView: UIWebView) {
    }

    func webViewDidFinishLoad(webView: UIWebView) {
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
    }
}
