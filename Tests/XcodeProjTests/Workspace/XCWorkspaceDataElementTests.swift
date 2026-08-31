import Testing
import XcodeProj

struct XCWorkspaceDataElementTests {
    @Test
    func locationForwardsEveryElementKind() {
        let location: XCWorkspaceDataElementLocationType = .absolute("/workspace")
        let elements: [XCWorkspaceDataElement] = [
            .file(.init(location: location)),
            .group(.init(location: location, name: "Group", children: [])),
            .fileSystemSynchronizedGroup(
                .init(location: location, name: "Synchronized", children: [])
            ),
        ]

        #expect(elements.allSatisfy { $0.location == location })
    }
}
