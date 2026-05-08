import Foundation
import XcodeProjPathKit
import XCTest

extension XCTestCase {
    func withTemporaryDirectory(_ closure: (Path) throws -> Void) throws {
        let directory = try Path.uniqueTemporary()
        try closure(directory)
        try directory.delete()
    }
}
