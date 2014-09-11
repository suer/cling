class FetchedResultsChange {
    var indexPath: NSIndexPath?
    var newIndexPath: NSIndexPath?
    var type: NSFetchedResultsChangeType

    init(indexPath: NSIndexPath?, newIndexPath: NSIndexPath?, type: NSFetchedResultsChangeType) {
        self.indexPath = indexPath
        self.newIndexPath = newIndexPath
        self.type = type
    }
}