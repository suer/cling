public class EditableViewCell: UITableViewCell {
    private var textField: UITextField?
    let width: CGFloat

    required public init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    init(width: CGFloat, reuseIdentifier: String) {
        self.width = width
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.None
        showEditField()
    }
    
    private func showEditField() {
        let textField = UITextField(frame: CGRectMake(30, 5, width - 50, bounds.height - 10))
        textField.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        textField.textAlignment = NSTextAlignment.Left
        textField.returnKeyType = UIReturnKeyType.Done
        textField.clearButtonMode = UITextFieldViewMode.WhileEditing
        textField.adjustsFontSizeToFitWidth = true
        textField.placeholder = "http://example.com"
        textField.keyboardType = UIKeyboardType.URL
        textField.enabled = false
        addSubview(textField)
        self.textField = textField
    }

    public func setUrl(url: String) {
        if (textField == nil) {
            return
        }
        textField!.text = url
    }

    public func getUrl() -> String {
        if (textField == nil) {
            return ""
        }
        return textField!.text
    }

    public func enable() {
        if (textField == nil) {
            return
        }
        textField!.enabled = true
    }
    
    public func disable() {
        if (textField == nil) {
            return
        }
        textField!.enabled = false
    }

    public func setTextFieldDelegate(delegate: UITextFieldDelegate) {
        if (textField == nil) {
            return
        }
        textField!.delegate = delegate
    }
    
    public func showKeyBoard() {
        if (textField == nil) {
            return
        }
        textField!.becomeFirstResponder()
    }
}
