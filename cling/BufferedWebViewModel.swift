class MainViewModel: NSObject {
    dynamic var urls: [String] = []
    func loadUrls() {
        urls = (Page.MR_findAllSortedBy("sort", ascending: true) as [Page]).map{(page: Page) -> String in
            page.url
            }.filter{(url: String) -> Bool in
                !url.isEmpty
        }
    }
}