import XcodeProj
import XCTest

final class PBXBuildRuleTests: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXBuildRule.isa, "PBXBuildRule")
    }
}
