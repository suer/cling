class EditableViewCell: UITableViewCell {
    var textField: UITextField?
    let width: CGFloat
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
}
