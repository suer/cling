class URLPreferenceViewModel: RVMViewModel, NSFetchedResultsControllerDelegate {
    let itemChangedSignal: RACSignal = RACSubject()
    let fetchedResultsController: NSFetchedResultsController
    var selectedCellIndexPath: NSIndexPath?

    override init() {
        self.fetchedResultsController = Page.MR_fetchAllSortedBy("sort", ascending: true, withPredicate: NSPredicate(format: "1 = 1", []), groupBy: nil, delegate: nil)
        super.init()
        self.fetchedResultsController.delegate = self
        self.reloadFetchedResultsController()
    }

    private func reloadFetchedResultsController() {
        var error: NSError?
        fetchedResultsController.performFetch(&error)
        if (error != nil) {
            NSLog("error: %@", error!)
        }
    }

    func addPage(url: String) {
        PageWrapper.createRecord(url)
        self.reloadFetchedResultsController()
    }

    func savePage(url: String, indexPath: NSIndexPath) {
        if let page = pageAtIndexPath(indexPath) {
            PageWrapper(page: page).updateUrl(url)
        }
    }

    func deletePage(indexPath: NSIndexPath) {
        if let page = pageAtIndexPath(indexPath) {
            PageWrapper(page: page).delete()
        }
    }

    func movePage(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        PageWrapper.move(fromIndexPath.row, toIndex: toIndexPath.row)
    }

    func sectionInfo() -> NSFetchedResultsSectionInfo {
        return fetchedResultsController.sections![0] as NSFetchedResultsSectionInfo
    }

    func pageAtIndexPath(indexPath: NSIndexPath) -> Page? {
        return fetchedResultsController.objectAtIndexPath(indexPath) as? Page
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        (itemChangedSignal as RACSubscriber).sendNext(FetchedResultsChange(indexPath: indexPath, newIndexPath: newIndexPath, type: type))
    }
}