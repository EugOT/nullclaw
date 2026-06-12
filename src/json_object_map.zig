const std = @import("std");

pub const ObjectMap = std.json.ObjectMap;
pub const Error = std.mem.Allocator.Error;

fn initParamCount() comptime_int {
    return @typeInfo(@TypeOf(std.json.ObjectMap.init)).@"fn".params.len;
}

fn putParamCount() comptime_int {
    return @typeInfo(@TypeOf(std.json.ObjectMap.put)).@"fn".params.len;
}

fn deinitParamCount() comptime_int {
    return @typeInfo(@TypeOf(std.json.ObjectMap.deinit)).@"fn".params.len;
}

pub fn init(allocator: std.mem.Allocator) Error!ObjectMap {
    if (comptime initParamCount() == 1) {
        return std.json.ObjectMap.init(allocator);
    }
    const keys: []const []const u8 = &.{};
    const values: []const std.json.Value = &.{};
    return try std.json.ObjectMap.init(allocator, keys, values);
}

pub fn put(
    map: *ObjectMap,
    allocator: std.mem.Allocator,
    key: []const u8,
    value: std.json.Value,
) Error!void {
    if (comptime putParamCount() == 3) {
        return map.put(key, value);
    }
    return map.put(allocator, key, value);
}

pub fn deinit(map: *ObjectMap, allocator: std.mem.Allocator) void {
    if (comptime deinitParamCount() == 1) {
        map.deinit();
    } else {
        map.deinit(allocator);
    }
}

test "json object map compatibility init put deinit" {
    var obj = try init(std.testing.allocator);
    defer deinit(&obj, std.testing.allocator);

    try put(&obj, std.testing.allocator, "key", .{ .string = "value" });

    const value = obj.get("key") orelse return error.TestExpectedEqual;
    try std.testing.expect(value == .string);
    try std.testing.expectEqualStrings("value", value.string);
}
