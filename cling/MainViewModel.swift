class MainViewModel: NSObject {
    dynamic var url = ""
    private var urls: [String] = []
    private var selectedURLIndex = 0

    func loadUrls() {
        urls = (Page.MR_findAllSortedBy("sort", ascending: true) as [Page]).map{(page: Page) -> String in
            page.url
            }.filter{(url: String) -> Bool in
                !url.isEmpty
        }
        url = urls.first ?? ""
    }

    func reset() {
        loadUrls()
        selectedURLIndex = 0
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