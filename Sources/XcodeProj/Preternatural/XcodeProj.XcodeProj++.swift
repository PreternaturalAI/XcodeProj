//
// Copyright (c) Vatsal Manot
//

import Foundation
import XcodeProjPathKit

extension XcodeProj {
    // MARK: - Init

    public convenience init(url: URL) throws {
        try self.init(path: Path(url.path))
    }

    // MARK: - Write

    public func write(pathString: String, override: Bool = true) throws {
        try write(path: Path(pathString), override: override)
    }

    public func write(url: URL, override: Bool = true) throws {
        try write(path: Path(url.path), override: override)
    }

    public func write(pathString: String, override: Bool = true, outputSettings: PBXOutputSettings) throws {
        try write(path: Path(pathString), override: override, outputSettings: outputSettings)
    }

    public func write(url: URL, override: Bool = true, outputSettings: PBXOutputSettings) throws {
        try write(path: Path(url.path), override: override, outputSettings: outputSettings)
    }

    // MARK: - Workspace

    public static func workspacePath(_ pathString: String) -> String {
        workspacePath(Path(pathString)).string
    }

    public static func workspacePath(_ url: URL) -> URL {
        workspacePath(Path(url.path)).url
    }

    public func writeWorkspace(pathString: String, override: Bool = true) throws {
        try writeWorkspace(path: Path(pathString), override: override)
    }

    public func writeWorkspace(url: URL, override: Bool = true) throws {
        try writeWorkspace(path: Path(url.path), override: override)
    }

    // MARK: - PBXProj

    public static func pbxprojPath(_ pathString: String) -> String {
        pbxprojPath(Path(pathString)).string
    }

    public static func pbxprojPath(_ url: URL) -> URL {
        pbxprojPath(Path(url.path)).url
    }

    public func writePBXProj(pathString: String, override: Bool = true, outputSettings: PBXOutputSettings = PBXOutputSettings()) throws {
        try writePBXProj(path: Path(pathString), override: override, outputSettings: outputSettings)
    }

    public func writePBXProj(url: URL, override: Bool = true, outputSettings: PBXOutputSettings = PBXOutputSettings()) throws {
        try writePBXProj(path: Path(url.path), override: override, outputSettings: outputSettings)
    }

    // MARK: - Shared Data

    public static func sharedDataPath(_ pathString: String) -> String {
        sharedDataPath(Path(pathString)).string
    }

    public static func sharedDataPath(_ url: URL) -> URL {
        sharedDataPath(Path(url.path)).url
    }

    public func writeSharedData(pathString: String, override: Bool = true) throws {
        try writeSharedData(path: Path(pathString), override: override)
    }

    public func writeSharedData(url: URL, override: Bool = true) throws {
        try writeSharedData(path: Path(url.path), override: override)
    }

    // MARK: - User Data

    public func writeUserData(pathString: String, override: Bool = true) throws {
        try writeUserData(path: Path(pathString), override: override)
    }

    public func writeUserData(url: URL, override: Bool = true) throws {
        try writeUserData(path: Path(url.path), override: override)
    }

    // MARK: - Schemes

    public func writeSchemes(pathString: String, override: Bool = true) throws {
        try writeSchemes(path: Path(pathString), override: override)
    }

    public func writeSchemes(url: URL, override: Bool = true) throws {
        try writeSchemes(path: Path(url.path), override: override)
    }

    // MARK: - Breakpoints

    public func writeBreakPoints(pathString: String, override: Bool = true) throws {
        try writeBreakPoints(path: Path(pathString), override: override)
    }

    public func writeBreakPoints(url: URL, override: Bool = true) throws {
        try writeBreakPoints(path: Path(url.path), override: override)
    }

    // MARK: - Utilities

    public var remotePackageURLs: Set<String> {
        var remotePackageURLs = Set<String>()
        if let root = pbxproj.rootObject {
            for package in root.remotePackages {
                if let repositoryURL = package.repositoryURL {
                    remotePackageURLs.append(repositoryURL)
                }
            }
        }
        return remotePackageURLs
    }

    public func allSchemes() -> [String] {
        var allSchemes: Set<String> = []
        if let schemes = self.sharedData?.schemes {
            for scheme in schemes {
                allSchemes.insert(scheme.name)
            }
        }
        for data in self.userData {
            for scheme in data.schemes {
                allSchemes.insert(scheme.name)
            }
        }
        let allTargets = self.pbxproj.legacyTargets + self.pbxproj.nativeTargets + self.pbxproj.aggregateTargets
        for target in allTargets {
            allSchemes.insert(target.name)
        }
        return Array(allSchemes)
    }
}
