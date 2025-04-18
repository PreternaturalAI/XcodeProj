import _AEXML
import Foundation

extension AEXMLDocument {
    var xmlXcodeFormat: String {
        var xml = "<?xml version=\"\(options.documentHeader.version)\" encoding=\"\(options.documentHeader.encoding.uppercased())\"?>\n"
        xml += root._xmlXcodeFormat + "\n"
        return xml
    }
}

let attributesOrder: [String: [String]] = [
    "BuildAction": [
        "parallelizeBuildables",
        "buildImplicitDependencies",
        "buildArchitectures",
        "runPostActionsOnFailure",
    ],
    "BuildActionEntry": [
        "buildForTesting",
        "buildForRunning",
        "buildForProfiling",
        "buildForArchiving",
        "buildForAnalyzing",
    ],
    "BuildableReference": [
        "BuildableIdentifier",
        "BlueprintIdentifier",
        "BuildableName",
        "BlueprintName",
        "ReferencedContainer",
    ],
    "TestAction": [
        "buildConfiguration",
        "selectedDebuggerIdentifier",
        "selectedLauncherIdentifier",
        "customLLDBInitFile",
        "language",
        "shouldUseLaunchSchemeArgsEnv",
        "disableMainThreadChecker",
        "region",
        "preferredScreenCaptureFormat",
        "codeCoverageEnabled",
        "onlyGenerateCoverageForSpecifiedTargets",
    ],
    "LaunchAction": [
        "buildConfiguration",
        "selectedDebuggerIdentifier",
        "selectedLauncherIdentifier",
        "customLLDBInitFile",
        "disableMainThreadChecker",
        "disablePerformanceAntipatternChecker",
        "language",
        "region",
        "launchStyle",
        "askForAppToLaunch",
        "useCustomWorkingDirectory",
        "customWorkingDirectory",
        "ignoresPersistentStateOnLaunch",
        "debugDocumentVersioning",
        "debugServiceExtension",
        "enableGPUFrameCaptureMode",
        "enableGPUValidationMode",
        "allowLocationSimulation",
        "storeKitConfigurationFileReference",
    ],
    "ProfileAction": [
        "buildConfiguration",
        "shouldUseLaunchSchemeArgsEnv",
        "savedToolIdentifier",
        "useCustomWorkingDirectory",
        "customWorkingDirectory",
        "ignoresPersistentStateOnLaunch",
        "debugDocumentVersioning",
        "enableTestabilityWhenProfilingTests",
    ],
    "ActionContent": [
        "title",
        "scriptText",
        "message",
        "conveyanceType",
    ],
    "EnvironmentVariable": [
        "key",
        "value",
        "isEnabled",
    ],
    "TestableReference": [
        "skipped",
        "parallelizable",
        "testExecutionOrdering",
    ],
    "BreakpointContent": [
        "shouldBeEnabled",
        "ignoreCount",
        "continueAfterRunningActions",
        "breakpointStackSelectionBehavior",
        "scope",
        "stopOnStyle",
        "symbolName",
        "moduleName",
    ],
    "RemoteRunnable": [
        "runnableDebuggingMode",
        "BundleIdentifier",
        "RemotePath",
    ],
    "Scheme": [
        "LastUpgradeVersion",
        "wasCreatedForAppExtension",
        "version",
    ],
]

extension AEXMLElement {
    fileprivate var _xmlXcodeFormat: String {
        var xml = String()

        // open element
        xml += indent(withDepth: parentsCount - 1)
        xml += "<\(name)"

        func print(key: String, value: String) {
            xml += "\n"
            xml += indent(withDepth: parentsCount)
            xml += "\(key) = \"\(value.xmlEscaped)\""
        }

        if !attributes.isEmpty {
            // insert known attributes in the specified order.
            var attributes = attributes
            for key in attributesOrder[name] ?? [] {
                if let value = attributes.removeValue(forKey: key) {
                    print(key: key, value: value)
                }
            }

            // Print any remaining attributes.
            for (key, value) in attributes.sorted(by: { $0.key < $1.key }) {
                print(key: key, value: value)
            }
        }

        if value == nil, children.isEmpty {
            // close element
            xml += ">\n"
        } else {
            if !children.isEmpty {
                // add children
                xml += ">\n"
                for child in children {
                    xml += "\(child._xmlXcodeFormat)\n"
                }
            } else {
                // insert string value and close element
                xml += ">\n"
                xml += indent(withDepth: parentsCount - 1)
                xml += ">\n\(string.xmlEscaped)"
            }
        }

        xml += indent(withDepth: parentsCount - 1)
        xml += "</\(name)>"

        return xml
    }

    private var parentsCount: Int {
        var count = 0
        var element = self

        while let parent = element.parent {
            count += 1
            element = parent
        }

        return count
    }

    private func indent(withDepth depth: Int) -> String {
        var count = depth
        var indent = String()

        while count > 0 {
            indent += "   "
            count -= 1
        }

        return indent
    }
}
