//
//  SwiftPackageListSettingsBundlePlugin.swift
//  SwiftPackageListSettingsBundlePlugin
//
//  Created by Felix Herrmann on 27.05.23.
//

import Foundation
import PackagePlugin

@main
struct SwiftPackageListSettingsBundlePlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        return []
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftPackageListSettingsBundlePlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let projectPath = context.xcodeProject.directory.appending("\(context.xcodeProject.displayName).xcodeproj")
        let executable = try context.tool(named: "SwiftPackageListCommand").path.removingLastComponent().appending("swift-package-list")
        let outputPath = context.pluginWorkDirectory
        return [
            .buildCommand(
                displayName: "SwiftPackageListPlugin",
                executable: executable,
                arguments: ["generate", projectPath, "--output-path", outputPath, "--file-type", "settings-bundle", "--requires-license"],
                outputFiles: [outputPath.appending("Settings.bundle")]
            )
        ]
    }
}
#endif
