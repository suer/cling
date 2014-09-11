import UIKit

class PreferenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    let viewModel = PreferenceViewModel()
    var tableView: UITableView?
    var selectedCellIndexPath: NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "URL Preference"
        setupTabBar()
        setupTableView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let indexPath = selectedCellIndexPath {
            saveCell(indexPath)
        }
        super.viewWillDisappear(animated)
    }
    
    private func setupTabBar() {
        let preferenceButton = UIBarButtonItem()
        preferenceButton.style = UIBarButtonItemStyle.Plain
        preferenceButton.title = "Add"
        preferenceButton.rac_command = viewModel.createAddCellCommand()
        navigationItem.rightBarButtonItem = preferenceButton
        viewModel.itemChangedSignal.subscribeNext({
            obj in

            if let fetchedResultsChange = obj as? FetchedResultsChange {
                switch(fetchedResultsChange.type) {
                case NSFetchedResultsChangeType.Insert:
                    self.tableView!.insertRowsAtIndexPaths([fetchedResultsChange.newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                    self.selectedCellIndexPath = fetchedResultsChange.newIndexPath
                    self.selectCell(fetchedResultsChange.newIndexPath!)
                    break
                case NSFetchedResultsChangeType.Update:
                    break
                case NSFetchedResultsChangeType.Delete:
                    self.tableView!.deleteRowsAtIndexPaths([fetchedResultsChange.indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                    self.viewModel.reloadFetchedResultsController()
                    break
                default:
                    break
                }
            }
        })
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return viewModel.sectionInfo().numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = EditableViewCell(width: tableView.bounds.width, reuseIdentifier: "Cell")
        cell.setTextFieldDelegate(self)
        let page = viewModel.pageAtIndexPath(indexPath)
        cell.setUrl(page.url)
        return cell
    }

    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let page = viewModel.pageAtIndexPath(indexPath)
            PageWrapper(page: page).delete()
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
                let page = viewModel.pageAtIndexPath(indexPath)
                PageWrapper(page: page).delete()
                return
            }
            let page = viewModel.pageAtIndexPath(indexPath)
            PageWrapper(page: page).updateUrl(url)
            cell.disable()
        }
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
