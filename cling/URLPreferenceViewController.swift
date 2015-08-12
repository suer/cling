class URLPreferenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    let viewModel = URLPreferenceViewModel()
    var tableView: UITableView?
    let urlEditViewController: URLEditViewController
    var editButton: UIBarButtonItem?
    var addButton: UIBarButtonItem?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.urlEditViewController = URLEditViewController(viewModel: self.viewModel)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("URL List", comment: "")
        setupTabBar()
        setupTableView()
        setupHandler()
        setupToolBar()
    }
    
    private func setupTabBar() {
        editButton = UIBarButtonItem()
        editButton!.title = NSLocalizedString("Edit", comment: "")
        editButton!.rac_command = RACCommand(signalBlock: {
            obj in
            self.tableView!.setEditing(!self.tableView!.editing, animated: true)
            self.addButton!.enabled = !self.tableView!.editing
            if (self.tableView!.editing) {
                self.editButton!.title = NSLocalizedString("Finish", comment: "")
            } else {
                self.editButton!.title = NSLocalizedString("Edit", comment: "")
            }
            return RACSignal.empty()
        })
        
        navigationItem.rightBarButtonItem = editButton
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.toolbarHidden = false
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView!.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.setEditing(false, animated: true)
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

        viewModel.contentChangedSignal.subscribeNext({
            obj in
            self.tableView!.reloadData()
        })
    }
    
    private func setupToolBar() {
        addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: nil, action: nil)
        addButton!.rac_command = RACCommand(signalBlock: {
            obj in
            self.presentURLEditViewController(nil)
            return RACSignal.empty()
        })
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        self.toolbarItems = [space, addButton!]
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") ?? UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        if let page = viewModel.pageAtIndexPath(indexPath) {
            cell.textLabel?.text = page.url
        }
        return cell as UITableViewCell
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        viewModel.movePage(fromIndexPath, toIndexPath: toIndexPath)
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
