//! Minimal test server for Railway debugging
//! φ² + 1/φ² = 3 | TRINITY

const std = @import("std");

pub fn main() !u8 {
    std.log.info("=== Minimal Test Server Starting ===", .{});

    const allocator = std.heap.page_allocator;
    const port_str = std.process.getEnvVarOwned(allocator, "PORT") catch "3000";
    defer allocator.free(port_str);
    const port = std.fmt.parseInt(u16, port_str, 10) catch 3000;

    std.log.info("PORT from env: {s}", .{port_str});
    std.log.info("Using port: {}", .{port});

    const address = try std.net.Address.parseIp("0.0.0.0", port);
    var server = try std.net.Address.listen(address, .{ .reuse_address = true });

    std.log.info("Listening on {any}", .{address});

    while (true) {
        const connection = server.accept() catch |err| {
            std.log.err("Accept error: {}", .{err});
            continue;
        };
        defer connection.stream.close();

        var buffer: [4096]u8 = undefined;
        _ = connection.stream.read(&buffer) catch continue;

        const response = "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: 17\r\n\r\n{\"status\":\"ok\"}";
        connection.stream.writeAll(response) catch continue;
    }
}
