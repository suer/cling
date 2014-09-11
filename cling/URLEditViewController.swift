class URLEditViewController: UIViewController {
    let preferenceViewModel: PreferenceViewModel
    var urlTextView: UITextView?
    var indexPath: NSIndexPath?
    var saveButton: UIBarButtonItem?

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, preferenceViewModel: PreferenceViewModel) {
        self.preferenceViewModel = preferenceViewModel

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    convenience init(preferenceViewModel: PreferenceViewModel) {
        self.init(nibName: nil, bundle: nil, preferenceViewModel: preferenceViewModel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit URL"
        self.view.backgroundColor = UIColor.whiteColor()
        loadTextView()
        loadCancelButton()
        loadSaveButton()
    }

    override func viewWillAppear(animated: Bool) {
        var url = ""
        if (indexPath != nil) {
            let page = preferenceViewModel.pageAtIndexPath(indexPath!)
            url = page?.url ?? ""
        }
        urlTextView!.text = url

        urlTextView!.becomeFirstResponder()
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(animated: Bool) {
        self.indexPath = nil
        super.viewDidDisappear(animated)
    }

    private func loadCancelButton() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: nil, action: nil)
        cancelButton.rac_command = RACCommand(signalBlock: {
            obj in
            self.dismissViewControllerAnimated(true, completion: nil)
            return RACSignal.empty()
        })
        navigationItem.leftBarButtonItem = cancelButton
    }

    private func loadSaveButton() {
        saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: nil, action: nil)
        saveButton!.rac_command = RACCommand(signalBlock: {
            input in
            if self.indexPath == nil {
                self.preferenceViewModel.addPage(self.urlTextView!.text)
            } else {
                self.preferenceViewModel.savePage(self.urlTextView!.text, indexPath: self.indexPath!)
            }

            self.dismissViewControllerAnimated(true, completion: nil)
            return RACSignal.empty()
        })
        navigationItem.rightBarButtonItem = saveButton
        saveButton!.enabled = false
    }

    private func loadTextView() {
        if (urlTextView != nil) {
            return
        }
        self.urlTextView = UITextView(frame: CGRectMake(0, 0,  view.frame.width, view.frame.height))
        view.addSubview(urlTextView!)
        urlTextView!.rac_textSignal().subscribeNext({
            input in
            if (self.saveButton != nil) {
                self.saveButton!.enabled = !self.urlTextView!.text.isEmpty
            }
        })
    }
}
