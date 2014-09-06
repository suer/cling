class MainViewModel {
    var url = ""
    private var urls: [String] = []
    private var selectedURLIndex = 0

    init() {
    }

    func loadUrls() {
        urls = (Page.MR_findAll() as [Page]).map{(page: Page) -> String in
            page.url
            }.filter{(url: String) -> Bool in
                !url.isEmpty
        }
        url = urls.first ?? ""
    }

    func increment() {
        if (urls.isEmpty) {
            return
        }
        incrementSelectedURLIndex()
        url = urls[selectedURLIndex]
    }

    private func incrementSelectedURLIndex() {
        if (urls.isEmpty) {
            return
        }
        selectedURLIndex = (selectedURLIndex + 1) % urls.count
    }
}