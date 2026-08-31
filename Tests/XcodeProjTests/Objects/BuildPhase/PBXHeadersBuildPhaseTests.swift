import XCTest
@testable import XcodeProj

final class PBXHeadersBuildPhaseTests: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXHeadersBuildPhase.isa, "PBXHeadersBuildPhase")
    }
}
