//! Minimal build file for Trinity Background Agent API
//! For Railway deployment only
//! φ² + 1/φ² = 3 | TRINITY

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Background Agent API - Zig 0.15.2 uses createModule()
    const background_agent_api_module = b.createModule(.{
        .root_source_file = b.path("src/background_agent/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const background_agent_api = b.addExecutable(.{
        .name = "background-agent-api",
        .root_module = background_agent_api_module,
    });

    // Add zodd dependency
    const zodd = b.dependency("zodd", .{
        .target = target,
        .optimize = optimize,
    });
    background_agent_api.root_module.addImport("zodd", zodd.module("zodd"));

    b.installArtifact(background_agent_api);

    // Build step for Railway Dockerfile
    const build_step = b.step("background-agent-api", "Build Background Agent API (build only)");
    build_step.dependOn(&background_agent_api.step);

    // Run step (named "run" to avoid conflict)
    const run = b.addRunArtifact(background_agent_api);
    if (b.args) |args| run.addArgs(args);
    const run_step = b.step("run", "Run Background Agent API");
    run_step.dependOn(&run.step);
}
