class IntervalPreferenceViewController: UIViewController {
    private var intervalTextField: UITextField?
    let viewModel = IntervalPreferenceViewModel()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = NSLocalizedString("Rotation Interval", comment: "")
        view.backgroundColor = UIColor.whiteColor()
    }
    
    convenience override init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        intervalTextField = UITextField(frame: CGRectMake(20, 100, 100, 44))
        intervalTextField!.autoresizingMask = UIViewAutoresizing.None
        intervalTextField!.placeholder = NSLocalizedString("sec", comment: "")
        intervalTextField!.borderStyle = UITextBorderStyle.RoundedRect
        intervalTextField!.keyboardType = UIKeyboardType.NumberPad
        view.addSubview(intervalTextField!)
        
        let layoutTop = NSLayoutConstraint(
            item: intervalTextField!,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0.0)
        let layoutLeft = NSLayoutConstraint(
            item: intervalTextField!,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0.0)
        view.addConstraints([layoutTop, layoutLeft])

        intervalTextField!.rac_textSignal().subscribeNext({
            text in
            let interval = (text as String).toInt()
            if interval > 0 {
                self.viewModel.setRotationInterval(interval!)
            }
        })

        let label = UILabel(frame: CGRectMake(130, 100, view.bounds.width - 130, 44))
        label.text = NSLocalizedString("sec", comment: "")
        view.addConstraints([layoutTop, layoutLeft])
        view.addSubview(label)
    }

    override func viewWillAppear(animated: Bool) {
        viewModel.rac_valuesForKeyPath("rotationInterval", observer: viewModel).subscribeNext({
            interval in
            self.intervalTextField!.text = String(interval as Int)
            return
        })
        viewModel.loadRotationInterval()
    }
    
}
