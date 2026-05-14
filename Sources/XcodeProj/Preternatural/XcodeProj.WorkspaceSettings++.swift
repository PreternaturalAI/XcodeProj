//
// Copyright (c) Vatsal Manot
//

import Foundation
import XcodeProjPathKit

extension WorkspaceSettings {
    public static func at(pathString: String) throws -> WorkspaceSettings {
        try at(path: Path(pathString))
    }

    public static func at(url: URL) throws -> WorkspaceSettings {
        try at(path: Path(url.path))
    }

    public func write(pathString: String, override: Bool) throws {
        try write(path: Path(pathString), override: override)
    }

    public func write(url: URL, override: Bool) throws {
        try write(path: Path(url.path), override: override)
    }
}
