//
// Copyright (c) Vatsal Manot
//

import Foundation
import XcodeProjPathKit

extension XCSchemeManagement {
    public init(pathString: String) throws {
        try self.init(path: Path(pathString))
    }

    public init(url: URL) throws {
        try self.init(path: Path(url.path))
    }

    public func write(pathString: String, override: Bool = false) throws {
        try write(path: Path(pathString), override: override)
    }

    public func write(url: URL, override: Bool = false) throws {
        try write(path: Path(url.path), override: override)
    }
}
