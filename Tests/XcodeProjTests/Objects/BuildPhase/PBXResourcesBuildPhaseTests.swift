import XcodeProj
import XCTest

final class PBXResourcesBuildPhaseTests: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXResourcesBuildPhase.isa, "PBXResourcesBuildPhase")
    }
}
