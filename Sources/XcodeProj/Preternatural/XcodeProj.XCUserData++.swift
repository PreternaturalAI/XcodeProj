//
// Copyright (c) Vatsal Manot
//

import Foundation
import XcodeProjPathKit

extension XCUserData {
    public convenience init(pathString: String) throws {
        try self.init(path: Path(pathString))
    }

    public convenience init(url: URL) throws {
        try self.init(path: Path(url.path))
    }

    public static func initialize(from pathString: String) -> [XCUserData] {
        let path: Path = Path(pathString)
        let userData: [XCUserData] = XCUserData.path(path)
            .glob("*.xcuserdatad")
            .compactMap { (path: Path) -> XCUserData? in try? XCUserData(path: path) }
        return userData
    }

    public static func initialize(from url: URL) -> [XCUserData] {
        initialize(from: url.path)
    }

    public func write(pathString: String, override: Bool) throws {
        try write(path: Path(pathString), override: override)
    }

    public func write(url: URL, override: Bool) throws {
        try write(path: Path(url.path), override: override)
    }
}
