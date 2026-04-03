//! Minimal build file for Trinity Background Agent API
//! For Railway deployment only
//! φ² + 1/φ² = 3 | TRINITY

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Minimal test server - no dependencies
    const test_minimal_module = b.createModule(.{
        .root_source_file = b.path("src/background_agent/test_minimal.zig"),
        .target = target,
        .optimize = optimize,
    });

    const test_minimal = b.addExecutable(.{
        .name = "background-agent-api",
        .root_module = test_minimal_module,
    });

    b.installArtifact(test_minimal);

    // Build step
    const build_step = b.step("background-agent-api", "Build Background Agent API");
    build_step.dependOn(&test_minimal.step);
}
