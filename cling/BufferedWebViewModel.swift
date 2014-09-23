class BufferedWebViewModel: NSObject {
    dynamic var urls: [String] = []
    private var selectedUrlIndex = 0
    func loadUrls() {
        urls = (Page.MR_findAllSortedBy("sort", ascending: true) as [Page]).map{(page: Page) -> String in
            page.url
            }.filter{(url: String) -> Bool in
                !url.isEmpty
        }
    }

    func incrementSelectedIndex() {
        if (urls.isEmpty) {
            return
        }
        selectedUrlIndex = (selectedUrlIndex + 1) % urls.count
    }

    func nextURL() -> String {
        if (urls.isEmpty) {
            return ""
        }
        return urls[(selectedUrlIndex + 1) % urls.count]
    }
}