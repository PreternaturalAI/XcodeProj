//
// Copyright (c) Vatsal Manot
//

extension PBXBuildFile {
    /// Sets whether code signing on copy is enabled for this build file
    public func setCodeSigningOnCopy(_ enabled: Bool) {
        if enabled {
            appendToSettingsArray(value: "CodeSignOnCopy", forKey: "ATTRIBUTES")
        } else {
            removeFromSettingsArray(value: "CodeSignOnCopy", forKey: "ATTRIBUTES")
        }
    }
    
    private func appendToSettingsArray(value: String, forKey key: String) {
        var currentSettings: [String: BuildFileSetting] = settings ?? [:]
        let existingValue: BuildFileSetting = currentSettings[key] ?? .array([])
        
        switch existingValue {
        case .string:
            /// Value is not an array, we will return without doing anything.
            return
        case .array(let array):
            let newArray = array.appending(value)
            currentSettings[key] = .array(newArray)
        }
        
        settings = currentSettings
    }
    
    private func removeFromSettingsArray(value: String, forKey key: String) {
        var currentSettings: [String: BuildFileSetting] = settings ?? [:]
        guard let existingValue = currentSettings[key] else {
            return
        }
        
        switch existingValue {
        case .string:
            /// Value is not an array, we will return without doing anything.
            return
        case .array(let array):
            var newArray = array
            newArray.removeAll { $0 == value }
            if newArray.isEmpty {
                currentSettings.removeValue(forKey: key)
            } else {
                currentSettings[key] = .array(newArray)
            }
        }
        
        settings = currentSettings
    }
}

