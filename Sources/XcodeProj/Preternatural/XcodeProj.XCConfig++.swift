//
// Copyright (c) Vatsal Manot
//

import Foundation
import XcodeProjPathKit

extension XCConfig {
    public convenience init(pathString: String, projectPathString: String? = nil) throws {
        try self.init(path: Path(pathString), projectPath: projectPathString.map { (s: String) -> Path in Path(s) })
    }

    public convenience init(url: URL, projectURL: URL? = nil) throws {
        try self.init(path: Path(url.path), projectPath: projectURL.map { (u: URL) -> Path in Path(u.path) })
    }

    public func write(pathString: String, override: Bool) throws {
        try write(path: Path(pathString), override: override)
    }

    public func write(url: URL, override: Bool) throws {
        try write(path: Path(url.path), override: override)
    }
}
