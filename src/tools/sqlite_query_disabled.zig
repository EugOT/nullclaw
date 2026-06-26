//! Disabled sqlite_query tool for builds without SQLite support.

const std = @import("std");
const root = @import("root.zig");

const Tool = root.Tool;
const ToolResult = root.ToolResult;
const JsonObjectMap = root.JsonObjectMap;

pub const SqliteQueryTool = struct {
    workspace_dir: []const u8,
    allowed_paths: []const []const u8 = &.{},
    max_result_bytes: usize = 0,
    max_result_rows: u32 = 0,

    pub const tool_name = "sqlite_query";
    pub const tool_description = "SQLite support is not compiled into this nullclaw build.";
    pub const tool_params =
        \\{"type":"object","properties":{},"required":[]}
    ;

    pub const vtable = root.ToolVTable(@This());

    pub fn tool(self: *SqliteQueryTool) Tool {
        return .{
            .ptr = @ptrCast(self),
            .vtable = &vtable,
        };
    }

    pub fn execute(_: *SqliteQueryTool, _: std.mem.Allocator, _: JsonObjectMap) !ToolResult {
        return ToolResult.fail("sqlite_query is unavailable: rebuild with -Dengines=base,sqlite");
    }
};
