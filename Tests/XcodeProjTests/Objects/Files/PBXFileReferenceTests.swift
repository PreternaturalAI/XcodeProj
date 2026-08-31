import XcodeProj
import XCTest

final class PBXFileReferenceTests: XCTestCase {
    func test_isa_hashTheCorrectValue() {
        XCTAssertEqual(PBXFileReference.isa, "PBXFileReference")
    }
}
