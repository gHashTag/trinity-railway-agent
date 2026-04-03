//! Background Agent API - Main Entrypoint
//! φ² + 1/φ² = 3 | TRINITY

const std = @import("std");

const Config = @import("./config.zig").Config;
const loadConfig = @import("./config.zig").loadConfig;
const server_module = @import("./server.zig");
const serverStart = @import("./server.zig").start;
const serverStop = @import("./server.zig").stop;
const PostgresClient = @import("./db/client.zig").PostgresClient;

const allocator = std.heap.page_allocator;

pub fn main() !u8 {
    std.log.info("Starting Background Agent API...", .{});

    // Load configuration
    const config = loadConfig(allocator) catch |err| {
        std.log.err("Failed to load config: {}", .{err});
        return 1;
    };
    std.log.info("Loaded config: port={}, local_mode={}", .{ config.port, config.localMode });

    // Initialize database client
    var db_client = PostgresClient{
        .allocator = allocator,
        .stream = null,
    };

    if (!config.localMode) {
        PostgresClient.connect(&db_client, config.databaseUrl) catch |err| {
            std.log.err("Failed to connect to database: {}", .{err});
            std.log.warn("Continuing without database connection...", .{});
        };
        std.log.info("Database connection status: {}", .{db_client.stream != null});
    } else {
        std.log.info("Running in local mode - no database connection", .{});
    }

    defer PostgresClient.close(&db_client);

    // Initialize server
    var server = server_module.init(allocator, config, db_client, config.authSecret) catch |err| {
        std.log.err("Failed to initialize server: {}", .{err});
        return 1;
    };
    defer serverStop(&server);

    // Start server
    std.log.info("Starting server...", .{});
    serverStart(&server) catch |err| {
        std.log.err("Server failed: {}", .{err});
        return 1;
    };

    return 0;
}
