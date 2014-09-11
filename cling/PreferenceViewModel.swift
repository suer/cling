class PreferenceViewModel: RVMViewModel, NSFetchedResultsControllerDelegate {
    let itemChangedSignal: RACSignal = RACSubject()
    var fetchedResultsController: NSFetchedResultsController?
    var selectedCellIndexPath: NSIndexPath?

    override init() {
        super.init()
        self.fetchedResultsController = Page.MR_fetchAllSortedBy("createdAt", ascending: true, withPredicate: NSPredicate(format: "1 = 1", []), groupBy: nil, delegate: self)
        self.reloadFetchedResultsController()
    }

    func reloadFetchedResultsController() {
        var error: NSError?
        fetchedResultsController?.performFetch(&error)
        if (error != nil) {
            NSLog("error: %@", error!)
        }
    }

    func createAddCellCommand() -> RACCommand {
        return RACCommand(signalBlock: {
            input in
            PageWrapper.createBlankRecord()
            self.reloadFetchedResultsController()
            return RACSignal.empty()
        })
    }

    func sectionInfo() -> NSFetchedResultsSectionInfo {
        return fetchedResultsController!.sections![0] as NSFetchedResultsSectionInfo
    }

    func pageAtIndexPath(indexPath: NSIndexPath) -> Page {
        return fetchedResultsController!.objectAtIndexPath(indexPath) as Page
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        (itemChangedSignal as RACSubscriber).sendNext(FetchedResultsChange(indexPath: indexPath, newIndexPath: newIndexPath, type: type))
    }
}