//
// Copyright (c) Vatsal Manot
//

import FoundationX

extension URL {
    public var isPackageURL: Bool {
        return self.pathExtension == "" && self.appendingPathComponent("Package.swift")._isValidFileURLCheckingIfExistsIfNecessary()
    }
  
    /// The format of the `xcscheme` file has been taken from:
    /// https://github.com/lorentey/swift-package-manager/blob/954427665e3216b5e87ff41e0239b2fcd6bae8e2/Sources/Xcodeproj/SchemesGenerator.swift#L106-L209
    public func createXCSchemeFile(for schemeName: String) throws {
        let content = """
        <?xml version="1.0" encoding="UTF-8"?>
        <Scheme LastUpgradeVersion = "9999" version = "1.3">
          <BuildAction parallelizeBuildables = "YES" buildImplicitDependencies = "YES" buildArchitectures = "Automatic">
            <BuildActionEntries>
                <BuildActionEntry buildForTesting = "YES" buildForRunning = "YES" buildForProfiling = "YES" buildForArchiving = "YES" buildForAnalyzing = "YES">
                  <BuildableReference
                    BuildableIdentifier = "primary"
                    BlueprintIdentifier = "\(schemeName)"
                    BuildableName = "\(schemeName)"
                    BlueprintName = "\(schemeName)"
                    ReferencedContainer = "container:">
                  </BuildableReference>
                </BuildActionEntry>
            </BuildActionEntries>
          </BuildAction>
          <TestAction
            buildConfiguration = "Debug"
            selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
            selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
            shouldUseLaunchSchemeArgsEnv = "YES"
            shouldAutocreateTestPlan = "YES"
            codeCoverageEnabled = "NO">
          </TestAction>
          <LaunchAction
             buildConfiguration = "Debug"
             selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
             selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
             launchStyle = "0"
             useCustomWorkingDirectory = "NO"
             ignoresPersistentStateOnLaunch = "NO"
             debugDocumentVersioning = "YES"
             debugServiceExtension = "internal"
             allowLocationSimulation = "YES">
             <BuildableProductRunnable
                runnableDebuggingMode = "0">
                <BuildableReference
                   BuildableIdentifier = "primary"
                   BlueprintIdentifier = "\(schemeName)"
                   BuildableName = "\(schemeName)"
                   BlueprintName = "\(schemeName)"
                   ReferencedContainer = "container:">
                </BuildableReference>
             </BuildableProductRunnable>
             <AdditionalOptions>
             </AdditionalOptions>
          </LaunchAction>
        </Scheme>
        """
        
        try writeXCSchemeFile(content: content, schemeName: schemeName)
    }
    
    public func createTestPlanSchemeFile(for testPlan: URL, schemeName: String) throws {
        let content = try """
        <?xml version="1.0" encoding="UTF-8"?>
        <Scheme LastUpgradeVersion = "9999" version = "1.3">
          <TestAction
            buildConfiguration = "Debug"
            selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
            selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
            shouldUseLaunchSchemeArgsEnv = "YES">
            <TestPlans>
              <TestPlanReference
                reference = "container:\(testPlan.path(relativeTo: self).path)">
              </TestPlanReference>
            </TestPlans>
          </TestAction>
        </Scheme>
        """
        
        try writeXCSchemeFile(content: content, schemeName: schemeName)
    }
    
    private func writeXCSchemeFile(content: String, schemeName: String) throws {
        var fileURL: URL?
      
        if self.isPackageURL {
            fileURL = self
                .appending(.directory(".swiftpm"))
                .appending(.directory("xcode"))
                .appending(.directory("xcshareddata"))
                .appending(.directory("xcschemes"))
                .appending(.file("\(schemeName).xcscheme"))
        }
        
        if self.pathExtension == "xcodeproj" {
            fileURL = self
                .appending(.directory("xcshareddata"))
                .appending(.directory("xcschemes"))
                .appending(.file("\(schemeName).xcscheme"))
        }
      
        if let fileURL = fileURL {
            let directoryURL = fileURL.deletingLastPathComponent()
            try FileManager.default.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
            
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
        }
    }
}
