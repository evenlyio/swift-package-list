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
        let executable = try context.tool(named: "swift-package-list").path
        let outputPath = context.pluginWorkDirectory
        let fileType = "settings-bundle"
        let sourcePackagesPath = try context.sourcePackagesDirectory()
        return [
            .buildCommand(
                displayName: "SwiftPackageListPlugin",
                executable: executable,
                arguments: [
                    "generate",
                    projectPath,
                    "--source-packages-path", sourcePackagesPath,
                    "--output-path", outputPath,
                    "--file-type", fileType,
                    "--requires-license",
                ],
                outputFiles: [outputPath.appending("Settings.bundle")]
            )
        ]
    }
}

struct SourcePackagesNotFoundError: Error { }

extension XcodePluginContext {
    func sourcePackagesDirectory() throws -> Path {
        var path = pluginWorkDirectory
        while path.lastComponent != "SourcePackages" {
            guard path.string != "/" else {
                throw SourcePackagesNotFoundError()
            }
            path = path.removingLastComponent()
        }
        return path
    }
}
#endif
