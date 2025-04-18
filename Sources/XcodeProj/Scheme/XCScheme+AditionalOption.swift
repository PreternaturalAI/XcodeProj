import _AEXML
import Foundation
import PathKit

public extension XCScheme {
    final class AdditionalOption: Equatable {
        // MARK: - Attributes

        public var key: String
        public var value: String
        public var isEnabled: Bool

        // MARK: - Init

        public init(key: String, value: String, isEnabled: Bool) {
            self.key = key
            self.value = value
            self.isEnabled = isEnabled
        }

        init(element: AEXMLElement) throws {
            key = element.attributes["key"]!
            value = element.attributes["value"]!
            isEnabled = element.attributes["isEnabled"] == "YES"
        }

        // MARK: - XML

        func xmlElement() -> AEXMLElement {
            AEXMLElement(name: "AdditionalOption",
                         value: nil,
                         attributes: [
                             "key": key,
                             "value": value,
                             "isEnabled": isEnabled.xmlString,
                         ])
        }

        // MARK: - Equatable

        public static func == (lhs: AdditionalOption, rhs: AdditionalOption) -> Bool {
            lhs.key == rhs.key &&
                lhs.value == rhs.value &&
                lhs.isEnabled == rhs.isEnabled
        }
    }
}
