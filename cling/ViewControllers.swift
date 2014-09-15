var _sharedInstance: ViewControllers?

class ViewControllers {
    private init() {
    }

    class var sharedInstance: ViewControllers {
        get {
            if (_sharedInstance == nil) {
                _sharedInstance = ViewControllers()
            }
            return _sharedInstance!
        }
    }

    private var _mainViewController: MainViewController?
    var mainViewController: MainViewController {
        get {
            if (_mainViewController == nil) {
                _mainViewController = MainViewController()
            }
            return _mainViewController!
        }
    }

    private var _preferenceViewController: PreferenceViewController?
    var preferenceViewController: PreferenceViewController {
        get {
            if (_preferenceViewController == nil) {
                _preferenceViewController = PreferenceViewController()
            }
            return _preferenceViewController!
        }
    }
    
    private var _urlPreferenceViewController: URLPreferenceViewController?
    var urlPreferenceViewController: URLPreferenceViewController {
        get {
            if (_urlPreferenceViewController == nil) {
                _urlPreferenceViewController = URLPreferenceViewController()
            }
            return _urlPreferenceViewController!
        }
    }
}
