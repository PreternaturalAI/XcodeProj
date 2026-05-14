//
// Copyright (c) Vatsal Manot
//

import Foundation
import XcodeProjPathKit

extension XCWorkspace {
    public convenience init(url: URL) throws {
        try self.init(path: Path(url.path))
    }

    public func write(pathString: String, override: Bool = true) throws {
        try write(path: Path(pathString), override: override)
    }

    public func write(url: URL, override: Bool = true) throws {
        try write(path: Path(url.path), override: override)
    }

    public func referencedPackages(at baseURL: URL) -> [URL] {
        var allProjectURLs: [URL] = []
        for child: XCWorkspaceDataElement in data.children {
            let fileURLs: [URL] = child.referencedFiles(at: baseURL.deletingLastPathComponent())
            let projectURLs: [URL] = fileURLs.filter { (url: URL) -> Bool in url.isPackageURL }
            allProjectURLs.append(contentsOf: projectURLs)
        }
        return allProjectURLs
    }

    public func referencedProjects(at baseURL: URL) -> [URL] {
        var allProjectURLs: [URL] = []
        for child: XCWorkspaceDataElement in data.children {
            let fileURLs: [URL] = child.referencedFiles(at: baseURL.deletingLastPathComponent())
            let projectURLs: [URL] = fileURLs.filter { (url: URL) -> Bool in url.pathExtension == "xcodeproj" }
            allProjectURLs.append(contentsOf: projectURLs)
        }
        return allProjectURLs
    }
}
