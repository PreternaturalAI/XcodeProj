import XCTest
@testable import XcodeProj

final class PBXFrameworksBuildPhaseTests: XCTestCase {
    func test_isa_returnsTheRightValue() {
        XCTAssertEqual(PBXFrameworksBuildPhase.isa, "PBXFrameworksBuildPhase")
    }
}
