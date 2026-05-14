//
// Copyright (c) Vatsal Manot
//

import Foundation
import XcodeProjPathKit

extension PBXGroup {
    public func addFile(at path: String, sourceRoot: String) throws -> PBXFileReference {
        try self.addFile(at: Path(path), sourceRoot: Path(sourceRoot))
    }

    public func addFile(at url: URL, sourceRoot: URL) throws -> PBXFileReference {
        try self.addFile(at: Path(url.path), sourceRoot: Path(sourceRoot.path))
    }
}
