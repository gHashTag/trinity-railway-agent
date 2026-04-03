pub const packages = struct {
    pub const @"chilli-0.2.2-c19PrvIyAQAgsL0VkYCKq0DuxU7rZUpRuH991zsyOkYQ" = struct {
        pub const build_root = "/Users/playra/.cache/zig/p/chilli-0.2.2-c19PrvIyAQAgsL0VkYCKq0DuxU7rZUpRuH991zsyOkYQ";
        pub const build_zig = @import("chilli-0.2.2-c19PrvIyAQAgsL0VkYCKq0DuxU7rZUpRuH991zsyOkYQ");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
    pub const @"minish-0.1.0-SQtSTWHkAQACfz3xGuWHU8zbx320vK_47r2yto3Pq0Rf" = struct {
        pub const build_root = "/Users/playra/.cache/zig/p/minish-0.1.0-SQtSTWHkAQACfz3xGuWHU8zbx320vK_47r2yto3Pq0Rf";
        pub const build_zig = @import("minish-0.1.0-SQtSTWHkAQACfz3xGuWHU8zbx320vK_47r2yto3Pq0Rf");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
            .{ "chilli", "chilli-0.2.2-c19PrvIyAQAgsL0VkYCKq0DuxU7rZUpRuH991zsyOkYQ" },
        };
    };
    pub const @"ordered-0.1.0-Gy41sFoCAgDHx9wCElUaCuHvNP7idFfa375M2-UHXMPf" = struct {
        pub const build_root = "/Users/playra/.cache/zig/p/ordered-0.1.0-Gy41sFoCAgDHx9wCElUaCuHvNP7idFfa375M2-UHXMPf";
        pub const build_zig = @import("ordered-0.1.0-Gy41sFoCAgDHx9wCElUaCuHvNP7idFfa375M2-UHXMPf");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
    pub const @"zodd-0.1.0-alpha.3-TJEk3Y7uAQDOkBXaPV_lynH1rF-eDwf9PnVc13MpPFym" = struct {
        pub const build_root = "/Users/playra/.cache/zig/p/zodd-0.1.0-alpha.3-TJEk3Y7uAQDOkBXaPV_lynH1rF-eDwf9PnVc13MpPFym";
        pub const build_zig = @import("zodd-0.1.0-alpha.3-TJEk3Y7uAQDOkBXaPV_lynH1rF-eDwf9PnVc13MpPFym");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
            .{ "minish", "minish-0.1.0-SQtSTWHkAQACfz3xGuWHU8zbx320vK_47r2yto3Pq0Rf" },
            .{ "ordered", "ordered-0.1.0-Gy41sFoCAgDHx9wCElUaCuHvNP7idFfa375M2-UHXMPf" },
        };
    };
};

pub const root_deps: []const struct { []const u8, []const u8 } = &.{
    .{ "zodd", "zodd-0.1.0-alpha.3-TJEk3Y7uAQDOkBXaPV_lynH1rF-eDwf9PnVc13MpPFym" },
};
