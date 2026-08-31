import Foundation
import XCTest

@testable import XcodeProj

final class XCSwiftPackageProductDependencyTests: XCTestCase {
    func test_init() throws {
        // Given
        let decoder = XcodeprojPropertyListDecoder()
        let encoder = PropertyListEncoder()
        let plist = ["reference": [
            "productName": "xcodeproj",
            "package": "packageReference"]]
        let data = try encoder.encode(plist)

        // When
        let decoded = try decoder.decode([String: XCSwiftPackageProductDependency].self, from: data)
        let got = try XCTUnwrap(decoded["reference"])

        // Then
        XCTAssertEqual(got.productName, "xcodeproj")
        XCTAssertEqual(got.packageReference?.value, "packageReference")
        XCTAssertEqual(got.isPlugin, false)
    }

    func test_initAsPlugin() throws {
        // Given
        let decoder = XcodeprojPropertyListDecoder()
        let encoder = PropertyListEncoder()
        let plist = ["reference": [
            "productName": "plugin:xcodeproj",
            "package": "packageReference"]]
        let data = try encoder.encode(plist)

        // When
        let decoded = try decoder.decode([String: XCSwiftPackageProductDependency].self, from: data)
        let got = try XCTUnwrap(decoded["reference"])

        // Then
        XCTAssertEqual(got.productName, "xcodeproj")
        XCTAssertEqual(got.packageReference?.value, "packageReference")
        XCTAssertEqual(got.isPlugin, true)
    }

    func test_plistValues() throws {
        // Given
        let proj = PBXProj()
        let package = XCRemoteSwiftPackageReference(repositoryURL: "repository")
        let subject = XCSwiftPackageProductDependency(productName: "product",
                                                      package: package)

        // When
        let got = try subject.plistKeyAndValue(proj: proj, reference: "reference")

        // Then
        XCTAssertEqual(got.value, .dictionary([
            "isa": "XCSwiftPackageProductDependency",
            "productName": "product",
            "package": .string(.init(package.reference.value, comment: "XCRemoteSwiftPackageReference \"\(package.name ?? "")\"")),
        ]))
    }

    func test_plistValuesAsPlugin() throws {
        // Given
        let proj = PBXProj()
        let package = XCRemoteSwiftPackageReference(repositoryURL: "repository")
        let subject = XCSwiftPackageProductDependency(productName: "product",
                                                      package: package,
                                                      isPlugin: true)

        // When
        let got = try subject.plistKeyAndValue(proj: proj, reference: "reference")

        // Then
        XCTAssertEqual(got.value, .dictionary([
            "isa": "XCSwiftPackageProductDependency",
            "productName": "plugin:product",
            "package": .string(.init(package.reference.value, comment: "XCRemoteSwiftPackageReference \"\(package.name ?? "")\"")),
        ]))
    }

    func test_plistValuesWithLocalPackage() throws {
        let proj = PBXProj()
        let package = XCLocalSwiftPackageReference(relativePath: "../LocalPackage")
        let subject = XCSwiftPackageProductDependency(productName: "product", package: package)

        let got = try subject.plistKeyAndValue(proj: proj, reference: "reference")

        XCTAssertIdentical(subject.referencedPackage, package)
        XCTAssertNil(subject.package)
        XCTAssertEqual(got.value, .dictionary([
            "isa": "XCSwiftPackageProductDependency",
            "productName": "product",
            "package": .string(.init(package.reference.value, comment: "XCLocalSwiftPackageReference \"\(package.name ?? "")\"")),
        ]))
    }
}
