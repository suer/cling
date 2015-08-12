import UIKit

class PreferenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = NSLocalizedString("Preference", comment: "")
        view.backgroundColor = UIColor.whiteColor()
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (tableView != nil) {
            tableView!.reloadData()
        }
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: UITableViewStyle.Grouped)
        tableView!.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.setEditing(false, animated: true)
        view.addSubview(tableView!)
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel!.text = NSLocalizedString("URL List", comment: "")
            } else if (indexPath.row == 1) {
                cell.textLabel!.text = NSLocalizedString("Rotation Interval", comment: "")
                cell.detailTextLabel!.text = String(ViewControllers.sharedInstance.intervalPreferenceViewController.viewModel.rotationInterval) + " " + NSLocalizedString("sec", comment: "")
            }
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }

    func tableView(tableView: UITableView?, didSelectRowAtIndexPath indexPath:NSIndexPath!) {
        if (indexPath.section != 0) {
            return
        }
        if (indexPath.row == 0) {
            self.navigationController!.pushViewController(ViewControllers.sharedInstance.urlPreferenceViewController, animated: true)
        } else if (indexPath.row == 1) {
            self.navigationController!.pushViewController(ViewControllers.sharedInstance.intervalPreferenceViewController, animated: true)
        }
    }
}
