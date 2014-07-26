import UIKit

class PreferenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?
    var fetchedResultsController: NSFetchedResultsController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        setupTableView()
    }

    private func setupFetchedResultsController() {
        fetchedResultsController = Page.MR_fetchAllSortedBy("_pk", ascending: true, withPredicate: NSPredicate(format: "1 = 1", []), groupBy: nil, delegate: nil)
    }

    private func setupTableView() {
        let navigationBarHeight = navigationController.navigationBar.frame.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let tableViewRect = CGRectMake(
            0,
            navigationBarHeight + statusBarHeight,
            view.bounds.width,
            view.bounds.height  - navigationBarHeight - statusBarHeight)
        
        let tableView = UITableView(frame: tableViewRect)
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
        return 0
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
