class BufferedWebView: UIView, UIWebViewDelegate {
    let webViews = [UIWebView]()
    private var activeWebViewIndex = 0
    private var urls = [String]()
    private var selectedUrlIndex = 0
    init(frame: CGRect, urls: [String]) {
        super.init(frame: frame)
        for var i = 0; i < 2; i++ {
            let webView = UIWebView(frame: frame)
            webView.delegate = self
            webView.scalesPageToFit = true
            webViews.append(webView)
        }
        reset(urls)
    }

    func reset(urls: [String]) {
        activeWebViewIndex = 0
        selectedUrlIndex = 0
        self.urls = urls
        if (urls.count > 0) {
            webViews[0].loadRequest(NSURLRequest(URL: NSURL(string: urls[0])))
            addSubview(webViews[0])
        }
        if (urls.count > 1) {
            webViews[1].loadRequest(NSURLRequest(URL: NSURL(string: urls[1])))
            addSubview(webViews[1])
            bringSubviewToFront(webViews[0])
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func flip() {
        dispatch_async(dispatch_get_main_queue(), {
            UIView.animateWithDuration(1.0, animations: {
                self.webViews[self.activeWebViewIndex].frame = CGRectMake(self.frame.width, 0, self.frame.width, self.frame.height)
                }, completion: {
                    _ in
                    self.activeWebViewIndex = (self.activeWebViewIndex + 1) % 2
                    self.bringSubviewToFront(self.webViews[self.activeWebViewIndex])
                    self.selectedUrlIndex = (self.selectedUrlIndex + 1) % self.urls.count
                    self.webViews[(self.activeWebViewIndex + 1) % 2].loadRequest(NSURLRequest(URL: NSURL(string: self.urls[(self.selectedUrlIndex + 1) % self.urls.count])))
                    self.webViews[(self.activeWebViewIndex + 1) % 2].frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
            })
        })
    }

    func webViewDidStartLoad(webView: UIWebView) {
    }

    func webViewDidFinishLoad(webView: UIWebView) {
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
    }
}
