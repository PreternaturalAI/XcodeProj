//
// Copyright (c) Vatsal Manot
//

import Foundation
import XcodeProjPathKit

extension PBXFileElement {
    public func fullPath(sourceRoot url: URL) throws -> URL? {
        try fullPath(sourceRoot: Path(url.path))?.url
    }
}
