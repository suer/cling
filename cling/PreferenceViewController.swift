import UIKit

class PreferenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let viewModel = PreferenceViewModel()
    var tableView: UITableView?
    let urlEditViewController: URLEditViewController

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.urlEditViewController = URLEditViewController(preferenceViewModel: self.viewModel)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override init() {
        self.urlEditViewController = URLEditViewController(preferenceViewModel: self.viewModel)
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "URL Preference"
        setupTabBar()
        setupTableView()
        setupHandler()
    }

    private func setupTabBar() {
        let addButton = UIBarButtonItem()
        addButton.style = UIBarButtonItemStyle.Plain
        addButton.title = "Add"
        addButton.rac_command = RACCommand(signalBlock: {
            obj in
            self.presentURLEditViewController(nil)
            return RACSignal.empty()
        })

        navigationItem.rightBarButtonItem = addButton
    }

    private func setupTableView() {
        let tableViewRect = CGRectMake(
            0,
            0,
            view.bounds.width,
            view.bounds.height)
        tableView = UITableView(frame: tableViewRect)
        tableView!.delegate = self
        tableView!.dataSource = self
        view.addSubview(tableView!)
    }

    private func setupHandler() {
        viewModel.itemChangedSignal.subscribeNext({
            obj in
            if let fetchedResultsChange = obj as? FetchedResultsChange {
                switch(fetchedResultsChange.type) {
                case NSFetchedResultsChangeType.Insert:
                    self.tableView!.insertRowsAtIndexPaths([fetchedResultsChange.newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                    break
                case NSFetchedResultsChangeType.Update:
                    self.tableView!.reloadRowsAtIndexPaths([fetchedResultsChange.indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                    break
                case NSFetchedResultsChangeType.Delete:
                    self.tableView!.deleteRowsAtIndexPaths([fetchedResultsChange.indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                    break
                default:
                    break
                }
            }
        })
    }

    private func presentURLEditViewController(indexPath: NSIndexPath?) {
        urlEditViewController.indexPath = indexPath
        let navigationController = UINavigationController(rootViewController: self.urlEditViewController)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }

    func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        return nil
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return viewModel.sectionInfo().numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        if let page = viewModel.pageAtIndexPath(indexPath) {
            cell.textLabel?.text = page.url
        }
        return cell
    }

    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            viewModel.deletePage(indexPath)
        }
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        self.presentURLEditViewController(indexPath)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
