import Foundation

/// A proxy for another object which might belong to another project
/// contained in the same workspace of the document.
/// This class is referenced by PBXTargetDependency.
public final class PBXReferenceProxy: PBXFileElement {
    // MARK: - Attributes

    /// Element file type
    public var fileType: String?

    /// Element remote reference.
    var remoteReference: PBXObjectReference?

    /// Element remote.
    public var remote: PBXContainerItemProxy? {
        get {
            remoteReference?.getObject()
        }
        set {
            remoteReference = newValue?.reference
        }
    }

    // MARK: - Init

    /// Initializes the reference proxy.
    ///
    /// - Parameters:
    ///   - fileType: File type.
    ///   - path: Path.
    ///   - remote: Remote.
    ///   - sourceTree: Source tree.
    public init(fileType: String? = nil,
                path: String? = nil,
                name: String? = nil,
                remote: PBXContainerItemProxy? = nil,
                sourceTree: PBXSourceTree? = nil) {
        self.fileType = fileType
        remoteReference = remote?.reference
        super.init(sourceTree: sourceTree, path: path, name: name)
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case fileType
        case remoteRef
    }

    public required init(from decoder: Decoder) throws {
        let objectReferenceRepository = decoder.context.objectReferenceRepository
        let objects = decoder.context.objects
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let remoteRefString: String = try container.decodeIfPresent(.remoteRef) {
            remoteReference = objectReferenceRepository.getOrCreate(reference: remoteRefString, objects: objects)
        }
        fileType = try container.decodeIfPresent(.fileType)
        try super.init(from: decoder)
    }

    override var plistComment: String? { path }

    override func plistDictionary(proj: PBXProj) throws -> [CommentedString: PlistValue] {
        var dictionary = try super.plistDictionary(proj: proj)
        dictionary["isa"] = .string(CommentedString(PBXReferenceProxy.isa))
        if let fileType {
            dictionary["fileType"] = .string(CommentedString(fileType))
        }
        if let remoteReference {
            dictionary["remoteRef"] = .string(CommentedString(remoteReference.value, comment: "PBXContainerItemProxy"))
        }
        return dictionary
    }

    override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXReferenceProxy else { return false }
        return isEqual(to: rhs)
    }
}
