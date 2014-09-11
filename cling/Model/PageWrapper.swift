public class PageWrapper {

    private let page: Page
    init(page: Page) {
        self.page = page
    }

    public class func createRecord(url: String) {
        let page = Page.MR_createEntity() as Page
        page.url = url
        page.createdAt = NSDate()
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    public func updateUrl(url: String) {
        page.url = url
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    public func delete() {
        page.MR_deleteEntity()
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
}
