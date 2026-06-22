const std = @import("std");
const root = @import("root.zig");

const Provider = root.Provider;
const ChatRequest = root.ChatRequest;
const ChatResponse = root.ChatResponse;
const StreamChatResult = root.StreamChatResult;

pub const PolicyBlockedProvider = struct {
    pub fn init() PolicyBlockedProvider {
        return .{};
    }

    pub fn provider(self: *PolicyBlockedProvider) Provider {
        return .{
            .ptr = @ptrCast(self),
            .vtable = &vtable,
        };
    }

    const vtable = Provider.VTable{
        .chatWithSystem = chatWithSystemImpl,
        .chat = chatImpl,
        .supportsNativeTools = supportsNativeToolsImpl,
        .getName = getNameImpl,
        .deinit = deinitImpl,
        .stream_chat = streamChatImpl,
        .supports_streaming = supportsStreamingImpl,
        .supports_vision = supportsVisionImpl,
    };

    fn chatWithSystemImpl(
        _: *anyopaque,
        _: std.mem.Allocator,
        _: ?[]const u8,
        _: []const u8,
        _: []const u8,
        _: f64,
    ) anyerror![]const u8 {
        return error.ProviderDisabledByRuntimePolicy;
    }

    fn chatImpl(
        _: *anyopaque,
        _: std.mem.Allocator,
        _: ChatRequest,
        _: []const u8,
        _: f64,
    ) anyerror!ChatResponse {
        return error.ProviderDisabledByRuntimePolicy;
    }

    fn streamChatImpl(
        _: *anyopaque,
        _: std.mem.Allocator,
        _: ChatRequest,
        _: []const u8,
        _: f64,
        _: root.StreamCallback,
        _: *anyopaque,
    ) anyerror!StreamChatResult {
        return error.ProviderDisabledByRuntimePolicy;
    }

    fn supportsNativeToolsImpl(_: *anyopaque) bool {
        return false;
    }

    fn supportsStreamingImpl(_: *anyopaque) bool {
        return false;
    }

    fn supportsVisionImpl(_: *anyopaque) bool {
        return false;
    }

    fn getNameImpl(_: *anyopaque) []const u8 {
        return "policy-blocked";
    }

    fn deinitImpl(_: *anyopaque) void {}
};
