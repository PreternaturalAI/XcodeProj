import XCTest
@testable import XcodeProj

final class PBXFileSystemSynchronizedRootGroupTests: XCTestCase {
    func test_itHasTheCorrectIsa() {
        XCTAssertEqual(PBXFileSystemSynchronizedRootGroup.isa, "PBXFileSystemSynchronizedRootGroup")
    }
}
