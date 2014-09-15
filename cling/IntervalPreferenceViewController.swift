class IntervalPreferenceViewController: UIViewController {
    private var intervalTextField: UITextField?
    private let viewModel = IntervalPreferenceViewModel()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience override init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        intervalTextField = UITextField(frame: CGRectMake(20, 100, view.bounds.width - 40, 44))
        intervalTextField!.autoresizingMask = UIViewAutoresizing.None
        intervalTextField!.placeholder = "Rotation Interval(sec)"
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
