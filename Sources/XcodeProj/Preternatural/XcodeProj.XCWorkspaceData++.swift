//
// Copyright (c) Vatsal Manot
//

import Foundation
import XcodeProjPathKit

extension XCWorkspaceData {
    public convenience init(pathString: String) throws {
        try self.init(path: Path(pathString))
    }

    public convenience init(url: URL) throws {
        try self.init(path: Path(url.path))
    }

    public func write(pathString: String, override: Bool = true) throws {
        try write(path: Path(pathString), override: override)
    }

    public func write(url: URL, override: Bool = true) throws {
        try write(path: Path(url.path), override: override)
    }
}
