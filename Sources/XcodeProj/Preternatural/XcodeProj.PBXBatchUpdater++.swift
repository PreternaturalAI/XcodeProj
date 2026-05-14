//
// Copyright (c) Vatsal Manot
//

import Foundation
import XcodeProjPathKit

extension PBXBatchUpdater {
    @discardableResult
    public func addFile(
        to project: PBXProject,
        atPath filePathString: String,
        sourceTree: PBXSourceTree = .group
    ) throws -> PBXFileReference {
        try addFile(to: project, at: Path(filePathString), sourceTree: sourceTree)
    }

    @discardableResult
    public func addFile(
        to project: PBXProject,
        at fileURL: URL,
        sourceTree: PBXSourceTree = .group
    ) throws -> PBXFileReference {
        try addFile(to: project, at: Path(fileURL.path), sourceTree: sourceTree)
    }
}
