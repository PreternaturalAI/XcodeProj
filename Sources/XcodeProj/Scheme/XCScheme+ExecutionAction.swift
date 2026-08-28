import _AEXML
import Foundation

public extension XCScheme {
    final class ExecutionAction: Equatable {
        public static let shellScriptActionType = "Xcode.IDEStandardExecutionActionsCore.ExecutionActionType.ShellScriptAction"

        // MARK: - Attributes

        /// The action type read from the scheme XML.
        ///
        /// New actions created through the public initializer are always shell
        /// script actions. Other values are retained when parsing existing
        /// schemes so consumers can reject unsupported action types explicitly.
        public private(set) var actionType: String
        public var title: String
        public var scriptText: String
        public var shellToInvoke: String?
        public var environmentBuildable: BuildableReference?

        // MARK: - Init

        public init(
            scriptText: String,
            title: String = "Run Script",
            shellToInvoke: String? = nil,
            environmentBuildable: BuildableReference? = nil
        ) {
            actionType = Self.shellScriptActionType
            self.scriptText = scriptText
            self.title = title
            self.shellToInvoke = shellToInvoke
            self.environmentBuildable = environmentBuildable
        }

        init(element: AEXMLElement) throws {
            actionType = element.attributes["ActionType"] ?? ""
            scriptText = element["ActionContent"].attributes["scriptText"] ?? ""
            title = element["ActionContent"].attributes["title"] ?? "Run Script"
            if let shellToInvoke = element["ActionContent"].attributes["shellToInvoke"] {
                self.shellToInvoke = shellToInvoke
            }
            environmentBuildable = try? BuildableReference(element: element["ActionContent"]["EnvironmentBuildable"]["BuildableReference"])
        }

        // MARK: - XML

        func xmlElement() -> AEXMLElement {
            let element = AEXMLElement(name: "ExecutionAction",
                                       value: nil,
                                       attributes: ["ActionType": actionType])
            var attributes = [
                "title": title,
                "scriptText": scriptText,
            ]
            if let shellToInvoke {
                attributes["shellToInvoke"] = shellToInvoke
            }
            let content = AEXMLElement(name: "ActionContent",
                                       value: nil,
                                       attributes: attributes)
            element.addChild(content)
            if let environmentBuildable {
                let environment = content.addChild(name: "EnvironmentBuildable")
                environment.addChild(environmentBuildable.xmlElement())
            }
            return element
        }

        // MARK: - Equatable

        public static func == (lhs: ExecutionAction, rhs: ExecutionAction) -> Bool {
            lhs.actionType == rhs.actionType &&
                lhs.title == rhs.title &&
                lhs.scriptText == rhs.scriptText &&
                lhs.shellToInvoke == rhs.shellToInvoke &&
                lhs.environmentBuildable == rhs.environmentBuildable
        }
    }
}
