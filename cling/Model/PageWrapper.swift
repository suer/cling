public class PageWrapper {
    private let page: Page
    init(page: Page) {
        self.page = page
    }

    class func createRecord(url: String) {
        let page = Page.MR_createEntity() as Page
        page.url = url
        page.sort = Page.MR_numberOfEntities()
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    class func move(fromIndex: Int, toIndex: Int) {
        let pages = Page.MR_findAllSortedBy("sort", ascending: true) as [Page]
        pages[fromIndex].sort = toIndex
        if (fromIndex < toIndex) {
            for var i = fromIndex + 1; i <= toIndex; i++ {
                pages[i].sort = pages[i].sort - 1
            }
        } else {
            for var i = toIndex; i < fromIndex; i++ {
                pages[i].sort = pages[i].sort + 1
            }
        }
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    func updateUrl(url: String) {
        page.url = url
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    func delete() {
        page.MR_deleteEntity()
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
}