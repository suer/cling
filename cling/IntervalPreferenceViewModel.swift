class IntervalPreferenceViewModel: NSObject {
    dynamic var rotationInterval: Int = 60
    let RotationIntervalKey = "rotationInterval"

    override init() {
        super.init()
        loadRotationInterval()
    }
    
    func loadRotationInterval() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let interval = userDefaults.integerForKey(RotationIntervalKey)
        if (interval > 0) {
            rotationInterval = interval
        } else {
            setRotationInterval(60)
        }
    }

    func setRotationInterval(interval: Int) {
        rotationInterval = interval
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(rotationInterval, forKey: RotationIntervalKey)
    }
}