import _AEXML
import Foundation
import XcodeProjPathKit

public extension XCScheme {
    final class BuildAction: SerialAction {
        public final class Entry: Equatable {
            public enum Reference: Equatable {
                case buildable(BuildableReference)
                case testPlan(TestPlanReference)
            }

            public enum BuildFor: Sendable {
                case running, testing, profiling, archiving, analyzing
                public static let `default`: [BuildFor] = [.running, .testing, .archiving, .analyzing]
                public static let indexing: [BuildFor] = [.testing, .analyzing, .archiving]
                public static let testOnly: [BuildFor] = [.testing, .analyzing]
            }

            // MARK: - Attributes

            public var reference: Reference
            public var buildFor: [BuildFor]

            // MARK: - Init

            public init(buildableReference: BuildableReference,
                        buildFor: [BuildFor]) {
                self.reference = .buildable(buildableReference)
                self.buildFor = buildFor
            }

            public init(testPlanReference: TestPlanReference,
                        buildFor: [BuildFor]) {
                self.reference = .testPlan(testPlanReference)
                self.buildFor = buildFor
            }

            public var buildableReference: BuildableReference? {
                guard case let .buildable(reference) = reference else { return nil }
                return reference
            }

            public var testPlanReference: TestPlanReference? {
                guard case let .testPlan(reference) = reference else { return nil }
                return reference
            }

            init(element: AEXMLElement) throws {
                var buildFor: [BuildFor] = []
                if (element.attributes["buildForTesting"].map { $0 == "YES" }) ?? true {
                    buildFor.append(.testing)
                }
                if (element.attributes["buildForRunning"].map { $0 == "YES" }) ?? true {
                    buildFor.append(.running)
                }
                if (element.attributes["buildForProfiling"].map { $0 == "YES" }) ?? true {
                    buildFor.append(.profiling)
                }
                if (element.attributes["buildForArchiving"].map { $0 == "YES" }) ?? true {
                    buildFor.append(.archiving)
                }
                if (element.attributes["buildForAnalyzing"].map { $0 == "YES" }) ?? true {
                    buildFor.append(.analyzing)
                }
                self.buildFor = buildFor
                if element["BuildableReference"].all != nil {
                    reference = .buildable(try BuildableReference(element: element["BuildableReference"]))
                } else {
                    reference = .testPlan(try TestPlanReference(element: element["TestPlanReference"]))
                }
            }

            // MARK: - XML

            fileprivate func xmlElement() -> AEXMLElement {
                var attributes: [String: String] = [:]
                attributes["buildForTesting"] = buildFor.contains(.testing) ? "YES" : "NO"
                attributes["buildForRunning"] = buildFor.contains(.running) ? "YES" : "NO"
                attributes["buildForProfiling"] = buildFor.contains(.profiling) ? "YES" : "NO"
                attributes["buildForArchiving"] = buildFor.contains(.archiving) ? "YES" : "NO"
                attributes["buildForAnalyzing"] = buildFor.contains(.analyzing) ? "YES" : "NO"
                let element = AEXMLElement(name: "BuildActionEntry",
                                           value: nil,
                                           attributes: attributes)
                switch reference {
                case let .buildable(reference):
                    element.addChild(reference.xmlElement())
                case let .testPlan(reference):
                    element.addChild(reference.xmlElement())
                }
                return element
            }

            // MARK: - Equatable

            public static func == (lhs: Entry, rhs: Entry) -> Bool {
                lhs.reference == rhs.reference &&
                    lhs.buildFor == rhs.buildFor
            }
        }

        public enum Architectures {
            case matchRunDestination
            case universal
            case useTargetSettings

            fileprivate var xmlString: String? {
                switch self {
                case .matchRunDestination:
                    "Automatic"
                case .universal:
                    "All"
                case .useTargetSettings:
                    nil
                }
            }

            /// Creates a new instance from the given xml string.
            ///
            /// For undefined value, initialized as `useTargetSettings` since the XML element is removed.
            fileprivate init(_ xmlString: String) {
                switch xmlString {
                case "Automatic":
                    self = .matchRunDestination
                case "All":
                    self = .universal
                default:
                    self = .useTargetSettings
                }
            }
        }

        // MARK: - Attributes

        public var buildActionEntries: [Entry]
        public var parallelizeBuild: Bool
        public var buildImplicitDependencies: Bool
        public var runPostActionsOnFailure: Bool?
        public var buildArchitectures: Architectures

        // MARK: - Init

        public init(buildActionEntries: [Entry] = [],
                    preActions: [ExecutionAction] = [],
                    postActions: [ExecutionAction] = [],
                    parallelizeBuild: Bool = false,
                    buildImplicitDependencies: Bool = false,
                    runPostActionsOnFailure: Bool? = nil,
                    buildArchitectures: Architectures = .useTargetSettings) {
            self.buildActionEntries = buildActionEntries
            self.parallelizeBuild = parallelizeBuild
            self.buildImplicitDependencies = buildImplicitDependencies
            self.runPostActionsOnFailure = runPostActionsOnFailure
            self.buildArchitectures = buildArchitectures
            super.init(preActions, postActions)
        }

        override init(element: AEXMLElement) throws {
            parallelizeBuild = element.attributes["parallelizeBuildables"].map { $0 == "YES" } ?? true
            buildImplicitDependencies = element.attributes["buildImplicitDependencies"].map { $0 == "YES" } ?? true
            runPostActionsOnFailure = element.attributes["runPostActionsOnFailure"].map { $0 == "YES" }
            buildActionEntries = try element["BuildActionEntries"]["BuildActionEntry"]
                .all?
                .map(Entry.init) ?? []
            buildArchitectures = element.attributes["buildArchitectures"].map { Architectures($0) } ?? .useTargetSettings
            try super.init(element: element)
        }

        // MARK: - Helpers

        public func add(buildActionEntry: Entry) -> BuildAction {
            var buildActionEntries = buildActionEntries
            buildActionEntries.append(buildActionEntry)
            return BuildAction(buildActionEntries: buildActionEntries,
                               parallelizeBuild: parallelizeBuild)
        }

        // MARK: - XML

        func xmlElement() -> AEXMLElement {
            var attributes = [
                "parallelizeBuildables": parallelizeBuild.xmlString,
                "buildImplicitDependencies": buildImplicitDependencies.xmlString,
            ]

            if let buildArchitecturesXMLString = buildArchitectures.xmlString {
                attributes["buildArchitectures"] = buildArchitecturesXMLString
            }

            if let runPostActionsOnFailure {
                attributes["runPostActionsOnFailure"] = runPostActionsOnFailure.xmlString
            }

            let element = AEXMLElement(name: "BuildAction",
                                       value: nil,
                                       attributes: attributes)
            super.writeXML(parent: element)
            let entries = element.addChild(name: "BuildActionEntries")
            for entry in buildActionEntries {
                entries.addChild(entry.xmlElement())
            }
            return element
        }

        // MARK: - Equatable

        override func isEqual(to: Any?) -> Bool {
            guard let rhs = to as? BuildAction else { return false }
            return super.isEqual(to: to) &&
                buildActionEntries == rhs.buildActionEntries &&
                parallelizeBuild == rhs.parallelizeBuild &&
                buildImplicitDependencies == rhs.buildImplicitDependencies &&
                runPostActionsOnFailure == rhs.runPostActionsOnFailure &&
                buildArchitectures == rhs.buildArchitectures
        }
    }
}
