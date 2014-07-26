class EditableViewCell: UITableViewCell {
    var textField: UITextField?
    var saveButton: UITextField?
    
    init(reuseIdentifier: String) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.None
        showEditField()
    }
    
    private func showEditField() {
        let textField = UITextField(frame: CGRectMake(5, 5, bounds.width - 70, bounds.height - 10))
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        textField.textAlignment = NSTextAlignment.Left
        textField.returnKeyType = UIReturnKeyType.Done
        textField.clearButtonMode = UITextFieldViewMode.WhileEditing
        textField.adjustsFontSizeToFitWidth = true
        addSubview(textField)
        
        let saveButton = UIButton(frame: CGRectMake(5 + bounds.width - 60, 5, 60, bounds.height - 10))
        saveButton.layer.borderWidth = 1.0
        saveButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        saveButton.layer.cornerRadius = 5.0
        let textColor = UIColor(red: CGFloat(0.9), green: CGFloat(0.9), blue: CGFloat(0.9), alpha: CGFloat(1.0))
        saveButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        saveButton.setTitle("Save", forState: UIControlState.Normal)
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
