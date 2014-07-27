class EditableViewCell: UITableViewCell {
    var textField: UITextField?
    var saveButton: UITextField?
    let width: CGFloat
    init(width: CGFloat, reuseIdentifier: String) {
        self.width = width
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.None
        showEditField()
    }
    
    private func showEditField() {
        let textField = UITextField(frame: CGRectMake(30, 5, width - 120, bounds.height - 10))
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        textField.textAlignment = NSTextAlignment.Left
        textField.returnKeyType = UIReturnKeyType.Done
        textField.clearButtonMode = UITextFieldViewMode.WhileEditing
        textField.adjustsFontSizeToFitWidth = true
        addSubview(textField)
        
        let normalTextColor = UIColor(red: CGFloat(0.5), green: CGFloat(0.5), blue: CGFloat(0.5), alpha: CGFloat(1.0))
        let highlightedTextColor = UIColor(red: CGFloat(0.9), green: CGFloat(0.9), blue: CGFloat(0.9), alpha: CGFloat(1.0))
        let saveButton = UIButton(frame: CGRectMake(5 + width - 80, 5, 60, bounds.height - 10))
        saveButton.layer.borderWidth = 1.0
        saveButton.layer.borderColor = normalTextColor.CGColor
        saveButton.layer.cornerRadius = 5.0

        saveButton.setTitleColor(normalTextColor, forState: UIControlState.Normal)
        saveButton.setTitleColor(highlightedTextColor, forState: UIControlState.Highlighted)
        saveButton.setTitle("Save", forState: UIControlState.Normal)
        saveButton.setTitle("Save", forState: UIControlState.Highlighted)

        addSubview(saveButton)
    }
    
    func toggleEditMode() {
        if (textField!.hidden) {
            textField!.hidden = false
            saveButton!.hidden = false
            textLabel.hidden = true
        } else {
            textField!.hidden = true
            saveButton!.hidden = true
            textLabel.hidden = false
        }
    }
}
