import _AEXML
import Foundation
import PathKit

public final class XCWorkspaceData {
    public var children: [XCWorkspaceDataElement]

    public init(children: [XCWorkspaceDataElement]) {
        self.children = children
    }
}

extension XCWorkspaceData: Equatable {
    public static func == (lhs: XCWorkspaceData, rhs: XCWorkspaceData) -> Bool {
        lhs.children == rhs.children
    }
}

extension XCWorkspaceData: Writable {
    /// Initializes the workspace with the path where the workspace is.
    /// The initializer will try to find an .xcworkspacedata inside the workspace.
    /// If the .xcworkspacedata cannot be found, the init will fail.
    ///
    /// - Parameter path: .xcworkspace path.
    /// - Throws: throws an error if the workspace cannot be initialized.
    public convenience init(path: Path) throws {
        if !path.exists {
            throw XCWorkspaceDataError.notFound(path: path)
        }

        let xml = try AEXMLDocument(xml: path.read())
        let children = try xml
            .root
            .children
            .compactMap(XCWorkspaceDataElement.init(element:))

        self.init(children: children)
    }

    func rawContents() -> String {
        let document = AEXMLDocument()
        let workspace = document.addChild(name: "Workspace", value: nil, attributes: ["version": "1.0"])
        _ = children
            .map { $0.xmlElement() }
            .map(workspace.addChild)
        return document.xmlXcodeFormat
    }

    // MARK: - <Writable>

    public func write(path: Path, override: Bool = true) throws {
        let rawXml = rawContents()
        if override, path.exists {
            try path.delete()
        }
        try path.write(rawXml)
    }

    public func dataRepresentation() throws -> Data? {
        rawContents().data(using: .utf8)
    }
}

// MARK: - XCWorkspaceDataElement AEXMLElement decoding and encoding

private extension XCWorkspaceDataElement {
    init(element: AEXMLElement) throws {
        switch element.name {
        case "FileRef":
            self = try .file(XCWorkspaceDataFileRef(element: element))
        case "Group":
            self = try .group(XCWorkspaceDataGroup(element: element))
        default:
            throw Error.unknownName(element.name)
        }
    }

    func xmlElement() -> AEXMLElement {
        switch self {
        case let .file(fileRef):
            fileRef.xmlElement()
        case let .group(group):
            group.xmlElement()
        }
    }
}

// MARK: - XCWorkspaceDataGroup AEXMLElement decoding and encoding

private extension XCWorkspaceDataGroup {
    enum Error: Swift.Error {
        case wrongElementName
        case missingLocationAttribute
    }

    convenience init(element: AEXMLElement) throws {
        guard element.name == "Group" else {
            throw Error.wrongElementName
        }
        guard let location = element.attributes["location"] else {
            throw Error.missingLocationAttribute
        }
        let locationType = try XCWorkspaceDataElementLocationType(string: location)
        let name = element.attributes["name"]
        let children = try element.children.map(XCWorkspaceDataElement.init(element:))
        self.init(location: locationType, name: name, children: children)
    }

    func xmlElement() -> AEXMLElement {
        var attributes = ["location": location.description]
        attributes["name"] = name
        let element = AEXMLElement(name: "Group", value: nil, attributes: attributes)

        _ = children
            .map { $0.xmlElement() }
            .map(element.addChild)

        return element
    }
}

// MARK: - XCWorkspaceDataFileRef AEXMLElement decoding and encoding

private extension XCWorkspaceDataFileRef {
    enum Error: Swift.Error {
        case wrongElementName
        case missingLocationAttribute
    }

    convenience init(element: AEXMLElement) throws {
        guard element.name == "FileRef" else {
            throw Error.wrongElementName
        }
        guard let location = element.attributes["location"] else {
            throw Error.missingLocationAttribute
        }
        try self.init(location: XCWorkspaceDataElementLocationType(string: location))
    }

    func xmlElement() -> AEXMLElement {
        AEXMLElement(name: "FileRef",
                     value: nil,
                     attributes: ["location": location.description])
    }
}
