const std = @import("std");
const root = @import("root.zig");

const Provider = root.Provider;
const ChatRequest = root.ChatRequest;
const ChatResponse = root.ChatResponse;

pub const DisabledProvider = struct {
    name: []const u8,
    reason: []const u8,

    pub fn init(name: []const u8, reason: []const u8) DisabledProvider {
        return .{ .name = name, .reason = reason };
    }

    pub fn provider(self: *DisabledProvider) Provider {
        return .{
            .ptr = @ptrCast(self),
            .vtable = &vtable,
        };
    }

    const vtable = Provider.VTable{
        .chatWithSystem = chatWithSystemImpl,
        .chat = chatImpl,
        .supportsNativeTools = supportsNativeToolsImpl,
        .supports_vision = supportsVisionImpl,
        .getName = getNameImpl,
        .deinit = deinitImpl,
    };

    fn chatWithSystemImpl(
        ptr: *anyopaque,
        allocator: std.mem.Allocator,
        _: ?[]const u8,
        _: []const u8,
        _: []const u8,
        _: f64,
    ) anyerror![]const u8 {
        const self: *DisabledProvider = @ptrCast(@alignCast(ptr));
        return allocator.dupe(u8, self.reason);
    }

    fn chatImpl(
        ptr: *anyopaque,
        allocator: std.mem.Allocator,
        _: ChatRequest,
        _: []const u8,
        _: f64,
    ) anyerror!ChatResponse {
        const self: *DisabledProvider = @ptrCast(@alignCast(ptr));
        return .{ .content = try allocator.dupe(u8, self.reason) };
    }

    fn supportsNativeToolsImpl(_: *anyopaque) bool {
        return false;
    }

    fn supportsVisionImpl(_: *anyopaque) bool {
        return false;
    }

    fn getNameImpl(ptr: *anyopaque) []const u8 {
        const self: *DisabledProvider = @ptrCast(@alignCast(ptr));
        return self.name;
    }

    fn deinitImpl(_: *anyopaque) void {}
};
