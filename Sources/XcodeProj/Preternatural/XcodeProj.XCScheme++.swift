//
// Copyright (c) Vatsal Manot
//

import Foundation
import XcodeProjPathKit

extension XCScheme {
    public convenience init(url: URL) throws {
        try self.init(path: Path(url.path))
    }

    public func write(pathString: String, override: Bool) throws {
        try write(path: Path(pathString), override: override)
    }

    public func write(url: URL, override: Bool) throws {
        try write(path: Path(url.path), override: override)
    }
}
