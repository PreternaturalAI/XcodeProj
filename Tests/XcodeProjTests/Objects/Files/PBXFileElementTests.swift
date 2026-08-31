import XcodeProjPathKit
import XCTest
@testable import XcodeProj

final class PBXFileElementTests: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXFileElement.isa, "PBXFileElement")
    }

    func test_fullPath_with_parent() throws {
        let sourceRoot = Path("/")
        let fileref = PBXFileReference(sourceTree: .group,
                                       fileEncoding: 1,
                                       explicitFileType: "sourcecode.swift",
                                       lastKnownFileType: nil,
                                       path: "/a/path")
        let group = PBXGroup(children: [fileref],
                             sourceTree: .group,
                             name: "/to/be/ignored")

        let mainGroup = PBXGroup(children: [group],
                                 sourceTree: .group,
                                 name: "/to/be/ignored")

        let project = PBXProject(name: "ProjectName",
                                 buildConfigurationList: XCConfigurationList(),
                                 compatibilityVersion: "0",
                                 preferredProjectObjectVersion: nil,
                                 minimizedProjectReferenceProxies: nil,
                                 mainGroup: mainGroup)

        let objects = PBXObjects(objects: [project, mainGroup, fileref, group])
        fileref.reference.objects = objects
        group.reference.objects = objects

        let fullPath = try fileref.fullPath(sourceRoot: sourceRoot)
        XCTAssertEqual(fullPath?.string, "/a/path")
        XCTAssertNotNil(group.children.first?.parent)
    }

    func test_fullPath_without_parent() throws {
        let sourceRoot = Path("/")
        let fileref = PBXFileReference(sourceTree: .group,
                                       fileEncoding: 1,
                                       explicitFileType: "sourcecode.swift",
                                       lastKnownFileType: nil,
                                       path: "/a/path")
        let group = PBXGroup(children: [fileref],
                             sourceTree: .group,
                             name: "/to/be/ignored",
                             path: "groupPath")

        let objects = PBXObjects(objects: [fileref, group])
        fileref.reference.objects = objects
        group.reference.objects = objects
        // Remove parent for fallback test
        fileref.parent = nil

        XCTAssertThrowsError(try fileref.fullPath(sourceRoot: sourceRoot)) { error in
            if case let PBXProjError.invalidGroupPath(sourceRoot, elementPath) = error {
                XCTAssertEqual(sourceRoot, "/")
                XCTAssertEqual(elementPath, "groupPath")
            } else {
                XCTAssert(false, "fullPath should fails with PBXProjError.invalidGroupPath instaed of: \(error)")
            }
        }
    }

    func test_fullPath_with_nested_groups() throws {
        let sourceRoot = Path("/")
        let fileref = PBXFileReference(sourceTree: .group,
                                       fileEncoding: 1,
                                       explicitFileType: "sourcecode.swift",
                                       lastKnownFileType: nil,
                                       path: "file/path")
        let nestedGroup = PBXGroup(children: [fileref],
                                   sourceTree: .group,
                                   path: "group/path")
        let rootGroup = PBXGroup(children: [nestedGroup],
                                 sourceTree: .group)

        let project = PBXProject(name: "ProjectName",
                                 buildConfigurationList: XCConfigurationList(),
                                 compatibilityVersion: "0",
                                 preferredProjectObjectVersion: nil,
                                 minimizedProjectReferenceProxies: nil,
                                 mainGroup: rootGroup)

        let objects = PBXObjects(objects: [fileref, nestedGroup, rootGroup, project])
        fileref.reference.objects = objects
        nestedGroup.reference.objects = objects

        let fullPath = try fileref.fullPath(sourceRoot: sourceRoot)
        XCTAssertEqual(fullPath?.string, "/group/path/file/path")
    }
}
