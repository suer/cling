import UIKit

class PreferenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var tableView: UITableView?
    var fetchedResultsController: NSFetchedResultsController?
    var selectedCellIndexPath: NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "URL Preference"
        setupFetchedResultsController()
        setupTabBar()
        setupTableView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let indexPath = selectedCellIndexPath {
            saveCell(indexPath)
        }
        super.viewWillDisappear(animated)
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
        if let indexPath = selectedCellIndexPath {
            saveCell(indexPath)
            tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        }

        let indexPath = NSIndexPath(forItem: tableView!.numberOfRowsInSection(0), inSection: 0)
        PageWrapper.createBlankRecord()
        reloadFetchedResultsController()
        tableView!.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        selectCell(indexPath)
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
        view.addSubview(tableView)
    }
    
    func selectCell(indexPath: NSIndexPath) {
        tableView!.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Top)
        let cell = tableView!.cellForRowAtIndexPath(indexPath) as EditableViewCell
        cell.enable()
        cell.showKeyBoard()
        tableView!.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        selectedCellIndexPath = indexPath
    }

    func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        return nil
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
        let info = fetchedResultsController!.sections[section] as NSFetchedResultsSectionInfo
        return info.numberOfObjects
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = EditableViewCell(width: tableView.bounds.width, reuseIdentifier: "Cell")
        cell.setTextFieldDelegate(self)
        let page = fetchedResultsController!.objectAtIndexPath(indexPath) as Page
        cell.setUrl(page.url)
        return cell
    }

    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            removeCell(indexPath)
        }
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as EditableViewCell
        selectCell(indexPath)
    }
    
    func tableView(tableView: UITableView!, didDeselectRowAtIndexPath indexPath: NSIndexPath!) {
        saveCell(indexPath)
    }
    
    private func saveCell(indexPath: NSIndexPath) {
        if let cell = tableView!.cellForRowAtIndexPath(indexPath) as? EditableViewCell {
            let url = cell.getUrl()
            if (url.isEmpty) {
                removeCell(indexPath)
                return
            }
            let page = fetchedResultsController!.objectAtIndexPath(indexPath) as Page
            PageWrapper(page: page).updateUrl(url)
            cell.disable()
        }
    }

    
    private func removeCell(indexPath: NSIndexPath) {
        let page = fetchedResultsController!.objectAtIndexPath(indexPath) as Page
        PageWrapper(page: page).delete()
        reloadFetchedResultsController()
        tableView!.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        if let indexPath = selectedCellIndexPath {
            saveCell(indexPath)
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
