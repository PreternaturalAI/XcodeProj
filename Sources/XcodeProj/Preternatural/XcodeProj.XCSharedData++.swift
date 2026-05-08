//
// Copyright (c) Vatsal Manot
//

import XcodeProjPathKit

extension XCSharedData {
    public convenience init(pathString: String) throws {
        let path = Path(pathString)
        let sharedDataPath = path + "xcshareddata"
        try self.init(path: sharedDataPath)
    }
}
