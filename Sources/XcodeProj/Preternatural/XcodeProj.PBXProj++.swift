//
// Copyright (c) Vatsal Manot
//

import Foundation
import XcodeProjPathKit

extension PBXProj {
    public convenience init(pathString: String) throws {
        try self.init(path: Path(pathString))
    }

    public convenience init(url: URL) throws {
        try self.init(path: Path(url.path))
    }

    public func write(pathString: String, override: Bool) throws {
        try write(path: Path(pathString), override: override)
    }

    public func write(url: URL, override: Bool) throws {
        try write(path: Path(url.path), override: override)
    }

    public func write(pathString: String, override: Bool, outputSettings: PBXOutputSettings) throws {
        try write(path: Path(pathString), override: override, outputSettings: outputSettings)
    }

    public func write(url: URL, override: Bool, outputSettings: PBXOutputSettings) throws {
        try write(path: Path(url.path), override: override, outputSettings: outputSettings)
    }

    public func batchUpdate(sourceRootString: String, closure: (PBXBatchUpdater) throws -> Void) throws {
        try batchUpdate(sourceRoot: Path(sourceRootString), closure: closure)
    }

    public func batchUpdate(sourceRootURL: URL, closure: (PBXBatchUpdater) throws -> Void) throws {
        try batchUpdate(sourceRoot: Path(sourceRootURL.path), closure: closure)
    }
}
