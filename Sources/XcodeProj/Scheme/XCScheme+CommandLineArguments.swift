import _AEXML
import Foundation

public extension XCScheme {
    final class CommandLineArguments: Equatable {
        // MARK: - Attributes

        public let arguments: [CommandLineArgument]

        // MARK: - Init

        public init(arguments args: [CommandLineArgument]) {
            arguments = args
        }

        init(element: AEXMLElement) throws {
            arguments = try element.children.map { elt in
                guard let argName = elt.attributes["argument"] else {
                    throw XCSchemeError.missing(property: "argument")
                }
                guard let argEnabledRaw = elt.attributes["isEnabled"] else {
                    throw XCSchemeError.missing(property: "isEnabled")
                }
                return CommandLineArgument(name: argName, enabled: argEnabledRaw == "YES")
            }
        }

        // MARK: - XML

        func xmlElement() -> AEXMLElement {
            let element = AEXMLElement(name: "CommandLineArguments",
                                       value: nil)
            for arg in arguments {
                element.addChild(arg.xmlElement())
            }
            return element
        }

        // MARK: - Equatable

        public static func == (lhs: CommandLineArguments, rhs: CommandLineArguments) -> Bool {
            lhs.arguments == rhs.arguments
        }
    }
}

public extension XCScheme.CommandLineArguments {
    struct CommandLineArgument: Equatable {
        // MARK: - Attributes

        public let name: String
        public let enabled: Bool

        // MARK: - Init

        public init(name: String, enabled: Bool) {
            self.name = name
            self.enabled = enabled
        }

        // MARK: - XML

        func xmlElement() -> AEXMLElement {
            AEXMLElement(name: "CommandLineArgument",
                         value: nil,
                         attributes: ["argument": name, "isEnabled": enabled ? "YES" : "NO"])
        }

        // MARK: - Equatable

        public static func == (lhs: CommandLineArgument, rhs: CommandLineArgument) -> Bool {
            lhs.name == rhs.name &&
                lhs.enabled == rhs.enabled
        }
    }
}
