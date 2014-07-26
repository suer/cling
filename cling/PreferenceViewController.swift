import UIKit

class PreferenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?
    var fetchedResultsController: NSFetchedResultsController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        setupTabBar()
        setupTableView()
    }

    private func setupFetchedResultsController() {
        fetchedResultsController = Page.MR_fetchAllSortedBy("_pk", ascending: true, withPredicate: NSPredicate(format: "1 = 1", []), groupBy: nil, delegate: nil)
        reloadFetchedResultsController()
    }
    
    private func reloadFetchedResultsController() {
        var error: NSError?
        fetchedResultsController?.performFetch(&error)
        if (error) {
            NSLog("error: %@", error!)
        }
    }
    
    private func setupTabBar() {
        let preferenceButton = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("addButtonTapped:"))
        navigationItem.rightBarButtonItem = preferenceButton
    }
    
    func addButtonTapped(sender: AnyObject) {
        let indexPath = NSIndexPath(forItem: tableView!.numberOfRowsInSection(0), inSection: 0)
        let page = Page.MR_createEntity() as Page
        page.url = ""
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        reloadFetchedResultsController()        
        tableView!.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        tableView!.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }

    private func setupTableView() {
        let navigationBarHeight = navigationController.navigationBar.frame.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let tableViewRect = CGRectMake(
            0,
            navigationBarHeight + statusBarHeight,
            view.bounds.width,
            view.bounds.height  - navigationBarHeight - statusBarHeight)
        
        tableView = UITableView(frame: tableViewRect)
        tableView!.delegate = self
        tableView!.dataSource = self
        view.addSubview(tableView)

    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
        let info = fetchedResultsController!.sections[section] as NSFetchedResultsSectionInfo
        return info.numberOfObjects
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
